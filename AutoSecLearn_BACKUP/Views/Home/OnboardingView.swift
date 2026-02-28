import SwiftUI

struct OnboardingView: View {
    @Binding var hasCompletedOnboarding: Bool
    @State private var currentPage = 0
    @State private var showModeSelection = false

    private let pages: [OnboardingPage] = [
        OnboardingPage(
            icon: "shield.checkered",
            title: "Welcome to\nAutoSec Learn",
            subtitle: "10 modules, 33 lessons, and 92 quiz questions covering switches, routers, VPNs, DNS security, Zero Trust, and more.",
            gradient: [Color(hex: "667eea"), Color(hex: "764ba2")]
        ),
        OnboardingPage(
            icon: "book.pages",
            title: "Interactive\nLearning",
            subtitle: "Hands-on lessons with inline questions, flashcards for review, and bookmarks to save your favorites.",
            gradient: [Color(hex: "11998e"), Color(hex: "38ef7d")]
        ),
        OnboardingPage(
            icon: "trophy.fill",
            title: "Earn XP\n& Badges",
            subtitle: "Level up with XP for every lesson and quiz. Unlock achievement badges and track your study streak.",
            gradient: [Color(hex: "fc5c7d"), Color(hex: "6a82fb")]
        ),
        OnboardingPage(
            icon: "chevron.left.forwardslash.chevron.right",
            title: "Automate\nWith Python",
            subtitle: "Learn to automate router and switch configuration using Python and Netmiko scripts.",
            gradient: [Color(hex: "f7971e"), Color(hex: "ffd200")]
        )
    ]

    var body: some View {
        if showModeSelection {
            ModeSelectionView(hasCompletedOnboarding: $hasCompletedOnboarding)
        } else {
            ZStack {
                // Background
                pages[currentPage].gradient[0]
                    .ignoresSafeArea()
                    .animation(.easeInOut(duration: 0.5), value: currentPage)

                VStack(spacing: 0) {
                    Spacer()

                    pageContent

                    Spacer()

                    // Page Indicators
                    HStack(spacing: 8) {
                        ForEach(0..<pages.count, id: \.self) { index in
                            Capsule()
                                .fill(index == currentPage ? Color.white : Color.white.opacity(0.3))
                                .frame(width: index == currentPage ? 24 : 8, height: 8)
                                .animation(.spring(response: 0.3), value: currentPage)
                        }
                    }
                    .padding(.bottom, 40)

                    // Buttons
                    HStack(spacing: 14) {
                        if currentPage > 0 {
                            Button {
                                let generator = UIImpactFeedbackGenerator(style: .light)
                                generator.impactOccurred()
                                withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                                    currentPage -= 1
                                }
                            } label: {
                                Image(systemName: "chevron.left")
                                    .font(.headline)
                                    .foregroundStyle(.white)
                                    .frame(width: 56, height: 56)
                                    .background(.white.opacity(0.2))
                                    .clipShape(Circle())
                            }
                        }

                        bottomButton
                    }
                    .padding(.horizontal, 30)
                    .padding(.bottom, 50)
                }
            }
        }
    }

    // MARK: - Page Content

    private var pageContent: some View {
        let page = pages[currentPage]
        return VStack(spacing: 24) {
            Image(systemName: page.icon)
                .font(.system(size: 70, weight: .semibold))
                .foregroundStyle(.white)
                .frame(width: 130, height: 130)
                .background(.white.opacity(0.15))
                .clipShape(RoundedRectangle(cornerRadius: 32))
                .shadow(color: .black.opacity(0.2), radius: 20, y: 10)

            VStack(spacing: 12) {
                Text(page.title)
                    .font(.system(size: 32, weight: .bold))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)

                Text(page.subtitle)
                    .font(.body)
                    .foregroundStyle(.white.opacity(0.85))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
            }
        }
        .transition(.asymmetric(
            insertion: .move(edge: .trailing).combined(with: .opacity),
            removal: .move(edge: .leading).combined(with: .opacity)
        ))
        .id(currentPage)
    }

    // MARK: - Bottom Button

    private var bottomButton: some View {
        Button {
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()

            if currentPage < pages.count - 1 {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                    currentPage += 1
                }
            } else {
                withAnimation(.easeInOut(duration: 0.3)) {
                    showModeSelection = true
                }
            }
        } label: {
            HStack(spacing: 8) {
                Text(currentPage < pages.count - 1 ? "Next" : "Get Started")
                    .font(.headline)
                Image(systemName: currentPage < pages.count - 1 ? "arrow.right" : "checkmark")
                    .font(.subheadline)
                    .fontWeight(.bold)
            }
            .foregroundStyle(pages[currentPage].gradient[0])
            .frame(maxWidth: .infinity)
            .padding(.vertical, 18)
            .background(.white)
            .clipShape(Capsule())
            .shadow(color: .black.opacity(0.15), radius: 10, y: 5)
        }
    }
}

// MARK: - Model

struct OnboardingPage {
    let icon: String
    let title: String
    let subtitle: String
    let gradient: [Color]
}

#Preview {
    OnboardingView(hasCompletedOnboarding: .constant(false))
}
