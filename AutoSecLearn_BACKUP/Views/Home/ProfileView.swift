import SwiftUI

struct ProfileView: View {
    @Environment(UserProgressManager.self) var progressManager
    @Environment(SoundManager.self) var soundManager
    @Environment(NotificationManager.self) var notificationManager
    @State private var showResetAlert = false
    @State private var animateIn = false

    private let modules = CourseContent.modules

    private var totalLessons: Int {
        modules.reduce(0) { $0 + $1.lessons.count }
    }

    private var completedLessonsCount: Int {
        progressManager.completedLessons.count
    }

    private var quizzesPassed: Int {
        modules.filter { module in
            progressManager.bestScore(for: module.quiz.id)?.passed == true
        }.count
    }

    private var averageScore: Double {
        let scores = modules.compactMap { progressManager.bestScore(for: $0.quiz.id)?.percentage }
        guard !scores.isEmpty else { return 0 }
        return scores.reduce(0, +) / Double(scores.count)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    profileHeader
                    xpLevelCard
                    overallProgressCard
                    BadgeGridView(unlockedBadges: progressManager.unlockedBadges)
                    moduleBreakdown
                    quizHistory
                    settingsSection

                    if progressManager.allModulesCompleted {
                        certificateSection
                    }

                    teamSection
                    resetSection
                }
                .padding(.horizontal)
                .padding(.bottom, 30)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Profile")
        }
    }

    // MARK: - Profile Header

    private var profileHeader: some View {
        VStack(spacing: 16) {
            Image(systemName: "person.crop.circle.fill")
                .font(.system(size: 70))
                .foregroundStyle(
                    LinearGradient(
                        colors: [Color(hex: "667eea"), Color(hex: "764ba2")],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .scaleEffect(animateIn ? 1 : 0.5)
                .opacity(animateIn ? 1 : 0)

            VStack(spacing: 4) {
                Text("AutoSec Learner")
                    .font(.title2)
                    .fontWeight(.bold)

                Text("FIU - COP4655")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.top, 10)
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.1)) {
                animateIn = true
            }
        }
    }

    // MARK: - XP Level Card

    private var xpLevelCard: some View {
        VStack(spacing: 14) {
            HStack(spacing: 12) {
                Image(systemName: progressManager.currentLevel.icon)
                    .font(.title)
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color(hex: "f7971e"), Color(hex: "ffd200")],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 50, height: 50)
                    .background(Color(hex: "f7971e").opacity(0.12))
                    .clipShape(Circle())

                VStack(alignment: .leading, spacing: 4) {
                    Text(progressManager.currentLevel.rawValue)
                        .font(.title3)
                        .fontWeight(.bold)

                    Text("\(progressManager.totalXP) XP total")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 2) {
                    Image(systemName: "flame.fill")
                        .foregroundStyle(progressManager.currentStreak > 0 ? .orange : .gray)
                    Text("\(progressManager.currentStreak) day\(progressManager.currentStreak == 1 ? "" : "s")")
                        .font(.caption2)
                        .fontWeight(.medium)
                        .foregroundStyle(.secondary)
                }
            }

            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.gray.opacity(0.15))
                        .frame(height: 8)
                    Capsule()
                        .fill(
                            LinearGradient(
                                colors: [Color(hex: "f7971e"), Color(hex: "ffd200")],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geometry.size.width * progressManager.xpProgressInLevel, height: 8)
                }
            }
            .frame(height: 8)

            if progressManager.xpToNextLevel > 0 {
                Text("\(progressManager.xpToNextLevel) XP to reach \(nextLevelName)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            } else {
                Text("Max level reached!")
                    .font(.caption)
                    .foregroundStyle(Color(hex: "f7971e"))
                    .fontWeight(.medium)
            }
        }
        .padding(20)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    private var nextLevelName: String {
        guard let nextIndex = XPLevel.allCases.firstIndex(of: progressManager.currentLevel),
              nextIndex + 1 < XPLevel.allCases.count else { return "" }
        return XPLevel.allCases[nextIndex + 1].rawValue
    }

    // MARK: - Overall Progress

    private var overallProgressCard: some View {
        HStack(spacing: 20) {
            ProgressRing(
                progress: progressManager.overallProgress(modules: modules),
                lineWidth: 8,
                size: 90,
                gradientColors: [Color(hex: "667eea"), Color(hex: "38ef7d")]
            )

            VStack(alignment: .leading, spacing: 10) {
                ProgressStat(label: "Lessons", value: "\(completedLessonsCount)/\(totalLessons)", color: Color(hex: "667eea"))
                ProgressStat(label: "Quizzes Passed", value: "\(quizzesPassed)/\(modules.count)", color: .green)
                ProgressStat(label: "Avg. Score", value: "\(Int(averageScore))%", color: .orange)
                ProgressStat(label: "Total Attempts", value: "\(progressManager.quizAttempts.count)", color: Color(hex: "fc5c7d"))
            }
        }
        .padding(20)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    // MARK: - Module Breakdown

    private var moduleBreakdown: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Module Progress")
                .font(.title3)
                .fontWeight(.bold)

            ForEach(modules) { module in
                ModuleProgressRow(
                    module: module,
                    lessonProgress: progressManager.moduleProgress(for: module),
                    bestScore: progressManager.bestScore(for: module.quiz.id)
                )
            }
        }
    }

    // MARK: - Quiz History

    private var quizHistory: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Recent Quiz Attempts")
                .font(.title3)
                .fontWeight(.bold)

            if progressManager.quizAttempts.isEmpty {
                VStack(spacing: 8) {
                    Image(systemName: "chart.bar")
                        .font(.system(size: 30))
                        .foregroundStyle(.secondary)
                    Text("No quiz attempts yet")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Text("Complete a module quiz to see your history here.")
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 24)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 16))
            } else {
                ForEach(progressManager.quizAttempts.suffix(5).reversed()) { attempt in
                    QuizAttemptRow(attempt: attempt, modules: modules)
                }
            }
        }
    }

    // MARK: - Settings

    private var settingsSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Settings")
                .font(.title3)
                .fontWeight(.bold)

            // App Mode
            HStack(spacing: 14) {
                Image(systemName: progressManager.appMode.icon)
                    .font(.title2)
                    .foregroundStyle(Color(hex: "667eea"))
                    .frame(width: 44, height: 44)
                    .background(Color(hex: "667eea").opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 12))

                VStack(alignment: .leading, spacing: 4) {
                    Text("App Mode")
                        .font(.subheadline)
                        .fontWeight(.medium)

                    Text(progressManager.appMode.description)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }

                Spacer()

                Picker("", selection: Binding(
                    get: { progressManager.appMode },
                    set: { progressManager.setMode($0) }
                )) {
                    ForEach(AppMode.allCases, id: \.self) { mode in
                        Text(mode.displayName).tag(mode)
                    }
                }
                .pickerStyle(.menu)
                .tint(Color(hex: "667eea"))
            }
            .padding(14)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 16))

            // Sound Effects
            HStack(spacing: 14) {
                Image(systemName: soundManager.soundEnabled ? "speaker.wave.2.fill" : "speaker.slash.fill")
                    .font(.title2)
                    .foregroundStyle(Color(hex: "11998e"))
                    .frame(width: 44, height: 44)
                    .background(Color(hex: "11998e").opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 12))

                VStack(alignment: .leading, spacing: 4) {
                    Text("Sound Effects")
                        .font(.subheadline)
                        .fontWeight(.medium)

                    Text("Play sounds for quiz answers and achievements")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Toggle("", isOn: Binding(
                    get: { soundManager.soundEnabled },
                    set: { soundManager.soundEnabled = $0 }
                ))
                .tint(Color(hex: "11998e"))
            }
            .padding(14)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 16))

            // Study Reminders
            VStack(spacing: 12) {
                HStack(spacing: 14) {
                    Image(systemName: "bell.badge.fill")
                        .font(.title2)
                        .foregroundStyle(Color(hex: "fc5c7d"))
                        .frame(width: 44, height: 44)
                        .background(Color(hex: "fc5c7d").opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 12))

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Study Reminders")
                            .font(.subheadline)
                            .fontWeight(.medium)

                        Text("Get a daily reminder to study")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }

                    Spacer()

                    Toggle("", isOn: Binding(
                        get: { notificationManager.remindersEnabled },
                        set: { newValue in
                            Task {
                                if newValue {
                                    await notificationManager.enableReminders()
                                } else {
                                    notificationManager.disableReminders()
                                }
                            }
                        }
                    ))
                    .tint(Color(hex: "fc5c7d"))
                }

                if notificationManager.remindersEnabled {
                    HStack {
                        Text("Reminder Time")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Spacer()
                        DatePicker(
                            "",
                            selection: Binding(
                                get: {
                                    var components = DateComponents()
                                    components.hour = notificationManager.reminderHour
                                    components.minute = notificationManager.reminderMinute
                                    return Calendar.current.date(from: components) ?? Date()
                                },
                                set: { date in
                                    let components = Calendar.current.dateComponents([.hour, .minute], from: date)
                                    notificationManager.reminderHour = components.hour ?? 19
                                    notificationManager.reminderMinute = components.minute ?? 0
                                    notificationManager.scheduleReminder()
                                }
                            ),
                            displayedComponents: .hourAndMinute
                        )
                        .labelsHidden()
                    }
                    .padding(.leading, 58)
                }
            }
            .padding(14)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }

    // MARK: - Certificate

    private var certificateSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Certificate")
                .font(.title3)
                .fontWeight(.bold)

            NavigationLink {
                CertificateView()
            } label: {
                HStack(spacing: 14) {
                    Image(systemName: "seal.fill")
                        .font(.title2)
                        .foregroundStyle(
                            LinearGradient(
                                colors: [Color(hex: "f7971e"), Color(hex: "ffd200")],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 44, height: 44)
                        .background(Color(hex: "f7971e").opacity(0.12))
                        .clipShape(RoundedRectangle(cornerRadius: 12))

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Completion Certificate")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundStyle(.primary)

                        Text("View and share your achievement")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }

                    Spacer()

                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding(14)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .strokeBorder(
                            LinearGradient(
                                colors: [Color(hex: "f7971e"), Color(hex: "ffd200")],
                                startPoint: .leading,
                                endPoint: .trailing
                            ),
                            lineWidth: 1.5
                        )
                )
            }
            .buttonStyle(.plain)
        }
    }

    // MARK: - Team Section

    private var teamSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Development Team")
                .font(.title3)
                .fontWeight(.bold)

            VStack(spacing: 8) {
                TeamMemberRow(name: "Bryan Puckett", role: "iOS Developer")
                TeamMemberRow(name: "Giovanna Curry", role: "Project Lead / iOS Developer")
                TeamMemberRow(name: "Rembert Silva", role: "iOS Developer")
                TeamMemberRow(name: "Meagan Alfaro", role: "iOS Developer")
            }

            HStack(spacing: 6) {
                Image(systemName: "building.columns.fill")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text("Florida International University - Spring 2026")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding(.top, 4)
        }
    }

    // MARK: - Reset

    private var resetSection: some View {
        Button(role: .destructive) {
            showResetAlert = true
        } label: {
            HStack {
                Image(systemName: "arrow.counterclockwise")
                Text("Reset All Progress")
            }
            .font(.subheadline)
            .foregroundStyle(.red)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(Color.red.opacity(0.08))
            .clipShape(RoundedRectangle(cornerRadius: 14))
        }
        .alert("Reset Progress?", isPresented: $showResetAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Reset", role: .destructive) {
                progressManager.resetProgress()
            }
        } message: {
            Text("This will erase all your lesson completions and quiz scores. This action cannot be undone.")
        }
    }
}

