import SwiftUI

struct FlashcardView: View {
    @Environment(UserProgressManager.self) var progressManager
    let questions: [QuizQuestion]
    let gradientColors: [Color]

    @State private var currentIndex = 0
    @State private var isFlipped = false
    @State private var dragOffset: CGSize = .zero

    private var currentQuestion: QuizQuestion {
        questions[currentIndex]
    }

    private var reviewedCount: Int {
        progressManager.reviewedFlashcards.filter { id in
            questions.contains { $0.id == id }
        }.count
    }

    var body: some View {
        VStack(spacing: 20) {
            // Progress
            HStack {
                Text("Card \(currentIndex + 1) of \(questions.count)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Spacer()
                Text("\(reviewedCount) reviewed")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundStyle(gradientColors[0])
            }
            .padding(.horizontal)

            Spacer()

            // Card
            ZStack {
                // Back (answer)
                cardBack
                    .rotation3DEffect(.degrees(isFlipped ? 0 : -180), axis: (x: 0, y: 1, z: 0))
                    .opacity(isFlipped ? 1 : 0)

                // Front (question)
                cardFront
                    .rotation3DEffect(.degrees(isFlipped ? 180 : 0), axis: (x: 0, y: 1, z: 0))
                    .opacity(isFlipped ? 0 : 1)
            }
            .offset(dragOffset)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        dragOffset = value.translation
                    }
                    .onEnded { value in
                        if abs(value.translation.width) > 100 {
                            let goNext = value.translation.width < 0
                            withAnimation(.spring(response: 0.3)) {
                                dragOffset = CGSize(width: goNext ? -500 : 500, height: 0)
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                progressManager.markFlashcardReviewed(currentQuestion.id)
                                if goNext {
                                    currentIndex = min(currentIndex + 1, questions.count - 1)
                                } else {
                                    currentIndex = max(currentIndex - 1, 0)
                                }
                                dragOffset = .zero
                                isFlipped = false
                            }
                        } else {
                            withAnimation(.spring(response: 0.3)) {
                                dragOffset = .zero
                            }
                        }
                    }
            )
            .onTapGesture {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                    isFlipped.toggle()
                }
            }

            Spacer()

            // Hint
            Text("Tap to flip  \u{00B7}  Swipe to navigate")
                .font(.caption)
                .foregroundStyle(.secondary)

            // Navigation buttons
            HStack(spacing: 30) {
                Button {
                    withAnimation(.spring(response: 0.4)) {
                        isFlipped = false
                        currentIndex = max(0, currentIndex - 1)
                    }
                } label: {
                    Image(systemName: "chevron.left.circle.fill")
                        .font(.system(size: 44))
                        .foregroundStyle(gradientColors[0])
                }
                .disabled(currentIndex == 0)
                .opacity(currentIndex == 0 ? 0.3 : 1)

                Spacer()

                Button {
                    withAnimation(.spring(response: 0.4)) {
                        progressManager.markFlashcardReviewed(currentQuestion.id)
                        isFlipped = false
                        currentIndex = min(questions.count - 1, currentIndex + 1)
                    }
                } label: {
                    Image(systemName: "chevron.right.circle.fill")
                        .font(.system(size: 44))
                        .foregroundStyle(gradientColors[0])
                }
                .disabled(currentIndex == questions.count - 1)
                .opacity(currentIndex == questions.count - 1 ? 0.3 : 1)
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 20)
        }
        .navigationTitle("Flashcards")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Card Front

    private var cardFront: some View {
        VStack(spacing: 16) {
            Image(systemName: "questionmark.circle")
                .font(.largeTitle)
                .foregroundStyle(gradientColors[0])

            Text(currentQuestion.question)
                .font(.title3)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
                .lineSpacing(4)

            HStack(spacing: 4) {
                Circle()
                    .fill(difficultyColor)
                    .frame(width: 8, height: 8)
                Text(currentQuestion.difficulty.rawValue.capitalized)
                    .font(.caption2)
                    .fontWeight(.medium)
                    .foregroundStyle(.secondary)
            }
            .padding(.top, 8)
        }
        .padding(30)
        .frame(maxWidth: .infinity, minHeight: 300)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: gradientColors[0].opacity(0.2), radius: 15, y: 8)
        .padding(.horizontal, 20)
    }

    // MARK: - Card Back

    private var cardBack: some View {
        VStack(spacing: 16) {
            Image(systemName: "lightbulb.fill")
                .font(.largeTitle)
                .foregroundStyle(.yellow)

            Text(currentQuestion.options[currentQuestion.correctAnswerIndex])
                .font(.title3)
                .fontWeight(.bold)
                .foregroundStyle(.green)
                .multilineTextAlignment(.center)

            Divider()

            Text(currentQuestion.explanation)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .lineSpacing(3)
        }
        .padding(30)
        .frame(maxWidth: .infinity, minHeight: 300)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .strokeBorder(Color.green.opacity(0.3), lineWidth: 1.5)
                )
        )
        .shadow(color: Color.green.opacity(0.15), radius: 15, y: 8)
        .padding(.horizontal, 20)
    }

    private var difficultyColor: Color {
        switch currentQuestion.difficulty {
        case .beginner: return .green
        case .intermediate: return .orange
        case .advanced: return .red
        }
    }
}
