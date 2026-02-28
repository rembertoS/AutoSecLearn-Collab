import SwiftUI

struct ModuleCard: View {
    @Environment(UserProgressManager.self) var progressManager
    let module: LearningModule
    let progress: Double
    @State private var isAppearing = false

    private var gradientColors: [Color] {
        switch module.id {
        case "switch_1":
            return [Color(hex: "667eea"), Color(hex: "764ba2")]
        case "router":
            return [Color(hex: "11998e"), Color(hex: "38ef7d")]
        case "failover_switch":
            return [Color(hex: "fc5c7d"), Color(hex: "6a82fb")]
        case "python_automation":
            return [Color(hex: "f7971e"), Color(hex: "ffd200")]
        case "firewall_acl":
            return [Color(hex: "e53935"), Color(hex: "d32f2f")]
        case "wireless_security":
            return [Color(hex: "00bcd4"), Color(hex: "0097a7")]
        case "network_monitoring":
            return [Color(hex: "26a69a"), Color(hex: "00796b")]
        case "vpn_remote":
            return [Color(hex: "5c6bc0"), Color(hex: "3949ab")]
        case "dns_services":
            return [Color(hex: "ff8f00"), Color(hex: "e65100")]
        case "zero_trust":
            return [Color(hex: "7b1fa2"), Color(hex: "4a148c")]
        default:
            return [Color(hex: "667eea"), Color(hex: "764ba2")]
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: module.icon)
                    .font(.system(size: 28, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(width: 50, height: 50)
                    .background(.white.opacity(0.2))
                    .clipShape(RoundedRectangle(cornerRadius: 12))

                Spacer()

                if progressManager.isModuleComplete(for: module) {
                    Image(systemName: "checkmark.seal.fill")
                        .font(.title2)
                        .foregroundStyle(.white)
                        .transition(.scale.combined(with: .opacity))
                }
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(module.title)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)

                Text(module.description)
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.85))
                    .lineLimit(2)
            }

            HStack(spacing: 16) {
                Label("\(module.totalLessons) Lessons", systemImage: "doc.text")
                Label("\(module.totalQuestions) Questions", systemImage: "questionmark.circle")
            }
            .font(.caption2)
            .foregroundStyle(.white.opacity(0.75))

            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text("Progress")
                        .font(.caption2)
                        .foregroundStyle(.white.opacity(0.75))
                    Spacer()
                    Text("\(Int(progress * 100))%")
                        .font(.caption2)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                }

                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(.white.opacity(0.2))
                            .frame(height: 6)

                        Capsule()
                            .fill(.white)
                            .frame(width: geometry.size.width * progress, height: 6)
                            .animation(.spring(response: 0.8, dampingFraction: 0.7), value: progress)
                    }
                }
                .frame(height: 6)
            }
        }
        .padding(20)
        .background(
            LinearGradient(
                colors: gradientColors,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: gradientColors[0].opacity(0.4), radius: 10, x: 0, y: 5)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(module.title)
        .accessibilityValue("\(Int(progress * 100)) percent complete, \(module.totalLessons) lessons")
        .accessibilityHint("Double tap to open")
        .scaleEffect(isAppearing ? 1 : 0.9)
        .opacity(isAppearing ? 1 : 0)
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                isAppearing = true
            }
        }
    }
}

// MARK: - Hex Color Extension

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
