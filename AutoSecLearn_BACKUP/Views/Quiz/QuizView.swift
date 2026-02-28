import SwiftUI

struct QuizView: View {
    @Environment(UserProgressManager.self) var progressManager
    @Environment(SoundManager.self) var soundManager
    @Environment(\.dismiss) private var dismiss
    let quiz: Quiz
    let gradientColors: [Color]

    @State private var currentQuestionIndex = 0
    @State private var selectedAnswerIndex: Int? = nil
    @State private var hasAnswered = false
    @State private var userAnswers: [UserAnswer] = []
    @State private var showResults = false
    @State private var score = 0

    // Timer
    @State private var timerEnabled = true
    @State private var timeRemaining = 0
    @State private var timerActive = false
    @State private var quizStarted = false
    @State private var timer: Timer?

    private let timePerQuestion = 30

    private var currentQuestion: QuizQuestion {
        quiz.questions[currentQuestionIndex]
    }

    private var progressValue: Double {
        Double(currentQuestionIndex + 1) / Double(quiz.questions.count)
    }

    private var timerColor: Color {
        let percentage = Double(timeRemaining) / Double(timePerQuestion)
        if percentage > 0.5 { return .green }
        if percentage > 0.25 { return .orange }
        return .red
    }

    var body: some View {
        if !quizStarted {
            quizStartView
        } else if showResults {
            QuizResultView(
                quiz: quiz,
                score: score,
                userAnswers: userAnswers,
                gradientColors: gradientColors
            )
        } else {
            quizQuestionView
        }
    }

    // MARK: - Start View

