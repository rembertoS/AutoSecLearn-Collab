import SwiftUI

// MARK: - App Theme
// Shared colors, fonts, and styles for the entire app.
// Team members: feel free to use these in your own sections!

struct AppTheme {

    // MARK: - Colors

    /// Primary brand color — a cyber-teal
    static let primary = Color("accentTeal")

    /// Dark background for cards and sections
    static let cardBackground = Color(.systemGray6)

    /// Subtle border/divider color
    static let border = Color(.systemGray4)

    /// Gradient used for headers and accents
    static let primaryGradient = LinearGradient(
        colors: [Color("accentTeal"), Color("accentBlue")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    /// Secondary gradient for variety
    static let secondaryGradient = LinearGradient(
        colors: [Color("accentIndigo"), Color("accentPurple")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    // MARK: - Fonts

    static let largeTitle = Font.system(size: 28, weight: .bold, design: .rounded)
    static let title = Font.system(size: 22, weight: .bold, design: .rounded)
    static let headline = Font.system(size: 17, weight: .semibold, design: .rounded)
    static let body = Font.system(size: 15, weight: .regular, design: .default)
    static let caption = Font.system(size: 13, weight: .medium, design: .default)

    // MARK: - Spacing

    static let paddingSmall: CGFloat = 8
    static let paddingMedium: CGFloat = 16
    static let paddingLarge: CGFloat = 24
    static let cornerRadius: CGFloat = 14
}

// MARK: - Reusable Card Modifier

struct CardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(AppTheme.paddingMedium)
            .background(AppTheme.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: AppTheme.cornerRadius))
    }
}

extension View {
    /// Apply a card-style background to any view
    func cardStyle() -> some View {
        modifier(CardStyle())
    }
}
