import SwiftUI

// MARK: - CertDetailView
// This view shows the full details for a single certification.
// It's displayed when the user taps a cert card in the list.
// Layout: hero header (gradient) → exam format section → details section.
struct CertDetailView: View {
    // The certification to display — passed in from CertListView
    let cert: Certification

    // Controls the spring entrance animation when the view appears
    @State private var animateIn = false

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Gradient hero header with icon, name, and vendor
                heroHeader

                // Exam format info (questions, time, passing score)
                examInfoSection

                // Description and prerequisites
                detailsSection
            }
        }
        // Light grouped background behind the scroll content
        .background(Color(.systemGroupedBackground))
        // Use inline title so it doesn't conflict with the hero header
        .navigationBarTitleDisplayMode(.inline)
        // Trigger the entrance animation when the view loads
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                animateIn = true
            }
        }
    }

    // MARK: - Hero Header
    // Large gradient banner at the top of the detail page.
    // Shows the cert icon, name, vendor, exam code, and cost.
    private var heroHeader: some View {
        VStack(spacing: 12) {
            // Large icon inside a rounded square with semi-transparent white background
            Image(systemName: cert.icon)
                .font(.system(size: 50))
                .foregroundStyle(.white)
                .frame(width: 90, height: 90)
                .background(.white.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 20))

            // Certification name
            Text(cert.name)
                .font(AppTheme.title)
                .foregroundStyle(.white)

            // Vendor / issuing organization
            Text(cert.vendor)
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.85))

            // Bottom row: exam code on the left, cost on the right
            HStack(spacing: 16) {
                // Exam code label with document icon
                Label(cert.examCode, systemImage: "doc.text")
                    .font(AppTheme.caption)
                    .foregroundStyle(.white.opacity(0.8))

                // Cost label with dollar sign icon
                Label(cert.cost, systemImage: "dollarsign.circle")
                    .font(AppTheme.caption)
                    .foregroundStyle(.white.opacity(0.8))
            }
        }
        .padding(.vertical, 30)
        // Full-width gradient background using the cert's unique color pair
        .frame(maxWidth: .infinity)
        .background(
            LinearGradient(
                colors: [
                    Color(hex: cert.gradientHex.0),
                    Color(hex: cert.gradientHex.1)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        // Spring animation: scales and fades in when the view appears
        .scaleEffect(animateIn ? 1 : 0.95)
        .opacity(animateIn ? 1 : 0)
    }

    // MARK: - Exam Info Section
    // Displays key exam details in individual card rows.
    // Each row has an icon, a label, and a value.
    private var examInfoSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Section title
            Text("Exam Format")
                .font(.title3.bold())
                .padding(.horizontal, AppTheme.paddingMedium)

            // Number of questions row
            infoRow(
                icon: "questionmark.circle.fill",
                label: "Questions",
                value: cert.numberOfQuestions
            )

            // Time limit row
            infoRow(
                icon: "clock.fill",
                label: "Time Limit",
                value: cert.timeLimit
            )

            // Passing score row
            infoRow(
                icon: "checkmark.seal.fill",
                label: "Passing Score",
                value: cert.passingScore
            )
        }
        .padding(.top, AppTheme.paddingLarge)
    }

    // MARK: - Details Section
    // Shows the certification description and prerequisites.
    private var detailsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Section title
            Text("Details")
                .font(.title3.bold())
                .padding(.horizontal, AppTheme.paddingMedium)

            // Description card — multi-line text explaining what the cert covers
            VStack(alignment: .leading, spacing: 8) {
                Text("Description")
                    .font(AppTheme.headline)
                Text(cert.description)
                    .font(AppTheme.body)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .cardStyle()
            .padding(.horizontal, AppTheme.paddingMedium)

            // Prerequisites card — what you should have before taking the exam
            VStack(alignment: .leading, spacing: 8) {
                Text("Prerequisites")
                    .font(AppTheme.headline)
                Text(cert.prerequisites)
                    .font(AppTheme.body)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .cardStyle()
            .padding(.horizontal, AppTheme.paddingMedium)
        }
        .padding(.top, AppTheme.paddingLarge)
        .padding(.bottom, AppTheme.paddingLarge)
    }

    // MARK: - Info Row Helper
    // Reusable row component for the exam format section.
    // Each row shows: [colored icon] Label ... Value
    // Wrapped in a card style for consistent appearance.
    private func infoRow(icon: String, label: String, value: String) -> some View {
        HStack(spacing: 12) {
            // Icon inside a small gradient-colored rounded square
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundStyle(.white)
                .frame(width: 36, height: 36)
                .background(
                    LinearGradient(
                        colors: [
                            Color(hex: cert.gradientHex.0),
                            Color(hex: cert.gradientHex.1)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: 8))

            // Label text (e.g. "Questions", "Time Limit")
            Text(label)
                .font(AppTheme.headline)

            Spacer()

            // Value text (e.g. "Up to 90", "90 minutes")
            Text(value)
                .font(AppTheme.body)
                .foregroundStyle(.secondary)
        }
        // Card background with padding for consistent styling
        .cardStyle()
        .padding(.horizontal, AppTheme.paddingMedium)
    }
}
