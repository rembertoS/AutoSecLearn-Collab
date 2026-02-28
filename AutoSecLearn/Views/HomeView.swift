import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {

                    // MARK: - Hero Banner
                    heroSection

                    // MARK: - About
                    aboutSection

                    // MARK: - Features
                    featuresSection

                    // MARK: - Team
                    teamSection

                    // MARK: - Footer
                    footerSection
                }
                .padding()
            }
            .navigationTitle("AutoSecLearn")
            .background(Color(.systemGroupedBackground))
        }
    }

    // MARK: - Hero Section

    private var heroSection: some View {
        VStack(spacing: 12) {
            Image(systemName: "shield.lock.fill")
                .font(.system(size: 56))
                .foregroundStyle(AppTheme.primaryGradient)

            Text("AutoSecLearn")
                .font(AppTheme.largeTitle)

            Text("Network Infrastructure & Cybersecurity")
                .font(AppTheme.caption)
                .foregroundStyle(.secondary)
                .textCase(.uppercase)
                .tracking(1.5)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 32)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.cornerRadius)
                .fill(.ultraThinMaterial)
        )
    }

    // MARK: - About Section

    private var aboutSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Label("About", systemImage: "info.circle.fill")
                .font(AppTheme.title)

            Text("An educational iOS app designed to teach the fundamentals of network infrastructure and cybersecurity. Built for COP4655 — Mobile Application Development at Florida International University, Spring 2026.")
                .font(AppTheme.body)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardStyle()
    }

    // MARK: - Features Section

    private var featuresSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Label("Features", systemImage: "sparkles")
                .font(AppTheme.title)

            Text("Coming soon — each team member will add their own features!")
                .font(AppTheme.body)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardStyle()
    }

    // MARK: - Team Section

    private var teamSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Label("Team", systemImage: "person.3.fill")
                .font(AppTheme.title)

            TeamMemberRow(name: "Bryan Puckett", role: "Project Base / App Structure", icon: "hammer.fill")
            TeamMemberRow(name: "Giovanna Curry", role: "Section 1", icon: "1.circle.fill")
            TeamMemberRow(name: "Rembert Silva", role: "Section 2", icon: "2.circle.fill")
            TeamMemberRow(name: "Meagan Alfaro", role: "Section 3", icon: "3.circle.fill")
            TeamMemberRow(name: "Alec Rivera", role: "Section 4", icon: "4.circle.fill")
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardStyle()
    }

    // MARK: - Footer

    private var footerSection: some View {
        VStack(spacing: 6) {
            Text("COP4655 — Spring 2026")
                .font(AppTheme.caption)
                .foregroundStyle(.secondary)

            Text("Florida International University")
                .font(AppTheme.caption)
                .foregroundStyle(.tertiary)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 8)
        .padding(.bottom, 24)
    }
}

// MARK: - Team Member Row

private struct TeamMemberRow: View {
    let name: String
    let role: String
    let icon: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(AppTheme.primary)
                .frame(width: 28)

            VStack(alignment: .leading, spacing: 2) {
                Text(name)
                    .font(AppTheme.headline)

                Text(role)
                    .font(AppTheme.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    HomeView()
}
