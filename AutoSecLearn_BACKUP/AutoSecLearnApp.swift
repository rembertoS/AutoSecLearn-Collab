import SwiftUI

@main
struct AutoSecLearnApp: App {
    @State private var progressManager = UserProgressManager()
    @State private var soundManager = SoundManager()
    @State private var notificationManager = NotificationManager()
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false

    var body: some Scene {
        WindowGroup {
            if hasCompletedOnboarding {
                ContentView()
                    .environment(progressManager)
                    .environment(soundManager)
                    .environment(notificationManager)
            } else {
                OnboardingView(hasCompletedOnboarding: $hasCompletedOnboarding)
                    .environment(progressManager)
                    .environment(soundManager)
                    .environment(notificationManager)
            }
        }
    }
}
