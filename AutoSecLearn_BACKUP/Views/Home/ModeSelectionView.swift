import SwiftUI

struct ModeSelectionView: View {
    @Environment(UserProgressManager.self) var progressManager
    @Binding var hasCompletedOnboarding: Bool
    @State private var selectedMode: AppMode? = nil
    @State private var animateIn = false

    var body: some View {
        ZStack {
            // Background gradient (matching onboarding style)
            LinearGradient(
                colors: [Color(hex: "667eea"), Color(hex: "764ba2")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()

                // Header
                VStack(spacing: 14) {
                    Image(systemName: "rectangle.split.2x1.fill")
                        .font(.system(size: 50, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(width: 100, height: 100)
                        .background(.white.opacity(0.15))
                        .clipShape(RoundedRectangle(cornerRadius: 28))
                        .shadow(color: .black.opacity(0.2), radius: 20, y: 10)
                        .scaleEffect(animateIn ? 1 : 0.5)
                        .opacity(animateIn ? 1 : 0)

                    Text("Choose Your Mode")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundStyle(.white)
                        .opacity(animateIn ? 1 : 0)
                        .offset(y: animateIn ? 0 : 15)

                    Text("You can change this anytime in Settings.")
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.8))
                        .opacity(animateIn ? 1 : 0)
                        .offset(y: animateIn ? 0 : 15)
                }
                .padding(.bottom, 36)

                // Mode cards
                VStack(spacing: 14) {
                    ForEach(AppMode.allCases, id: \.self) { mode in
                        ModeOptionCard(
                            mode: mode,
                            isSelected: selectedMode == mode
                        ) {
                            withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                                selectedMode = mode
                            }
                            let generator = UIImpactFeedbackGenerator(style: .light)
                            generator.impactOccurred()
                        }
                        .opacity(animateIn ? 1 : 0)
                        .offset(y: animateIn ? 0 : 30)
                    }
                }
                .padding(.horizontal, 24)

                Spacer()

                // Continue button
                Button {
                    let generator = UIImpactFeedbackGenerator(style: .medium)
                    generator.impactOccurred()

                    if let mode = selectedMode {
                        progressManager.setMode(mode)
                        withAnimation(.easeInOut(duration: 0.3)) {
                            hasCompletedOnboarding = true
                        }
                    }
                } label: {
                    HStack(spacing: 8) {
                        Text("Continue")
                            .font(.headline)
                        Image(systemName: "checkmark")
                            .font(.subheadline)
                            .fontWeight(.bold)
                    }
                    .foregroundStyle(Color(hex: "667eea"))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(selectedMode != nil ? .white : .white.opacity(0.4))
                    .clipShape(Capsule())
                    .shadow(color: .black.opacity(0.15), radius: 10, y: 5)
                }
                .disabled(selectedMode == nil)
                .padding(.horizontal, 30)
                .padding(.bottom, 50)
                .opacity(animateIn ? 1 : 0)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.7, dampingFraction: 0.8).delay(0.15)) {
                animateIn = true
            }
        }
    }
}

// MARK: - Mode Option Card

struct ModeOptionCard: View {
    let mode: AppMode
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: mode.icon)
                    .font(.system(size: 26, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(width: 52, height: 52)
                    .background(.white.opacity(isSelected ? 0.3 : 0.15))
                    .clipShape(RoundedRectangle(cornerRadius: 14))

                VStack(alignment: .leading, spacing: 4) {
                    Text(mode.displayName)
                        .font(.headline)
                        .foregroundStyle(.white)

                    Text(mode.description)
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.8))
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                }

                Spacer()

                ZStack {
                    Circle()
                        .strokeBorder(.white.opacity(0.4), lineWidth: 2)
                        .frame(width: 26, height: 26)

                    if isSelected {
                        Circle()
                            .fill(.white)
                            .frame(width: 26, height: 26)
                            .overlay(
                                Image(systemName: "checkmark")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundStyle(Color(hex: "667eea"))
                            )
                            .transition(.scale.combined(with: .opacity))
                    }
                }
            }
            .padding(18)
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .fill(.white.opacity(isSelected ? 0.2 : 0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 18)
                            .strokeBorder(.white.opacity(isSelected ? 0.6 : 0.15), lineWidth: isSelected ? 2 : 1)
                    )
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    ModeSelectionView(hasCompletedOnboarding: .constant(false))
        .environment(UserProgressManager())
}
