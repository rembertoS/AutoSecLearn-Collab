import SwiftUI

/// Programmatic app icon design for AutoSec Learn.
/// This view renders the icon and can export it as a 1024x1024 PNG.
struct AppIconView: View {
    let size: CGFloat

    init(size: CGFloat = 1024) {
        self.size = size
    }

    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [
                    Color(hex: "0f0c29"),
                    Color(hex: "302b63"),
                    Color(hex: "24243e")
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            // Subtle grid pattern (network topology feel)
            GridPatternView(size: size)
                .opacity(0.08)

            // Glow behind shield
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color(hex: "667eea").opacity(0.5),
                            Color.clear
                        ],
                        center: .center,
                        startRadius: size * 0.05,
                        endRadius: size * 0.4
                    )
                )
                .frame(width: size * 0.7, height: size * 0.7)

            // Shield shape
            ShieldShape()
                .fill(
                    LinearGradient(
                        colors: [
                            Color(hex: "667eea"),
                            Color(hex: "764ba2")
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: size * 0.52, height: size * 0.6)
                .shadow(color: Color(hex: "667eea").opacity(0.6), radius: size * 0.04, y: size * 0.02)

            // Shield inner border
            ShieldShape()
                .stroke(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.4),
                            Color.white.opacity(0.1)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    ),
                    lineWidth: size * 0.005
                )
                .frame(width: size * 0.48, height: size * 0.56)

            // Network node icon inside shield
            VStack(spacing: size * 0.02) {
                // Router/network symbol
                NetworkSymbolView(size: size)

                // "A" letter for AutoSec
                Text("A")
                    .font(.system(size: size * 0.12, weight: .heavy, design: .rounded))
                    .foregroundStyle(.white)
            }
            .offset(y: -size * 0.01)

            // Small accent dots (network nodes)
            ForEach(0..<6, id: \.self) { i in
                Circle()
                    .fill(Color(hex: "38ef7d").opacity(0.7))
                    .frame(width: size * 0.018, height: size * 0.018)
                    .shadow(color: Color(hex: "38ef7d").opacity(0.8), radius: size * 0.008)
                    .offset(nodeOffset(for: i))
            }
        }
        .frame(width: size, height: size)
        .clipShape(RoundedRectangle(cornerRadius: size * 0.2237)) // iOS icon corner radius
    }

    private func nodeOffset(for index: Int) -> CGSize {
        let offsets: [CGSize] = [
            CGSize(width: -size * 0.32, height: -size * 0.15),
            CGSize(width: size * 0.32, height: -size * 0.15),
            CGSize(width: -size * 0.28, height: size * 0.2),
            CGSize(width: size * 0.28, height: size * 0.2),
            CGSize(width: -size * 0.35, height: size * 0.02),
            CGSize(width: size * 0.35, height: size * 0.02)
        ]
        return offsets[index]
    }
}

// MARK: - Shield Shape

struct ShieldShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height

        path.move(to: CGPoint(x: w * 0.5, y: 0))
        path.addQuadCurve(
            to: CGPoint(x: w, y: h * 0.15),
            control: CGPoint(x: w * 0.85, y: 0)
        )
        path.addLine(to: CGPoint(x: w, y: h * 0.45))
        path.addQuadCurve(
            to: CGPoint(x: w * 0.5, y: h),
            control: CGPoint(x: w, y: h * 0.8)
        )
        path.addQuadCurve(
            to: CGPoint(x: 0, y: h * 0.45),
            control: CGPoint(x: 0, y: h * 0.8)
        )
        path.addLine(to: CGPoint(x: 0, y: h * 0.15))
        path.addQuadCurve(
            to: CGPoint(x: w * 0.5, y: 0),
            control: CGPoint(x: w * 0.15, y: 0)
        )

        return path
    }
}

// MARK: - Network Symbol (Router with connections)

struct NetworkSymbolView: View {
    let size: CGFloat

    private var routerIcon: some View {
        Image(systemName: "wifi.router.fill")
            .font(.system(size: size * 0.13, weight: .semibold))
            .foregroundStyle(.white)
            .shadow(color: Color(hex: "38ef7d").opacity(0.5), radius: size * 0.01)
    }

    private func orbitNode(index: Int) -> some View {
        let angle = Double(index) * 120 - 90
        let radians = angle * .pi / 180
        let radius = size * 0.09
        return Circle()
            .fill(Color(hex: "38ef7d"))
            .frame(width: size * 0.022, height: size * 0.022)
            .shadow(color: Color(hex: "38ef7d").opacity(0.8), radius: size * 0.006)
            .offset(x: cos(radians) * radius, y: sin(radians) * radius)
    }

    var body: some View {
        ZStack {
            routerIcon
            orbitNode(index: 0)
            orbitNode(index: 1)
            orbitNode(index: 2)
        }
        .frame(width: size * 0.25, height: size * 0.25)
    }
}

// MARK: - Grid Pattern

struct GridPatternView: View {
    let size: CGFloat

    var body: some View {
        Canvas { context, canvasSize in
            let spacing = size * 0.06

            // Horizontal lines
            var y: CGFloat = 0
            while y < canvasSize.height {
                let path = Path { p in
                    p.move(to: CGPoint(x: 0, y: y))
                    p.addLine(to: CGPoint(x: canvasSize.width, y: y))
                }
                context.stroke(path, with: .color(.white), lineWidth: 0.5)
                y += spacing
            }

            // Vertical lines
            var x: CGFloat = 0
            while x < canvasSize.width {
                let path = Path { p in
                    p.move(to: CGPoint(x: x, y: 0))
                    p.addLine(to: CGPoint(x: x, y: canvasSize.height))
                }
                context.stroke(path, with: .color(.white), lineWidth: 0.5)
                x += spacing
            }
        }
    }
}

// MARK: - Icon Export Helper

struct AppIconExportView: View {
    @State private var exportMessage = ""

    var body: some View {
        VStack(spacing: 30) {
            Text("App Icon Preview")
                .font(.title2)
                .fontWeight(.bold)

            AppIconView(size: 300)

            Text("To export the icon:")
                .font(.headline)

            VStack(alignment: .leading, spacing: 8) {
                Text("1. Run this view in an Xcode preview or simulator")
                Text("2. Use the export button below to save as PNG")
                Text("3. Place AppIcon.png in Assets.xcassets/AppIcon.appiconset/")
            }
            .font(.subheadline)
            .foregroundStyle(.secondary)

            Button("Export 1024x1024 PNG") {
                exportIcon()
            }
            .buttonStyle(.borderedProminent)

            if !exportMessage.isEmpty {
                Text(exportMessage)
                    .font(.caption)
                    .foregroundStyle(.green)
            }
        }
        .padding(30)
    }

    @MainActor
    private func exportIcon() {
        let renderer = ImageRenderer(content: AppIconView(size: 1024))
        renderer.scale = 1.0

        if let uiImage = renderer.uiImage,
           let data = uiImage.pngData() {
            let filename = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                .appendingPathComponent("AppIcon.png")
            do {
                try data.write(to: filename)
                exportMessage = "Saved to: \(filename.path)"
            } catch {
                exportMessage = "Error: \(error.localizedDescription)"
            }
        }
    }
}

#Preview("App Icon") {
    AppIconView(size: 300)
        .padding()
        .background(Color(.systemGroupedBackground))
}

#Preview("Export View") {
    AppIconExportView()
}
