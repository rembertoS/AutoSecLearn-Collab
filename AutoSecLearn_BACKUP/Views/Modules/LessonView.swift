import SwiftUI

struct LessonView: View {
    @Environment(UserProgressManager.self) var progressManager
    @Environment(SoundManager.self) var soundManager
    @Environment(\.dismiss) private var dismiss
    let lesson: Lesson
    let moduleId: String
    let gradientColors: [Color]

    @State private var currentSectionIndex = 0
    @State private var showCompletionAlert = false
    @State private var showShareSheet = false
    @State private var showConfetti = false
    @State private var correctAnswers: Set<String> = []

    private var isLastSection: Bool {
        currentSectionIndex >= lesson.sections.count - 1
    }

    private var progressValue: Double {
        Double(currentSectionIndex + 1) / Double(lesson.sections.count)
    }

    /// In Learning Mode, all interactive elements must be answered correctly before moving on
    private var canProgress: Bool {
        guard progressManager.isLearningMode else { return true }
        guard let elements = lesson.sections[currentSectionIndex].interactiveElements,
              !elements.isEmpty else { return true }
        return elements.allSatisfy { correctAnswers.contains($0.id) }
    }

    var body: some View {
        VStack(spacing: 0) {
            // Progress Bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color.gray.opacity(0.15))
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: gradientColors,
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geometry.size.width * progressValue)
                        .animation(.spring(response: 0.4), value: progressValue)
                }
            }
            .frame(height: 4)

            // Section Content
            ScrollView {
                ScrollViewReader { proxy in
                    VStack(alignment: .leading, spacing: 24) {
                        // Section Header
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Section \(currentSectionIndex + 1) of \(lesson.sections.count)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .fontWeight(.medium)

                            Text(lesson.sections[currentSectionIndex].heading)
                                .font(.title2)
                                .fontWeight(.bold)
                        }
                        .id("top")

                        // Content paragraphs
                        ForEach(contentParagraphs, id: \.self) { paragraph in
                            Text(paragraph)
                                .font(.body)
                                .lineSpacing(6)
                                .foregroundStyle(.primary.opacity(0.9))
                        }

                        // Interactive Elements
                        if let elements = lesson.sections[currentSectionIndex].interactiveElements {
                            ForEach(elements) { element in
                                InteractiveElementView(
                                    element: element,
                                    accentColor: gradientColors[0],
                                    requireCorrect: progressManager.isLearningMode,
                                    onAnsweredCorrectly: {
                                        correctAnswers.insert(element.id)
                                    }
                                )
                            }
                        }

                        // Learning Mode hint when blocked
                        if progressManager.isLearningMode && !canProgress {
                            HStack(spacing: 8) {
                                Image(systemName: "lock.fill")
                                    .font(.caption)
                                Text("Answer all questions correctly to continue")
                                    .font(.caption)
                            }
                            .foregroundStyle(.orange)
                            .padding(12)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.orange.opacity(0.08))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        }

                        Spacer(minLength: 30)
                    }
                    .padding(20)
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing).combined(with: .opacity),
                        removal: .move(edge: .leading).combined(with: .opacity)
                    ))
                    .id(currentSectionIndex)
                    .onChange(of: currentSectionIndex) { _, _ in
                        withAnimation {
                            proxy.scrollTo("top", anchor: .top)
                        }
                    }
                }
            }

            // Bottom Navigation
            HStack(spacing: 16) {
                if currentSectionIndex > 0 {
                    Button {
                        withAnimation(.spring(response: 0.4)) {
                            currentSectionIndex -= 1
                        }
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: "chevron.left")
                            Text("Previous")
                        }
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundStyle(gradientColors[0])
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                        .background(gradientColors[0].opacity(0.1))
                        .clipShape(Capsule())
                    }
                }

                Spacer()

                Button {
                    if isLastSection {
                        progressManager.markLessonComplete(lesson.id)
                        showConfetti = true
                        soundManager.play(.achievement)
                        showCompletionAlert = true
                    } else {
                        withAnimation(.spring(response: 0.4)) {
                            currentSectionIndex += 1
                        }
                    }
                } label: {
                    HStack(spacing: 6) {
                        Text(isLastSection ? "Complete" : "Next")
                        Image(systemName: isLastSection ? "checkmark" : "chevron.right")
                    }
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(
                        LinearGradient(
                            colors: canProgress ? gradientColors : [Color.gray, Color.gray.opacity(0.7)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .clipShape(Capsule())
                    .shadow(color: (canProgress ? gradientColors[0] : Color.gray).opacity(0.3), radius: 6, y: 3)
                }
                .disabled(!canProgress)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 14)
            .background(.ultraThinMaterial)
        }
        .overlay(ConfettiView(isActive: $showConfetti).allowsHitTesting(false))
        .navigationTitle(lesson.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    progressManager.toggleBookmark(lesson.id)
                } label: {
                    Image(systemName: progressManager.isBookmarked(lesson.id) ? "bookmark.fill" : "bookmark")
                        .foregroundStyle(progressManager.isBookmarked(lesson.id) ? gradientColors[0] : .secondary)
                }
            }
        }
        .alert("Lesson Complete!", isPresented: $showCompletionAlert) {
            Button("Share with Friends") {
                showShareSheet = true
            }
            Button("Continue") {
                dismiss()
            }
        } message: {
            Text("Great work! You've completed \"\(lesson.title)\". Keep going!")
        }
        .sheet(isPresented: $showShareSheet) {
            let moduleName = CourseContent.modules.first { $0.id == moduleId }?.title ?? "a module"
            let totalCompleted = progressManager.completedLessons.count
            let shareText = "I just completed \"\(lesson.title)\" in \(moduleName) on AutoSec Learn! \(totalCompleted) lesson\(totalCompleted == 1 ? "" : "s") done so far. Learning network security one lesson at a time! 🔒📱 #AutoSecLearn #NetworkSecurity #COP4655"
            ShareSheet(items: [shareText])
                .presentationDetents([.medium])
        }
    }

    private var contentParagraphs: [String] {
        lesson.sections[currentSectionIndex].content
            .components(separatedBy: "\n")
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
    }
}

