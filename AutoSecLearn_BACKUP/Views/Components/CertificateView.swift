import SwiftUI

struct CertificateView: View {
    @Environment(UserProgressManager.self) var progressManager
    let modules = CourseContent.modules

    @State private var renderedImage: UIImage?

    private var completionDateString: String {
        guard let date = progressManager.completionDate else { return "" }
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: date)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                certificateContent
                    .padding(20)

                if renderedImage != nil {
                    Button {
                        shareCertificate()
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "square.and.arrow.up")
                            Text("Share Certificate")
                        }
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(
                            LinearGradient(
                                colors: [Color(hex: "667eea"), Color(hex: "764ba2")],
                                startPoint: .leading, endPoint: .trailing
                            )
                        )
                        .clipShape(Capsule())
                    }
                    .padding(.horizontal, 30)
                }
            }
            .padding(.bottom, 30)
        }
        .navigationTitle("Certificate")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { renderCertificate() }
    }

    private var certificateContent: some View {
        VStack(spacing: 20) {
            Image(systemName: "seal.fill")
                .font(.system(size: 50))
                .foregroundStyle(
                    LinearGradient(
                        colors: [Color(hex: "f7971e"), Color(hex: "ffd200")],
                        startPoint: .topLeading, endPoint: .bottomTrailing
                    )
                )

            Text("Certificate of Completion")
                .font(.title2)
                .fontWeight(.bold)

            Text("This certifies that")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Text("AutoSec Learner")
                .font(.title)
                .fontWeight(.heavy)
                .foregroundStyle(Color(hex: "667eea"))

            Text("has successfully completed all")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            VStack(spacing: 6) {
                Text("\(modules.count) Modules")
                    .font(.headline)
                Text("\(modules.reduce(0) { $0 + $1.lessons.count }) Lessons")
                    .font(.subheadline)
                Text("\(modules.reduce(0) { $0 + $1.quiz.questions.count }) Quiz Questions")
                    .font(.subheadline)
            }

            Text("in the AutoSec Learn curriculum")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Divider()

            if !completionDateString.isEmpty {
                Text(completionDateString)
                    .font(.subheadline)
                    .fontWeight(.medium)
            }

            HStack(spacing: 4) {
                Image(systemName: "shield.checkered")
                Text("AutoSec Learn")
            }
            .font(.caption)
            .foregroundStyle(.secondary)

            Text("FIU - COP4655 - Spring 2026")
                .font(.caption2)
                .foregroundStyle(.tertiary)
        }
        .padding(30)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .strokeBorder(
                            LinearGradient(
                                colors: [Color(hex: "f7971e"), Color(hex: "667eea")],
                                startPoint: .topLeading, endPoint: .bottomTrailing
                            ),
                            lineWidth: 2
                        )
                )
        )
    }

    @MainActor
    private func renderCertificate() {
        let renderer = ImageRenderer(content: certificateContent.frame(width: 400))
        renderer.scale = 3.0
        renderedImage = renderer.uiImage
    }

    private func shareCertificate() {
        guard let image = renderedImage else { return }
        let activityVC = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = windowScene.windows.first?.rootViewController {
            rootVC.present(activityVC, animated: true)
        }
    }
}
