import SwiftUI

// MARK: - CertListView
// Main view for Alec's tab. Displays a scrollable list of cybersecurity
// certification recommendation cards. Tapping a card navigates to the
// detail page for that certification.
struct CertListView: View {
    var body: some View {
        // NavigationStack enables navigation to detail views when cards are tapped
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Header section with icon, title, and subtitle
                    headerSection

                    // Loop through all certifications and create a tappable card for each
                    ForEach(CertData.certifications) { cert in
                        // NavigationLink wraps each card so tapping it pushes the detail view
                        NavigationLink {
                            CertDetailView(cert: cert)
                        } label: {
                            CertCard(cert: cert)
                        }
                        // Plain button style prevents the default blue highlight on tap
                        .buttonStyle(.plain)
                    }

                    // Extra space at the bottom so content isn't cut off by the tab bar
                    Spacer(minLength: 20)
                }
                .padding()
            }
            // Navigation bar title shown at the top of the screen
            .navigationTitle("Alec's Certs")
            // Light gray background behind the scroll content
            .background(Color(.systemGroupedBackground))
        }
    }

    // MARK: - Header Section
    // Introductory banner at the top of the list with a medal icon,
    // a title, and a short description of what this tab is about.
    private var headerSection: some View {
        VStack(spacing: 8) {
            // Medal icon styled with the app's teal-to-blue gradient
            Image(systemName: "medal.fill")
                .font(.system(size: 44))
                .foregroundStyle(AppTheme.primaryGradient)

            // Main title for the section
            Text("Certification Recommendations")
                .font(AppTheme.title)
                .multilineTextAlignment(.center)

            // Subtitle explaining what the user will find here
            Text("Beginner-friendly certifications to launch your cybersecurity career.")
                .font(AppTheme.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        // Padding inside the header card
        .padding(.vertical, AppTheme.paddingLarge)
        .padding(.horizontal, AppTheme.paddingMedium)
        // Full width so it stretches across the screen
        .frame(maxWidth: .infinity)
        // Rounded card background with thin material effect
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.cornerRadius))
    }
}

// MARK: - CertCard
// A single gradient card representing one certification.
// Shows the cert icon, name, vendor, exam code, and cost.
// Animates in with a spring effect when it first appears.
private struct CertCard: View {
    // The certification this card represents
    let cert: Certification

    // Controls the spring entrance animation — starts false, set to true on appear
    @State private var isAppearing = false

    // Build the two gradient colors from the cert's hex values.
    // Uses the Color(hex:) extension defined in Remberto's ModuleListView.
    private var gradientColors: [Color] {
        [Color(hex: cert.gradientHex.0), Color(hex: cert.gradientHex.1)]
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Top row: cert icon on the left, chevron arrow on the right
            HStack {
                // Icon inside a semi-transparent white rounded square
                Image(systemName: cert.icon)
                    .font(.system(size: 24))
                    .foregroundStyle(.white)
                    .frame(width: 50, height: 50)
                    .background(.white.opacity(0.2))
                    .clipShape(RoundedRectangle(cornerRadius: 12))

                Spacer()

                // Chevron indicates the card is tappable
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.white.opacity(0.7))
            }

            // Certification name (bold, white, up to 2 lines)
            Text(cert.name)
                .font(.title3.bold())
                .foregroundStyle(.white)
                .lineLimit(2)

            // Vendor name below the cert name
            Text(cert.vendor)
                .font(AppTheme.caption)
                .foregroundStyle(.white.opacity(0.85))

            // Bottom row: exam code and cost with small icons
            HStack(spacing: 12) {
                // Exam code (e.g. "N10-009")
                Label(cert.examCode, systemImage: "doc.text")
                    .font(.caption2)
                    .foregroundStyle(.white.opacity(0.75))

                // Exam cost (e.g. "$369 USD")
                Label(cert.cost, systemImage: "dollarsign.circle")
                    .font(.caption2)
                    .foregroundStyle(.white.opacity(0.75))
            }
        }
        // Padding inside the card
        .padding(AppTheme.paddingLarge)
        // Full width so the card stretches edge to edge
        .frame(maxWidth: .infinity, alignment: .leading)
        // Gradient background using the cert's unique color pair
        .background(
            LinearGradient(
                colors: gradientColors,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        // Rounded corners for the card shape
        .clipShape(RoundedRectangle(cornerRadius: 20))
        // Drop shadow using the first gradient color for a colored glow effect
        .shadow(color: gradientColors[0].opacity(0.4), radius: 10, x: 0, y: 5)
        // Spring entrance animation: card scales up and fades in
        .scaleEffect(isAppearing ? 1 : 0.9)
        .opacity(isAppearing ? 1 : 0)
        .onAppear {
            // Trigger the animation when the card appears on screen
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                isAppearing = true
            }
        }
    }
}
