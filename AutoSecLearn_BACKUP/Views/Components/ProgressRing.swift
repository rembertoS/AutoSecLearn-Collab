import SwiftUI

struct ProgressRing: View {
    let progress: Double
    let lineWidth: CGFloat
    let size: CGFloat
    let gradientColors: [Color]

    @State private var animatedProgress: Double = 0

    init(
        progress: Double,
        lineWidth: CGFloat = 10,
        size: CGFloat = 120,
        gradientColors: [Color] = [Color(hex: "667eea"), Color(hex: "764ba2")]
    ) {
        self.progress = progress
        self.lineWidth = lineWidth
        self.size = size
        self.gradientColors = gradientColors
    }

    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.gray.opacity(0.15), lineWidth: lineWidth)

            Circle()
                .trim(from: 0, to: animatedProgress)
                .stroke(
                    AngularGradient(
                        colors: gradientColors + [gradientColors[0]],
                        center: .center,
                        startAngle: .degrees(0),
                        endAngle: .degrees(360)
                    ),
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))

            VStack(spacing: 2) {
                Text("\(Int(animatedProgress * 100))%")
                    .font(.system(size: size * 0.22, weight: .bold, design: .rounded))
                    .contentTransition(.numericText())

                Text("Complete")
                    .font(.system(size: size * 0.1, weight: .medium))
                    .foregroundStyle(.secondary)
            }
        }
        .frame(width: size, height: size)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Overall progress")
        .accessibilityValue("\(Int(progress * 100)) percent complete")
        .onAppear {
            withAnimation(.spring(response: 1.2, dampingFraction: 0.8).delay(0.3)) {
                animatedProgress = progress
            }
        }
        .onChange(of: progress) { _, newValue in
            withAnimation(.spring(response: 0.8, dampingFraction: 0.8)) {
                animatedProgress = newValue
            }
        }
    }
}

#Preview {
    ProgressRing(progress: 0.65)
}
