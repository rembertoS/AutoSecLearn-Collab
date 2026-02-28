import SwiftUI

struct QuizResultView: View {
    @Environment(\.dismiss) private var dismiss
    let quiz: Quiz
    let score: Int
    let userAnswers: [UserAnswer]
    let gradientColors: [Color]

    @State private var animateScore = false
    @State private var showDetails = false
    @State private var showConfetti = false

    private var percentage: Double {
        Double(score) / Double(quiz.questions.count) * 100
    }

    private var passed: Bool { percentage >= 70 }

    private var gradeMessage: String {
        switch percentage {
        case 90...100: return "Outstanding!"
        case 80..<90: return "Great Job!"
        case 70..<80: return "Well Done!"
        case 60..<70: return "Almost There!"
        default: return "Keep Practicing!"
        }
    }

    private var gradeIcon: String {
        switch percentage {
        case 90...100: return "star.circle.fill"
        case 70..<90: return "hand.thumbsup.circle.fill"
        case 50..<70: return "arrow.up.circle.fill"
        default: return "book.circle.fill"
        }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                // Result Header
                VStack(spacing: 16) {
                    Image(systemName: gradeIcon)
                        .font(.system(size: 60))
                        .foregroundStyle(
                            passed
                            ? LinearGradient(colors: [.green, .mint], startPoint: .top, endPoint: .bottom)
                            : LinearGradient(colors: [.orange, .red], startPoint: .top, endPoint: .bottom)
                        )
                        .scaleEffect(animateScore ? 1 : 0.3)
                        .opacity(animateScore ? 1 : 0)

                    Text(gradeMessage)
                        .font(.title)
                        .fontWeight(.bold)
                        .opacity(animateScore ? 1 : 0)

                    ProgressRing(
                        progress: percentage / 100,
                        lineWidth: 10,
                        size: 130,
                        gradientColors: passed ? [.green, .mint] : [.orange, .red]
                    )
                    .padding(.vertical, 10)

                    HStack(spacing: 30) {
                        VStack(spacing: 4) {
                            Text("\(score)")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundStyle(.green)
                            Text("Correct")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }

                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(width: 1, height: 30)

                        VStack(spacing: 4) {
                            Text("\(quiz.questions.count - score)")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundStyle(.red)
                            Text("Incorrect")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }

                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(width: 1, height: 30)

                        VStack(spacing: 4) {
                            Text(passed ? "PASS" : "FAIL")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundStyle(passed ? .green : .red)
                            Text("70% needed")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }

                    if passed {
                        HStack(spacing: 6) {
                            Image(systemName: "star.fill")
                                .foregroundStyle(.yellow)
                            Text(percentage >= 100 ? "+150 XP earned!" : "+50 XP earned!")
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .foregroundStyle(Color(hex: "f7971e"))
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color(hex: "f7971e").opacity(0.1))
                        .clipShape(Capsule())
                    }
                }
                .padding(.top, 30)

                // Question Review Toggle
                Button {
                    withAnimation(.spring(response: 0.4)) {
                        showDetails.toggle()
                    }
                } label: {
                    HStack {
                        Text("Review Answers")
                            .font(.headline)
                        Spacer()
                        Image(systemName: showDetails ? "chevron.up" : "chevron.down")
                    }
                    .padding(16)
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                }
                .buttonStyle(.plain)
                .padding(.horizontal)

                // Question Details
                if showDetails {
                    VStack(spacing: 12) {
                        ForEach(Array(quiz.questions.enumerated()), id: \.element.id) { index, question in
                            if index < userAnswers.count {
                                ReviewQuestionRow(
                                    index: index + 1,
                                    question: question,
                                    userAnswer: userAnswers[index]
                                )
                            }
                        }
                    }
                    .padding(.horizontal)
                    .transition(.move(edge: .top).combined(with: .opacity))
                }

                // Actions
                VStack(spacing: 12) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Done")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(
                                LinearGradient(
                                    colors: gradientColors,
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .clipShape(Capsule())
                    }
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 30)
            }
        }
        .navigationTitle("Results")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .overlay(ConfettiView(isActive: $showConfetti).allowsHitTesting(false))
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.6).delay(0.2)) {
                animateScore = true
            }
            if passed {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    showConfetti = true
                }
            }
        }
    }
}

// MARK: - Review Question Row

struct ReviewQuestionRow: View {
    let index: Int
    let question: QuizQuestion
    let userAnswer: UserAnswer

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Image(systemName: userAnswer.isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .foregroundStyle(userAnswer.isCorrect ? .green : .red)

                Text("Q\(index)")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundStyle(.secondary)

                Spacer()

                DifficultyBadge(difficulty: question.difficulty)
            }

            Text(question.question)
                .font(.subheadline)
                .lineSpacing(2)

            if !userAnswer.isCorrect {
                VStack(alignment: .leading, spacing: 4) {
                    if userAnswer.selectedIndex >= 0 && userAnswer.selectedIndex < question.options.count {
                        HStack(spacing: 4) {
                            Text("Your answer:")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text(question.options[userAnswer.selectedIndex])
                                .font(.caption)
                                .foregroundStyle(.red)
                        }
                    }

                    HStack(spacing: 4) {
                        Text("Correct:")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Text(question.options[question.correctAnswerIndex])
                            .font(.caption)
                            .foregroundStyle(.green)
                            .fontWeight(.medium)
                    }
                }
            }

            Text(question.explanation)
                .font(.caption)
                .foregroundStyle(.secondary)
                .lineSpacing(2)
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(userAnswer.isCorrect ? Color.green.opacity(0.04) : Color.red.opacity(0.04))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .strokeBorder(
                            userAnswer.isCorrect ? Color.green.opacity(0.15) : Color.red.opacity(0.15),
                            lineWidth: 1
                        )
                )
        )
    }
}

#Preview {
    NavigationStack {
        QuizResultView(
            quiz: CourseContent.modules[0].quiz,
            score: 7,
            userAnswers: CourseContent.modules[0].quiz.questions.enumerated().map { index, q in
                UserAnswer(questionId: q.id, selectedIndex: index < 7 ? q.correctAnswerIndex : 0, isCorrect: index < 7)
            },
            gradientColors: [Color(hex: "667eea"), Color(hex: "764ba2")]
        )
    }
    .environment(UserProgressManager())
}