// MARK: - Interactive Element (Inline Questions)

struct InteractiveElementView: View {
    @Environment(SoundManager.self) var soundManager
    @Environment(UserProgressManager.self) var progressManager
    let element: InteractiveElement
    let accentColor: Color
    var requireCorrect: Bool = false
    var onAnsweredCorrectly: (() -> Void)? = nil

    @State private var selectedAnswer: String = ""
    @State private var hasSubmitted = false
    @State private var isCorrect = false
    @State private var shakeAmount: CGFloat = 0
    @State private var wrongAttempts = 0
    @State private var answerRevealed = false

    /// Whether to show the correct answer highlight (only after 2nd wrong attempt in Learning Mode, or always in Reference Mode)
    private var showCorrectAnswer: Bool {
        if !hasSubmitted { return false }
        if isCorrect { return true }
        if requireCorrect { return answerRevealed }
        return true // Reference Mode always shows
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 8) {
                Image(systemName: "pencil.and.outline")
                    .foregroundStyle(accentColor)
                Text("Check Your Understanding")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundStyle(accentColor)
            }

            Text(element.prompt)
                .font(.subheadline)
                .fontWeight(.medium)

            switch element.type {
            case .multipleChoice, .trueFalse:
                multipleChoiceView
            case .fillInBlank:
                fillInBlankView
            case .dragAndDrop:
                multipleChoiceView
            }