// MARK: - Supporting Views

struct ProgressStat: View {
    let label: String
    let value: String
    let color: Color

    var body: some View {
        HStack {
            Circle()
                .fill(color)
                .frame(width: 8, height: 8)
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
            Spacer()
            Text(value)
                .font(.caption)
                .fontWeight(.semibold)
        }
    }
}

struct ModuleProgressRow: View {
    let module: LearningModule
    let lessonProgress: Double
    let bestScore: QuizAttempt?

    private var gradientColors: [Color] {
        switch module.id {
        case "switch_1": return [Color(hex: "667eea"), Color(hex: "764ba2")]
        case "router": return [Color(hex: "11998e"), Color(hex: "38ef7d")]
        case "failover_switch": return [Color(hex: "fc5c7d"), Color(hex: "6a82fb")]
        case "python_automation": return [Color(hex: "f7971e"), Color(hex: "ffd200")]
        case "firewall_acl": return [Color(hex: "e53935"), Color(hex: "d32f2f")]
        case "wireless_security": return [Color(hex: "00bcd4"), Color(hex: "0097a7")]
        case "network_monitoring": return [Color(hex: "26a69a"), Color(hex: "00796b")]
        case "vpn_remote": return [Color(hex: "5c6bc0"), Color(hex: "3949ab")]
        case "dns_services": return [Color(hex: "ff8f00"), Color(hex: "e65100")]
        case "zero_trust": return [Color(hex: "7b1fa2"), Color(hex: "4a148c")]
        default: return [Color(hex: "667eea"), Color(hex: "764ba2")]
        }
    }

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: module.icon)
                .font(.title3)
                .foregroundStyle(gradientColors[0])
                .frame(width: 40, height: 40)
                .background(gradientColors[0].opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 10))

            VStack(alignment: .leading, spacing: 6) {
                Text(module.title)
                    .font(.subheadline)
                    .fontWeight(.medium)

                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(Color.gray.opacity(0.15))
                            .frame(height: 5)
                        Capsule()
                            .fill(LinearGradient(colors: gradientColors, startPoint: .leading, endPoint: .trailing))
                            .frame(width: geometry.size.width * lessonProgress, height: 5)
                    }
                }
                .frame(height: 5)
            }

            VStack(alignment: .trailing, spacing: 2) {
                Text("\(Int(lessonProgress * 100))%")
                    .font(.caption)
                    .fontWeight(.semibold)

                if let score = bestScore {
                    Text("Quiz: \(Int(score.percentage))%")
                        .font(.caption2)
                        .foregroundStyle(score.passed ? .green : .orange)
                }
            }
        }
        .padding(12)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}

struct QuizAttemptRow: View {
    let attempt: QuizAttempt
    let modules: [LearningModule]

    private var quizTitle: String {
        modules.first { $0.quiz.id == attempt.quizId }?.quiz.title ?? "Quiz"
    }

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: attempt.passed ? "checkmark.circle.fill" : "xmark.circle.fill")
                .foregroundStyle(attempt.passed ? .green : .red)

            VStack(alignment: .leading, spacing: 2) {
                Text(quizTitle)
                    .font(.caption)
                    .fontWeight(.medium)
                Text(attempt.date, style: .relative)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Text("\(attempt.score)/\(attempt.totalQuestions)")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(attempt.passed ? .green : .red)
        }
        .padding(12)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct TeamMemberRow: View {
    let name: String
    let role: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "person.circle.fill")
                .font(.title2)
                .foregroundStyle(Color(hex: "667eea").opacity(0.6))

            VStack(alignment: .leading, spacing: 2) {
                Text(name)
                    .font(.subheadline)
                    .fontWeight(.medium)
                Text(role)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
        .padding(12)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    ProfileView()
        .environment(UserProgressManager())
        .environment(SoundManager())
        .environment(NotificationManager())
}
