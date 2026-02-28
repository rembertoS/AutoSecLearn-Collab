import SwiftUI

struct ModuleDetailView: View {
    @Environment(UserProgressManager.self) var progressManager
    let module: LearningModule
    @State private var animateIn = false

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
        ScrollView {
            VStack(spacing: 0) {
                heroHeader
                lessonsSection
                quizSection
                studyToolsSection
            }
        }
        .background(Color(.systemGroupedBackground))
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.1)) {
                animateIn = true
            }
        }
    }

    // MARK: - Hero Header

    private var heroHeader: some View {
        VStack(spacing: 16) {
            Image(systemName: module.icon)
                .font(.system(size: 50, weight: .semibold))
                .foregroundStyle(.white)
                .frame(width: 90, height: 90)
                .background(.white.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 24))
                .scaleEffect(animateIn ? 1 : 0.5)
                .opacity(animateIn ? 1 : 0)

            VStack(spacing: 8) {
                Text(module.title)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)

                Text(module.description)
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.85))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            .opacity(animateIn ? 1 : 0)
            .offset(y: animateIn ? 0 : 20)

            HStack(spacing: 24) {
                Label("\(module.totalLessons) Lessons", systemImage: "doc.text.fill")
                Label("\(module.totalQuestions) Questions", systemImage: "questionmark.circle.fill")
            }
            .font(.caption)
            .foregroundStyle(.white.opacity(0.8))

            ProgressRing(
                progress: progressManager.moduleProgress(for: module),
                lineWidth: 6,
                size: 60,
                gradientColors: [.white, .white.opacity(0.6)]
            )
        }
        .padding(.vertical, 30)
        .frame(maxWidth: .infinity)
        .background(
            LinearGradient(
                colors: gradientColors,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
    }

    // MARK: - Lessons

    private var lessonsSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Lessons")
                .font(.title3)
                .fontWeight(.bold)
                .padding(.horizontal)
                .padding(.top, 20)

            ForEach(Array(module.lessons.enumerated()), id: \.element.id) { index, lesson in
                NavigationLink {
                    LessonView(lesson: lesson, moduleId: module.id, gradientColors: gradientColors)
                } label: {
                    LessonRow(
                        index: index + 1,
                        lesson: lesson,
                        isCompleted: progressManager.isLessonComplete(lesson.id),
                        accentColor: gradientColors[0]
                    )
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal)
    }

    // MARK: - Quiz

    private var quizSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .center, spacing: 8) {
                Text(progressManager.isLearningMode ? "Assessment" : "Practice Quiz")
                    .font(.title3)
                    .fontWeight(.bold)

                if progressManager.isReferenceMode {
                    Text("Optional")
                        .font(.caption2)
                        .fontWeight(.semibold)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(Color.gray.opacity(0.12))
                        .clipShape(Capsule())
                }
            }
            .padding(.top, 10)

            NavigationLink {
                QuizView(quiz: module.quiz, gradientColors: gradientColors)
            } label: {
                HStack(spacing: 16) {
                    Image(systemName: "trophy.fill")
                        .font(.title2)
                        .foregroundStyle(gradientColors[0])
                        .frame(width: 50, height: 50)
                        .background(gradientColors[0].opacity(0.12))
                        .clipShape(RoundedRectangle(cornerRadius: 12))

                    VStack(alignment: .leading, spacing: 4) {
                        Text(module.quiz.title)
                            .font(.headline)
                            .foregroundStyle(.primary)

                        Text("\(module.quiz.questions.count) questions")
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        if let best = progressManager.bestScore(for: module.quiz.id) {
                            HStack(spacing: 4) {
                                Image(systemName: best.passed ? "checkmark.circle.fill" : "xmark.circle.fill")
                                    .foregroundStyle(best.passed ? .green : .red)
                                Text("Best: \(Int(best.percentage))%")
                                    .foregroundStyle(best.passed ? .green : .red)
                            }
                            .font(.caption)
                        }
                    }

                    Spacer()

                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding(16)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .buttonStyle(.plain)

            if progressManager.isLearningMode {
                HStack(spacing: 6) {
                    Image(systemName: "info.circle")
                        .font(.caption)
                    Text("Score 70% or higher to complete this module")
                        .font(.caption)
                }
                .foregroundStyle(.secondary)
                .padding(.horizontal, 4)
            }
        }
        .padding(.horizontal)
        .padding(.bottom, 30)
    }

    // MARK: - Study Tools

    private var studyToolsSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Study Tools")
                .font(.title3)
                .fontWeight(.bold)
                .padding(.top, 10)

            NavigationLink {
                FlashcardView(
                    questions: module.quiz.questions,
                    gradientColors: gradientColors
                )
            } label: {
                HStack(spacing: 16) {
                    Image(systemName: "rectangle.on.rectangle.angled")
                        .font(.title2)
                        .foregroundStyle(gradientColors[0])
                        .frame(width: 50, height: 50)
                        .background(gradientColors[0].opacity(0.12))
                        .clipShape(RoundedRectangle(cornerRadius: 12))

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Flashcards")
                            .font(.headline)
                            .foregroundStyle(.primary)

                        Text("\(module.quiz.questions.count) cards to review")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }

                    Spacer()

                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding(16)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal)
        .padding(.bottom, 30)
    }
}

// MARK: - Lesson Row

struct LessonRow: View {
    let index: Int
    let lesson: Lesson
    let isCompleted: Bool
    let accentColor: Color

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(isCompleted ? Color.green : accentColor.opacity(0.12))
                    .frame(width: 40, height: 40)

                if isCompleted {
                    Image(systemName: "checkmark")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                } else {
                    Text("\(index)")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(accentColor)
                }
            }

            VStack(alignment: .leading, spacing: 3) {
                Text(lesson.title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(.primary)

                Text("\(lesson.sections.count) sections")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .padding(14)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}

#Preview {
    NavigationStack {
        ModuleDetailView(module: CourseContent.modules[0])
    }
    .environment(UserProgressManager())
    .environment(SoundManager())
}