            if hasSubmitted {
                feedbackView
            }
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(hasSubmitted
                      ? (isCorrect ? Color.green.opacity(0.06) : Color.red.opacity(0.06))
                      : accentColor.opacity(0.04))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .strokeBorder(
                            hasSubmitted
                            ? (isCorrect ? Color.green.opacity(0.3) : Color.red.opacity(0.3))
                            : accentColor.opacity(0.15),
                            lineWidth: 1.5
                        )
                )
        )
        .offset(x: shakeAmount)
    }

    // MARK: - Multiple Choice

    private var multipleChoiceView: some View {
        VStack(spacing: 8) {
            ForEach(element.options ?? [], id: \.self) { option in
                Button {
                    guard !answerRevealed else { return }
                    guard !hasSubmitted || (hasSubmitted && !isCorrect && requireCorrect) else { return }
                    // If retrying after first wrong, reset submission state
                    if hasSubmitted && !isCorrect && requireCorrect {
                        withAnimation(.spring(response: 0.3)) {
                            hasSubmitted = false
                            isCorrect = false
                        }
                    }
                    selectedAnswer = option
                } label: {
                    HStack(spacing: 12) {
                        ZStack {
                            Circle()
                                .strokeBorder(
                                    selectedAnswer == option ? accentColor : Color.gray.opacity(0.3),
                                    lineWidth: 2
                                )
                                .frame(width: 22, height: 22)

                            if selectedAnswer == option {
                                Circle()
                                    .fill(accentColor)
                                    .frame(width: 12, height: 12)
                            }
                        }

                        Text(option)
                            .font(.subheadline)
                            .foregroundStyle(.primary)
                            .multilineTextAlignment(.leading)

                        Spacer()

                        if hasSubmitted && showCorrectAnswer && option == element.correctAnswer {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(.green)
                        } else if hasSubmitted && selectedAnswer == option && !isCorrect {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundStyle(.red)
                        }
                    }
                    .padding(12)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(optionBackground(for: option))
                    )
                }
                .buttonStyle(.plain)
                .disabled(answerRevealed || (hasSubmitted && (isCorrect || !requireCorrect)))
            }

            if !hasSubmitted {
                submitButton
            } else if !isCorrect && requireCorrect && !answerRevealed {
                retryButton
            }
        }
    }

    // MARK: - Fill in Blank

    private var fillInBlankView: some View {
        VStack(spacing: 12) {
            TextField("Type your answer...", text: $selectedAnswer)
                .textFieldStyle(.roundedBorder)
                .font(.subheadline)
                .disabled(answerRevealed || (hasSubmitted && (isCorrect || !requireCorrect)))
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)

            if !hasSubmitted {
                submitButton
            } else if !isCorrect && requireCorrect && !answerRevealed {
                retryButton
            }

            if answerRevealed && element.type == .fillInBlank {
                HStack(spacing: 6) {
                    Image(systemName: "lightbulb.fill")
                        .foregroundStyle(.green)
                    Text("Answer: \(element.correctAnswer)")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundStyle(.green)
                }
                .padding(10)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.green.opacity(0.08))
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
        }
    }

    // MARK: - Submit Button

    private var submitButton: some View {
        Button {
            checkAnswer()
        } label: {
            Text("Check Answer")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(
                    selectedAnswer.isEmpty
                    ? Color.gray
                    : accentColor
                )
                .clipShape(Capsule())
        }
        .disabled(selectedAnswer.isEmpty)
    }

    // MARK: - Retry Button

    private var retryButton: some View {
        Button {
            withAnimation(.spring(response: 0.3)) {
                hasSubmitted = false
                isCorrect = false
                selectedAnswer = ""
            }
        } label: {
            HStack(spacing: 6) {
                Image(systemName: "arrow.counterclockwise")
                Text("Try Again")
            }
            .font(.subheadline)
            .fontWeight(.semibold)
            .foregroundStyle(accentColor)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background(accentColor.opacity(0.1))
            .clipShape(Capsule())
        }
    }

    // MARK: - Check Answer Logic

    private func checkAnswer() {
        withAnimation(.spring(response: 0.3)) {
            hasSubmitted = true
            isCorrect = selectedAnswer.lowercased().trimmingCharacters(in: .whitespaces)
                == element.correctAnswer.lowercased().trimmingCharacters(in: .whitespaces)
        }

        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(isCorrect ? .success : .error)

        if isCorrect {
            soundManager.play(.correctAnswer)
            progressManager.awardInteractiveXP()
            onAnsweredCorrectly?()
        } else {
            soundManager.play(.wrongAnswer)
            wrongAttempts += 1

            // After 2nd wrong attempt in Learning Mode, reveal the answer but no credit
            if requireCorrect && wrongAttempts >= 2 {
                withAnimation(.spring(response: 0.4)) {
                    answerRevealed = true
                }
                // Unlock progression but mark as revealed (no real credit)
                onAnsweredCorrectly?()
            }

            withAnimation(.spring(response: 0.1, dampingFraction: 0.2)) {
                shakeAmount = 10
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation(.spring(response: 0.1, dampingFraction: 0.5)) {
                    shakeAmount = 0
                }
            }
        }
    }

    // MARK: - Feedback

    private var feedbackView: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: isCorrect
                  ? "checkmark.circle.fill"
                  : (answerRevealed ? "eye.fill" : "info.circle.fill"))
                .foregroundStyle(isCorrect ? .green : (answerRevealed ? .red : .orange))
                .font(.title3)

            VStack(alignment: .leading, spacing: 4) {
                if answerRevealed {
                    Text("Answer revealed - no credit.")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundStyle(.red)
                } else {
                    Text(isCorrect ? "Correct!" : "Not quite. Try again!")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundStyle(isCorrect ? .green : .orange)
                }

                Text(element.explanation)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineSpacing(3)
            }
        }
        .transition(.move(edge: .top).combined(with: .opacity))
    }

    // MARK: - Helpers

    private func optionBackground(for option: String) -> Color {
        if !hasSubmitted {
            return selectedAnswer == option ? accentColor.opacity(0.08) : Color.clear
        }
        if showCorrectAnswer && option == element.correctAnswer {
            return Color.green.opacity(0.1)
        }
        if selectedAnswer == option && !isCorrect {
            return Color.red.opacity(0.1)
        }
        return Color.clear
    }
}

// MARK: - Share Sheet

struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

#Preview {
    NavigationStack {
        LessonView(
            lesson: CourseContent.modules[0].lessons[0],
            moduleId: "switch_1",
            gradientColors: [Color(hex: "667eea"), Color(hex: "764ba2")]
        )
    }
    .environment(UserProgressManager())
    .environment(SoundManager())
}
