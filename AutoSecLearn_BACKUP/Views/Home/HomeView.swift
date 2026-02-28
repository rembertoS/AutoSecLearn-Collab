import SwiftUI

struct HomeView: View {
    @Environment(UserProgressManager.self) var progressManager
    @State private var showGreeting = false
    @State private var currentTip = 0

    private let modules = CourseContent.modules
    private let tips = [
        "Always change default credentials on network devices before deployment.",
        "Spanning Tree Protocol prevents Layer 2 loops in networks with redundant paths.",
        "VLANs create logical network segments on a single physical switch.",
        "Netmiko supports SSH automation for multi-vendor network devices.",
        "The DHCP process follows four steps: Discover, Offer, Request, Acknowledge.",
        "Never hardcode credentials in automation scripts - use environment variables.",
        "Firewalls should follow a 'default deny' policy - block everything, then allow what's needed.",
        "WEP encryption is broken and can be cracked in minutes. Always use WPA2 or WPA3.",
        "Start troubleshooting at Layer 1 (Physical) - check cables and link lights first.",
        "Use SNMPv3 in production environments - v1 and v2c send data in plain text."
    ]

    private var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 6..<12: return "Good Morning"
        case 12..<17: return "Good Afternoon"
        case 17..<22: return "Good Evening"
        default: return "Happy Studying"
        }
    }

    private var overallProgress: Double {
        progressManager.overallProgress(modules: modules)
    }

    private var completedModules: Int {
        modules.filter { progressManager.moduleProgress(for: $0) >= 1.0 }.count
    }

    private var totalQuizzesPassed: Int {
        modules.filter { module in
            if let best = progressManager.bestScore(for: module.quiz.id) {
                return best.passed
            }
            return false
        }.count
    }

    /// Modules that user has started but not completed
    private var inProgressModules: [LearningModule] {
        modules.filter {
            let progress = progressManager.moduleProgress(for: $0)
            return progress > 0 && progress < 1.0
        }
    }

    /// The next module the user hasn't started yet
    private var nextModule: LearningModule? {
        modules.first { progressManager.moduleProgress(for: $0) == 0 }
    }

    /// Modules that are fully completed
    private var completedModulesList: [LearningModule] {
        modules.filter { progressManager.moduleProgress(for: $0) >= 1.0 }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    headerSection
                    statsSection
                    xpProgressSection
                    tipOfTheDay

                    // Bookmarked lessons
                    if !bookmarkedLessonPairs.isEmpty {
                        bookmarksSection
                    }

                    // Show in-progress modules
                    if !inProgressModules.isEmpty {
                        continueSection
                    }

                    // Show next module to start
                    if let next = nextModule {
                        upNextSection(module: next)
                    }

                    // Certifications
                    certificationsSection

                    // Explore all
                    if modules.count > inProgressModules.count + completedModulesList.count {
                        exploreMoreSection
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("AutoSec Learn")
            .navigationBarTitleDisplayMode(.large)
        }
    }

    // MARK: - Header Section

    private var headerSection: some View {
        HStack(spacing: 20) {
            VStack(alignment: .leading, spacing: 8) {
                Text(greeting)
                    .font(.title2)
                    .fontWeight(.bold)
                    .opacity(showGreeting ? 1 : 0)
                    .offset(y: showGreeting ? 0 : 10)

                Text("Keep learning about network infrastructure and security.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .opacity(showGreeting ? 1 : 0)
                    .offset(y: showGreeting ? 0 : 10)

                HStack(spacing: 5) {
                    Image(systemName: progressManager.appMode.icon)
                        .font(.caption2)
                    Text(progressManager.appMode.displayName)
                        .font(.caption)
                        .fontWeight(.medium)
                }
                .foregroundStyle(Color(hex: "667eea"))
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(Color(hex: "667eea").opacity(0.1))
                .clipShape(Capsule())
                .opacity(showGreeting ? 1 : 0)
                .offset(y: showGreeting ? 0 : 10)
            }

            Spacer()

            ProgressRing(
                progress: overallProgress,
                lineWidth: 8,
                size: 80,
                gradientColors: [Color(hex: "667eea"), Color(hex: "38ef7d")]
            )
        }
        .padding(20)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .onAppear {
            withAnimation(.easeOut(duration: 0.6).delay(0.2)) {
                showGreeting = true
            }
        }
    }

    // MARK: - Stats Section

    private var statsSection: some View {
        HStack(spacing: 12) {
            StatCard(
                icon: "book.closed.fill",
                value: "\(progressManager.completedLessons.count)",
                label: "Lessons Done",
                color: Color(hex: "667eea")
            )

            StatCard(
                icon: "checkmark.circle.fill",
                value: "\(totalQuizzesPassed)/\(modules.count)",
                label: "Quizzes Passed",
                color: Color(hex: "11998e")
            )

            StatCard(
                icon: "flame.fill",
                value: "\(progressManager.currentStreak)",
                label: "Day Streak",
                color: Color(hex: "fc5c7d")
            )
        }
    }

    // MARK: - Tip of the Day

    private var tipOfTheDay: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: "lightbulb.fill")
                    .foregroundStyle(.yellow)
                Text("Pro Tip")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                Spacer()
                Button {
                    withAnimation(.spring(response: 0.4)) {
                        currentTip = (currentTip + 1) % tips.count
                    }
                } label: {
                    Image(systemName: "arrow.clockwise")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            Text(tips[currentTip])
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .transition(.push(from: .trailing))
                .id(currentTip)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.yellow.opacity(0.08))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .strokeBorder(Color.yellow.opacity(0.2), lineWidth: 1)
                )
        )
    }

    // MARK: - Continue Learning (in-progress only)

    private var continueSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("Continue Learning")
                    .font(.title3)
                    .fontWeight(.bold)
                Spacer()
                NavigationLink("See All") {
                    ModuleListView()
                }
                .font(.subheadline)
                .foregroundStyle(Color(hex: "667eea"))
            }

            ForEach(inProgressModules) { module in
                NavigationLink {
                    ModuleDetailView(module: module)
                } label: {
                    ModuleCard(
                        module: module,
                        progress: progressManager.moduleProgress(for: module)
                    )
                }
                .buttonStyle(.plain)
            }
        }
    }

    // MARK: - Up Next (next module to start)

    private func upNextSection(module: LearningModule) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text(inProgressModules.isEmpty ? "Start Learning" : "Up Next")
                    .font(.title3)
                    .fontWeight(.bold)
                Spacer()
                if !inProgressModules.isEmpty {
                    NavigationLink("See All") {
                        ModuleListView()
                    }
                    .font(.subheadline)
                    .foregroundStyle(Color(hex: "667eea"))
                }
            }

            NavigationLink {
                ModuleDetailView(module: module)
            } label: {
                ModuleCard(
                    module: module,
                    progress: 0
                )
            }
            .buttonStyle(.plain)
        }
    }

    // MARK: - Explore More

    private var exploreMoreSection: some View {
        let remainingCount = modules.count - inProgressModules.count - completedModulesList.count - (nextModule != nil ? 1 : 0)
        return Group {
            if remainingCount > 0 {
                NavigationLink {
                    ModuleListView()
                } label: {
                    HStack(spacing: 12) {
                        Image(systemName: "square.grid.2x2")
                            .font(.title3)
                            .foregroundStyle(Color(hex: "667eea"))
                            .frame(width: 44, height: 44)
                            .background(Color(hex: "667eea").opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 12))

                        VStack(alignment: .leading, spacing: 3) {
                            Text("Explore All Modules")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundStyle(.primary)
                            Text("\(remainingCount) more module\(remainingCount == 1 ? "" : "s") to discover")
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
                }
                .buttonStyle(.plain)
            }
        }
    }

    // MARK: - XP Progress

    private var xpProgressSection: some View {
        HStack(spacing: 12) {
            Image(systemName: progressManager.currentLevel.icon)
                .font(.title3)
                .foregroundStyle(Color(hex: "f7971e"))
                .frame(width: 40, height: 40)
                .background(Color(hex: "f7971e").opacity(0.12))
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(progressManager.currentLevel.rawValue)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    Spacer()
                    Text("\(progressManager.totalXP) XP")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundStyle(.secondary)
                }

                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(Color.gray.opacity(0.15))
                            .frame(height: 6)
                        Capsule()
                            .fill(
                                LinearGradient(
                                    colors: [Color(hex: "f7971e"), Color(hex: "ffd200")],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: geometry.size.width * progressManager.xpProgressInLevel, height: 6)
                    }
                }
                .frame(height: 6)

                if progressManager.xpToNextLevel > 0 {
                    Text("\(progressManager.xpToNextLevel) XP to next level")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(14)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    // MARK: - Bookmarks

    private var bookmarkedLessonPairs: [(module: LearningModule, lesson: Lesson)] {
        var pairs: [(module: LearningModule, lesson: Lesson)] = []
        for module in modules {
            for lesson in module.lessons {
                if progressManager.isBookmarked(lesson.id) {
                    pairs.append((module: module, lesson: lesson))
                }
            }
        }
        return pairs
    }

    private func gradientColors(for moduleId: String) -> [Color] {
        switch moduleId {
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

    private var bookmarksSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 8) {
                Image(systemName: "bookmark.fill")
                    .foregroundStyle(Color(hex: "667eea"))
                Text("Bookmarked")
                    .font(.title3)
                    .fontWeight(.bold)
            }

            ForEach(bookmarkedLessonPairs, id: \.lesson.id) { pair in
                NavigationLink {
                    LessonView(
                        lesson: pair.lesson,
                        moduleId: pair.module.id,
                        gradientColors: gradientColors(for: pair.module.id)
                    )
                } label: {
                    HStack(spacing: 12) {
                        Image(systemName: "bookmark.fill")
                            .foregroundStyle(gradientColors(for: pair.module.id)[0])

                        VStack(alignment: .leading, spacing: 2) {
                            Text(pair.lesson.title)
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundStyle(.primary)
                            Text(pair.module.title)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }

                        Spacer()

                        if progressManager.isLessonComplete(pair.lesson.id) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(.green)
                                .font(.caption)
                        }

                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding(12)
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                }
                .buttonStyle(.plain)
            }
        }
    }

    // MARK: - Industry Certifications

    private let certColumns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    private var certificationsSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 8) {
                Image(systemName: "rosette")
                    .foregroundStyle(Color(hex: "f7971e"))
                Text("Industry Certifications")
                    .font(.title3)
                    .fontWeight(.bold)
            }

            Text("Put your knowledge to work with these recognized certifications.")
                .font(.caption)
                .foregroundStyle(.secondary)

            LazyVGrid(columns: certColumns, spacing: 12) {
                ForEach(Certification.featured) { cert in
                    CertificationCard(cert: cert)
                }
            }
        }
    }
}