    private var quizStartView: some View {
        VStack(spacing: 30) {
            Spacer()

            Image(systemName: "trophy.fill")
                .font(.system(size: 60))
                .foregroundStyle(
                    LinearGradient(
                        colors: gradientColors,
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            VStack(spacing: 10) {
                Text(quiz.title)
                    .font(.title2)
                    .fontWeight(.bold)

                Text("\(quiz.questions.count) questions")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            VStack(spacing: 16) {
                Toggle(isOn: $timerEnabled) {
                    HStack {
                        Image(systemName: "timer")
                            .foregroundStyle(gradientColors[0])
                        VStack(alignment: .leading) {
                            Text("Timed Mode")
                                .font(.subheadline)
                                .fontWeight(.medium)
                            Text("\(timePerQuestion) seconds per question")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .tint(gradientColors[0])
            }
            .padding(20)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .padding(.horizontal)

            if let best = progressManager.bestScore(for: quiz.id) {
                HStack(spacing: 8) {
                    Image(systemName: "star.fill")
                        .foregroundStyle(.yellow)
                    Text("Best Score: \(Int(best.percentage))%")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }

            Spacer()

            Button {
                withAnimation(.spring(response: 0.4)) {
                    quizStarted = true
                    if timerEnabled {
                        timeRemaining = timePerQuestion
                        startTimer()
                    }
                }
            } label: {
                Text("Start Quiz")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        LinearGradient(
                            colors: gradientColors,
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .clipShape(Capsule())
                    .shadow(color: gradientColors[0].opacity(0.4), radius: 10, y: 5)
            }
            .padding(.horizontal, 30)
            .padding(.bottom, 40)
        }
        .navigationTitle("Quiz")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Question View

    private var quizQuestionView: some View {
        VStack(spacing: 0) {
            // Progress Bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle().fill(Color.gray.opacity(0.15))
                    Rectangle()
                        .fill(LinearGradient(colors: gradientColors, startPoint: .leading, endPoint: .trailing))
                        .frame(width: geometry.size.width * progressValue)
                        .animation(.spring(response: 0.4), value: progressValue)
                }
            }
            .frame(height: 4)

            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Question Header
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Question \(currentQuestionIndex + 1) of \(quiz.questions.count)")
                                .font(.caption)
                                .foregroundStyle(.secondary)

                            DifficultyBadge(difficulty: currentQuestion.difficulty)
                        }

                        Spacer()

                        if timerEnabled {
                            timerView
                        }
                    }

                    // Question Text
                    Text(currentQuestion.question)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .lineSpacing(4)

                    // Answer Options
                    VStack(spacing: 10) {
                        ForEach(Array(currentQuestion.options.enumerated()), id: \.offset) { index, option in
                            AnswerOptionButton(
                                text: option,
                                index: index,
                                isSelected: selectedAnswerIndex == index,
                                hasAnswered: hasAnswered,
                                isCorrect: index == currentQuestion.correctAnswerIndex,
                                accentColor: gradientColors[0]
                            ) {
                                guard !hasAnswered else { return }
                                withAnimation(.spring(response: 0.3)) {
                                    selectedAnswerIndex = index
                                }
                            }
                        }
                    }

                    // Explanation (shown after answering)
                    if hasAnswered {
                        HStack(alignment: .top, spacing: 10) {
                            Image(systemName: selectedAnswerIndex == currentQuestion.correctAnswerIndex
                                  ? "checkmark.circle.fill" : "lightbulb.fill")
                                .foregroundStyle(selectedAnswerIndex == currentQuestion.correctAnswerIndex
                                                 ? .green : .yellow)

                            Text(currentQuestion.explanation)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .lineSpacing(3)
                        }
                        .padding(14)
                        .background(Color(.secondarySystemGroupedBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                }
                .padding(20)
            }

            // Bottom Button
            VStack {
                if !hasAnswered {
                    Button {
                        submitAnswer()
                    } label: {
                        Text("Submit Answer")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(
                                selectedAnswerIndex != nil
                                ? LinearGradient(colors: gradientColors, startPoint: .leading, endPoint: .trailing)
                                : LinearGradient(colors: [.gray, .gray], startPoint: .leading, endPoint: .trailing)
                            )
                            .clipShape(Capsule())
                    }
                    .disabled(selectedAnswerIndex == nil)
                } else {
                    Button {
                        nextQuestion()
                    } label: {
                        Text(currentQuestionIndex < quiz.questions.count - 1 ? "Next Question" : "See Results")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(
                                LinearGradient(colors: gradientColors, startPoint: .leading, endPoint: .trailing)
                            )
                            .clipShape(Capsule())
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 14)
            .background(.ultraThinMaterial)
        }
        .navigationTitle("Quiz")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Timer View

    private var timerView: some View {
        HStack(spacing: 6) {
            Image(systemName: "timer")
                .font(.caption)

            Text("\(timeRemaining)s")
                .font(.system(.subheadline, design: .rounded))
                .fontWeight(.bold)
                .monospacedDigit()
        }
        .foregroundStyle(timerColor)
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(timerColor.opacity(0.1))
        .clipShape(Capsule())
        .scaleEffect(timeRemaining <= 5 && timeRemaining > 0 ? 1.1 : 1.0)
        .animation(.easeInOut(duration: 0.5).repeatForever(autoreverses: true),
                    value: timeRemaining <= 5 && timeRemaining > 0)
    }

    // MARK: - Actions

    private func submitAnswer() {
        stopTimer()
        withAnimation(.spring(response: 0.3)) {
            hasAnswered = true
            let correct = selectedAnswerIndex == currentQuestion.correctAnswerIndex
            if correct { score += 1 }
            userAnswers.append(UserAnswer(
                questionId: currentQuestion.id,
                selectedIndex: selectedAnswerIndex ?? -1,
                isCorrect: correct
            ))
        }
        // Sound + Haptic feedback
        soundManager.play(selectedAnswerIndex == currentQuestion.correctAnswerIndex ? .correctAnswer : .wrongAnswer)
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(
            selectedAnswerIndex == currentQuestion.correctAnswerIndex ? .success : .error
        )
    }

    private func nextQuestion() {
        if currentQuestionIndex < quiz.questions.count - 1 {
            withAnimation(.spring(response: 0.4)) {
                currentQuestionIndex += 1
                selectedAnswerIndex = nil
                hasAnswered = false
                if timerEnabled {
                    timeRemaining = timePerQuestion
                    startTimer()
                }
            }
        } else {
            let attempt = QuizAttempt(
                id: UUID(),
                quizId: quiz.id,
                score: score,
                totalQuestions: quiz.questions.count,
                date: Date(),
                answers: userAnswers
            )
            progressManager.addQuizAttempt(attempt)
            soundManager.play(.quizComplete)
            withAnimation(.spring(response: 0.5)) {
                showResults = true
            }
        }
    }

    private func startTimer() {
        stopTimer()
        timerActive = true
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [self] _ in
            MainActor.assumeIsolated {
                if timeRemaining > 0 {
                    timeRemaining -= 1
                } else {
                    if !hasAnswered {
                        if selectedAnswerIndex == nil {
                            selectedAnswerIndex = -1
                        }
                        submitAnswer()
                    }
                }
            }
        }
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
        timerActive = false
    }
}

// MARK: - Answer Option Button

struct AnswerOptionButton: View {
    let text: String
    let index: Int
    let isSelected: Bool
    let hasAnswered: Bool
    let isCorrect: Bool
    let accentColor: Color
    let action: () -> Void

    private let optionLabels = ["A", "B", "C", "D"]

    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                Text(optionLabels[index])
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundStyle(labelColor)
                    .frame(width: 32, height: 32)
                    .background(labelBackground)
                    .clipShape(Circle())

                Text(text)
                    .font(.subheadline)
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.leading)

                Spacer()

                if hasAnswered {
                    if isCorrect {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(.green)
                    } else if isSelected && !isCorrect {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.red)
                    }
                }
            }
            .padding(14)
            .background(optionBackground)
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .strokeBorder(borderColor, lineWidth: isSelected ? 2 : 1)
            )
        }
        .buttonStyle(.plain)
        .disabled(hasAnswered)
        .accessibilityLabel("Option \(optionLabels[index]): \(text)")
        .accessibilityValue(isSelected ? "Selected" : "")
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }

    private var labelColor: Color {
        if hasAnswered && isCorrect { return .white }
        if hasAnswered && isSelected && !isCorrect { return .white }
        if isSelected { return .white }
        return accentColor
    }

    private var labelBackground: Color {
        if hasAnswered && isCorrect { return .green }
        if hasAnswered && isSelected && !isCorrect { return .red }
        if isSelected { return accentColor }
        return accentColor.opacity(0.1)
    }

    private var optionBackground: Color {
        if hasAnswered && isCorrect { return .green.opacity(0.08) }
        if hasAnswered && isSelected && !isCorrect { return .red.opacity(0.08) }
        return Color(.secondarySystemGroupedBackground)
    }

    private var borderColor: Color {
        if hasAnswered && isCorrect { return .green.opacity(0.3) }
        if hasAnswered && isSelected && !isCorrect { return .red.opacity(0.3) }
        if isSelected { return accentColor }
        return Color.gray.opacity(0.15)
    }
}

// MARK: - Difficulty Badge

struct DifficultyBadge: View {
    let difficulty: Difficulty

    private var color: Color {
        switch difficulty {
        case .beginner: return .green
        case .intermediate: return .orange
        case .advanced: return .red
        }
    }

    var body: some View {
        Text(difficulty.rawValue)
            .font(.caption2)
            .fontWeight(.semibold)
            .foregroundStyle(color)
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .background(color.opacity(0.12))
            .clipShape(Capsule())
    }
}

#Preview {
    NavigationStack {
        QuizView(
            quiz: CourseContent.modules[0].quiz,
            gradientColors: [Color(hex: "667eea"), Color(hex: "764ba2")]
        )
    }
    .environment(UserProgressManager())
    .environment(SoundManager())
}
