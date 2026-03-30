//
//  ModuleListView.swift
//  AutoSecLearn
//
//  Created by Remberto Silva on 3/30/26.
//
import SwiftUI

struct ModuleListView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // MARK: - Header
                    headerSection

                    // MARK: - Module Cards
                    ForEach(ModuleContent.modules) { module in
                        NavigationLink {
                            ModuleDetail(module: module)
                        } label: {
                            ModuleCard(module: module)
                        }
                        .buttonStyle(.plain)
                    }

                    Spacer(minLength: 20)
                }
                .padding()
            }
            .navigationTitle("Rembert's Modules")
            .background(Color(.systemGroupedBackground))
        }
    }

    private var headerSection: some View {
        VStack(spacing: 10) {
            Image(systemName: "chevron.left.forwardslash.chevron.right")
                .font(.system(size: 44))
                .foregroundStyle(
                    LinearGradient(
                        colors: [Color(hex: "f7971e"), Color(hex: "ffd200")],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            Text("Python Network Automation")
                .font(AppTheme.title)
                .multilineTextAlignment(.center)

            Text("5 modules covering scripting, authentication, multi-host management, consistent configs, and rapid deployment.")
                .font(AppTheme.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 28)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.cornerRadius)
                .fill(.ultraThinMaterial)
        )
    }
}

// MARK: - Module Card

struct ModuleCard: View {
    let module: LearningModule
    @State private var isAppearing = false

    private var gradientColors: [Color] {
        switch module.id {
        case "r_python_scripting":
            return [Color(hex: "f7971e"), Color(hex: "ffd200")]
        case "r_multi_auth":
            return [Color(hex: "667eea"), Color(hex: "764ba2")]
        case "r_multi_host":
            return [Color(hex: "11998e"), Color(hex: "38ef7d")]
        case "r_consistent_config":
            return [Color(hex: "fc5c7d"), Color(hex: "6a82fb")]
        case "r_rapid_deploy":
            return [Color(hex: "e53935"), Color(hex: "d32f2f")]
        default:
            return [Color(hex: "f7971e"), Color(hex: "ffd200")]
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

                Image(systemName: "chevron.right")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white.opacity(0.7))
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

#Preview {
    ModuleListView()
}
