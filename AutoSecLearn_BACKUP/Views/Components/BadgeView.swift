import SwiftUI

// MARK: - Badge Grid

struct BadgeGridView: View {
    let unlockedBadges: [Badge]

    private let columns = [
        GridItem(.adaptive(minimum: 90, maximum: 120), spacing: 12)
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 8) {
                Image(systemName: "medal.fill")
                    .foregroundStyle(Color(hex: "f7971e"))
                Text("Achievements")
                    .font(.title3)
                    .fontWeight(.bold)
                Spacer()
                Text("\(unlockedBadges.count)/\(BadgeDefinitions.all.count)")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundStyle(.secondary)
            }

            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(BadgeDefinitions.all) { badge in
                    BadgeCardView(
                        badge: badge,
                        isUnlocked: unlockedBadges.contains { $0.id == badge.id },
                        unlockedDate: unlockedBadges.first { $0.id == badge.id }?.unlockedDate
                    )
                }
            }
        }
    }
}

// MARK: - Badge Card

struct BadgeCardView: View {
    let badge: Badge
    let isUnlocked: Bool
    let unlockedDate: Date?

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: badge.icon)
                .font(.title2)
                .foregroundStyle(isUnlocked ? Color(hex: "f7971e") : .gray.opacity(0.4))
                .frame(width: 50, height: 50)
                .background(
                    (isUnlocked ? Color(hex: "f7971e") : Color.gray).opacity(0.12)
                )
                .clipShape(Circle())

            Text(badge.name)
                .font(.caption2)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .foregroundStyle(isUnlocked ? .primary : .secondary)

            if isUnlocked {
                Text(badge.description)
                    .font(.system(size: 9))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            } else {
                Image(systemName: "lock.fill")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .padding(.horizontal, 4)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .opacity(isUnlocked ? 1.0 : 0.6)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(badge.name)
        .accessibilityValue(isUnlocked ? "Unlocked: \(badge.description)" : "Locked: \(badge.description)")
    }
}
