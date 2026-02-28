import UserNotifications
import SwiftUI

@Observable
class NotificationManager {
    var remindersEnabled: Bool = false {
        didSet { UserDefaults.standard.set(remindersEnabled, forKey: "remindersEnabled") }
    }
    var reminderHour: Int = 19 {
        didSet {
            UserDefaults.standard.set(reminderHour, forKey: "reminderHour")
            if remindersEnabled { scheduleReminder() }
        }
    }
    var reminderMinute: Int = 0 {
        didSet {
            UserDefaults.standard.set(reminderMinute, forKey: "reminderMinute")
            if remindersEnabled { scheduleReminder() }
        }
    }

    private let notificationId = "dailyStudyReminder"

    init() {
        remindersEnabled = UserDefaults.standard.bool(forKey: "remindersEnabled")
        reminderHour = UserDefaults.standard.object(forKey: "reminderHour") as? Int ?? 19
        reminderMinute = UserDefaults.standard.object(forKey: "reminderMinute") as? Int ?? 0
    }

    func requestPermission() async -> Bool {
        do {
            return try await UNUserNotificationCenter.current()
                .requestAuthorization(options: [.alert, .badge, .sound])
        } catch {
            return false
        }
    }

    func enableReminders() async {
        let granted = await requestPermission()
        await MainActor.run {
            remindersEnabled = granted
            if granted { scheduleReminder() }
        }
    }

    func disableReminders() {
        remindersEnabled = false
        UNUserNotificationCenter.current()
            .removePendingNotificationRequests(withIdentifiers: [notificationId])
    }

    func scheduleReminder() {
        UNUserNotificationCenter.current()
            .removePendingNotificationRequests(withIdentifiers: [notificationId])

        let content = UNMutableNotificationContent()
        content.title = "Time to Study!"
        content.body = "Keep your streak alive. Open AutoSec Learn and complete a lesson today."
        content.sound = .default

        var dateComponents = DateComponents()
        dateComponents.hour = reminderHour
        dateComponents.minute = reminderMinute

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: notificationId, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request)
    }
}