// MARK: - Certification Model

struct Certification: Identifiable {
    let id = UUID()
    let name: String
    let provider: String
    let icon: String
    let color: Color
    let url: String
    let tagline: String

    static let featured: [Certification] = [
        Certification(
            name: "CompTIA Network+",
            provider: "CompTIA",
            icon: "network",
            color: Color(hex: "e53935"),
            url: "https://www.comptia.org/certifications/network",
            tagline: "Validate your networking skills"
        ),
        Certification(
            name: "CompTIA Security+",
            provider: "CompTIA",
            icon: "lock.shield",
            color: Color(hex: "e53935"),
            url: "https://www.comptia.org/certifications/security",
            tagline: "Entry-level cybersecurity cert"
        ),
        Certification(
            name: "Cisco CCNA",
            provider: "Cisco",
            icon: "wifi.router",
            color: Color(hex: "049fd9"),
            url: "https://www.cisco.com/site/us/en/learn/training-certifications/certifications/enterprise/ccna/index.html",
            tagline: "Cisco networking fundamentals"
        ),
        Certification(
            name: "AWS Cloud Practitioner",
            provider: "Amazon",
            icon: "cloud.fill",
            color: Color(hex: "ff9900"),
            url: "https://aws.amazon.com/certification/certified-cloud-practitioner/",
            tagline: "Cloud infrastructure basics"
        ),
        Certification(
            name: "Google IT Support",
            provider: "Google",
            icon: "desktopcomputer",
            color: Color(hex: "4285f4"),
            url: "https://grow.google/certificates/it-support/",
            tagline: "Google career certificate"
        ),
        Certification(
            name: "Google Cybersecurity",
            provider: "Google",
            icon: "shield.checkered",
            color: Color(hex: "34a853"),
            url: "https://grow.google/certificates/cybersecurity/",
            tagline: "Google security certificate"
        ),
        Certification(
            name: "Cisco CyberOps",
            provider: "Cisco",
            icon: "eye.trianglebadge.exclamationmark",
            color: Color(hex: "049fd9"),
            url: "https://www.cisco.com/site/us/en/learn/training-certifications/certifications/cyberops/cyberops-associate/index.html",
            tagline: "Security operations analyst"
        ),
        Certification(
            name: "Azure Fundamentals",
            provider: "Microsoft",
            icon: "icloud.fill",
            color: Color(hex: "0078d4"),
            url: "https://learn.microsoft.com/en-us/credentials/certifications/azure-fundamentals/",
            tagline: "Microsoft cloud essentials"
        )
    ]
}

// MARK: - Certification Card

struct CertificationCard: View {
    let cert: Certification

    var body: some View {
        Link(destination: URL(string: cert.url)!) {
            VStack(alignment: .leading, spacing: 10) {
                HStack(spacing: 10) {
                    Image(systemName: cert.icon)
                        .font(.title3)
                        .foregroundStyle(.white)
                        .frame(width: 40, height: 40)
                        .background(cert.color)
                        .clipShape(RoundedRectangle(cornerRadius: 10))

                    Spacer()

                    Image(systemName: "arrow.up.right")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                VStack(alignment: .leading, spacing: 3) {
                    Text(cert.name)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(.primary)
                        .lineLimit(1)

                    Text(cert.provider)
                        .font(.caption2)
                        .fontWeight(.medium)
                        .foregroundStyle(cert.color)

                    Text(cert.tagline)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }
            }
            .padding(14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .strokeBorder(cert.color.opacity(0.15), lineWidth: 1)
            )
        }
    }
}

#Preview {
    HomeView()
        .environment(UserProgressManager())
        .environment(SoundManager())
        .environment(NotificationManager())
}
