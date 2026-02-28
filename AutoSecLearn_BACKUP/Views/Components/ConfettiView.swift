import SwiftUI

struct ConfettiView: View {
    @Binding var isActive: Bool
    @State private var particles: [ConfettiParticle] = []
    @State private var timer: Timer?

    private let colors: [Color] = [
        .red, .blue, .green, .yellow, .orange, .purple, .pink, .mint
    ]

    var body: some View {
        Canvas { context, size in
            for particle in particles {
                let rect = CGRect(
                    x: particle.x - particle.size / 2,
                    y: particle.y - particle.size / 2,
                    width: particle.size,
                    height: particle.size * 0.6
                )
                context.opacity = particle.opacity
                context.fill(
                    Path(roundedRect: rect, cornerRadius: 2),
                    with: .color(particle.color)
                )
            }
        }
        .onChange(of: isActive) { _, newValue in
            if newValue { spawnParticles() }
        }
        .allowsHitTesting(false)
        .ignoresSafeArea()
    }

    private func spawnParticles() {
        let screenWidth = UIScreen.main.bounds.width
        particles = (0..<80).map { _ in
            ConfettiParticle(
                x: CGFloat.random(in: 0...screenWidth),
                y: CGFloat.random(in: -60...(-10)),
                size: CGFloat.random(in: 6...12),
                color: colors.randomElement() ?? .blue,
                velocity: CGFloat.random(in: 200...500),
                horizontalDrift: CGFloat.random(in: -80...80),
                opacity: 1.0
            )
        }

        var elapsed: Double = 0
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0 / 60.0, repeats: true) { t in
            let dt = 1.0 / 60.0
            elapsed += dt

            for i in particles.indices {
                particles[i].y += particles[i].velocity * dt
                particles[i].x += particles[i].horizontalDrift * dt
                particles[i].velocity += 150 * dt
                if elapsed > 2.0 {
                    particles[i].opacity -= dt * 2
                }
            }

            if elapsed > 3.0 {
                t.invalidate()
                particles.removeAll()
                isActive = false
            }
        }
    }
}

struct ConfettiParticle {
    var x: CGFloat
    var y: CGFloat
    var size: CGFloat
    var color: Color
    var velocity: CGFloat
    var horizontalDrift: CGFloat
    var opacity: Double
}
