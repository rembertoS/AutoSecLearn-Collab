//
//  ModuleDetail.swift
//  AutoSecLearn
//
//  Created by Remberto Silva on 3/30/26.
//

import SwiftUI

struct ModuleDetail: View {
    let module: LearningModule
    @State private var animateIn = false

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
        ScrollView {
            VStack(spacing: 0) {
                heroHeader
                lessonsSection
                quizSection
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

    // MARK: - Lessons Section

    private var lessonsSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Lessons")
                .font(.title3)
                .fontWeight(.bold)
                .padding(.horizontal)
                .padding(.top, 20)

            ForEach(Array(module.lessons.enumerated()), id: \.element.id) { index, lesson in
                NavigationLink {
                    LessonView(lesson: lesson, gradientColors: gradientColors)
                } label: {
                    LessonRow(lesson: lesson, index: index, accentColor: gradientColors[0])
                }
                .buttonStyle(.plain)
                .padding(.horizontal)
            }
        }
        .padding(.bottom, 8)
    }

    // MARK: - Quiz Section

    private var quizSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Assessment")
                .font(.title3)
                .fontWeight(.bold)
                .padding(.horizontal)
                .padding(.top, 8)

            HStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(
                            LinearGradient(
                                colors: gradientColors,
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 48, height: 48)

                    Image(systemName: "checkmark.seal.fill")
                        .font(.title3)
                        .foregroundStyle(.white)
                }

                VStack(alignment: .leading, spacing: 3) {
                    Text(module.quiz.title)
                        .font(AppTheme.headline)

                    Text("\(module.quiz.questions.count) questions")
                        .font(AppTheme.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Text("Coming Soon")
                    .font(.caption2)
                    .fontWeight(.semibold)
                    .foregroundStyle(gradientColors[0])
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(gradientColors[0].opacity(0.1))
                    .clipShape(Capsule())
            }
            .padding(AppTheme.paddingMedium)
            .background(AppTheme.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: AppTheme.cornerRadius))
            .padding(.horizontal)
        }
        .padding(.bottom, 30)
    }
}

// MARK: - Lesson Row

struct LessonRow: View {
    let lesson: Lesson
    let index: Int
    let accentColor: Color

    private var interactiveCount: Int {
        lesson.sections.compactMap { $0.interactiveElements }.flatMap { $0 }.count
    }

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(accentColor.opacity(0.12))
                    .frame(width: 44, height: 44)

                Text("\(index + 1)")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundStyle(accentColor)
            }

            VStack(alignment: .leading, spacing: 3) {
                Text(lesson.title)
                    .font(AppTheme.headline)
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.leading)

                HStack(spacing: 10) {
                    Label("\(lesson.sections.count) sections", systemImage: "doc.text")
                    if interactiveCount > 0 {
                        Label("\(interactiveCount) questions", systemImage: "pencil.and.outline")
                    }
                }
                .font(.caption2)
                .foregroundStyle(.secondary)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(.tertiary)
        }
        .padding(AppTheme.paddingMedium)
        .background(AppTheme.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.cornerRadius))
    }
}

#Preview {
    NavigationStack {
        ModuleDetail(module: ModuleContent.modules[0])
    }
}

