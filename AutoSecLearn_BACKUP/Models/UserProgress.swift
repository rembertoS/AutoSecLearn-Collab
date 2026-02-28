import Foundation
import SwiftUI
import Observation

// MARK: - App Mode

enum AppMode: String, CaseIterable {
    case learning = "learning"
    case reference = "reference"

    var displayName: String {
        switch self {
        case .learning: return "Learning Mode"
        case .reference: return "Reference Mode"
        }
    }

    var description: String {
        switch self {
        case .learning: return "Quiz-driven learning with assessments you must pass to complete each module."
        case .reference: return "Quick-reference for on-the-job use. Browse freely with optional quizzes."
        }
    }

    var icon: String {
        switch self {
        case .learning: return "graduationcap.fill"
        case .reference: return "book.fill"
        }
    }
}

// MARK: - XP Level System

enum XPLevel: String, CaseIterable {
    case beginner = "Beginner"
    case intermediate = "Intermediate"
    case advanced = "Advanced"
    case expert = "Expert"
    case networkGuru = "Network Guru"

    var threshold: Int {
        switch self {
        case .beginner: return 0
        case .intermediate: return 500
        case .advanced: return 1500
        case .expert: return 3500
        case .networkGuru: return 6000
        }
    }

    var icon: String {
        switch self {
        case .beginner: return "leaf.fill"
        case .intermediate: return "flame.fill"
        case .advanced: return "bolt.fill"
        case .expert: return "star.fill"
        case .networkGuru: return "crown.fill"
        }
    }

    static func level(for xp: Int) -> XPLevel {
        let sorted = allCases.sorted { $0.threshold > $1.threshold }
        return sorted.first { xp >= $0.threshold } ?? .beginner
    }
}

// MARK: - User Progress Manager

@Observable
class UserProgressManager {
    // Core progress
    var completedLessons: Set<String> = []
    var quizAttempts: [QuizAttempt] = []
    var interactiveAnswers: [String: String] = [:]
    var appMode: AppMode = .learning

    // Gamification
    var totalXP: Int = 0
    var currentStreak: Int = 0
    var lastActivityDate: Date? = nil
    var unlockedBadges: [Badge] = []

    // Bookmarks
    var bookmarkedLessons: Set<String> = []

    // Flashcard tracking
    var reviewedFlashcards: Set<String> = []

    // Persistence keys
    private let lessonsKey = "completedLessons"
    private let quizKey = "quizAttempts"
    private let modeKey = "appMode"
    private let xpKey = "totalXP"
    private let streakKey = "currentStreak"
    private let lastActivityKey = "lastActivityDate"
    private let badgesKey = "unlockedBadges"
    private let bookmarksKey = "bookmarkedLessons"
    private let flashcardsKey = "reviewedFlashcards"

    init() {
        loadProgress()
    }

    // MARK: - Mode

    func setMode(_ mode: AppMode) {
        appMode = mode
        UserDefaults.standard.set(mode.rawValue, forKey: modeKey)
    }

    var isLearningMode: Bool { appMode == .learning }
    var isReferenceMode: Bool { appMode == .reference }

    func isModuleComplete(for module: LearningModule) -> Bool {
        let allLessonsDone = moduleProgress(for: module) >= 1.0
        if isLearningMode {
            let quizPassed = bestScore(for: module.quiz.id)?.passed == true
            return allLessonsDone && quizPassed
        } else {
            return allLessonsDone
        }
    }

    // MARK: - Lesson Progress

    func markLessonComplete(_ lessonId: String) {
        guard !completedLessons.contains(lessonId) else { return }
        completedLessons.insert(lessonId)
        awardXP(20)
        updateStreak()
        checkBadges()
        saveProgress()
    }

    func isLessonComplete(_ lessonId: String) -> Bool {
        completedLessons.contains(lessonId)
    }

    func moduleProgress(for module: LearningModule) -> Double {
        let completed = module.lessons.filter { completedLessons.contains($0.id) }.count
        guard module.lessons.count > 0 else { return 0 }
        return Double(completed) / Double(module.lessons.count)
    }

    // MARK: - Quiz Progress

    func addQuizAttempt(_ attempt: QuizAttempt) {
        quizAttempts.append(attempt)
        if attempt.passed {
            awardXP(50)
            if attempt.percentage >= 100 {
                awardXP(100)
            }
        }
        updateStreak()
        checkBadges()
        saveProgress()
    }

    func bestScore(for quizId: String) -> QuizAttempt? {
        quizAttempts
            .filter { $0.quizId == quizId }
            .max(by: { $0.percentage < $1.percentage })
    }

    func overallProgress(modules: [LearningModule]) -> Double {
        let totalLessons = modules.reduce(0) { $0 + $1.lessons.count }
        guard totalLessons > 0 else { return 0 }
        return Double(completedLessons.count) / Double(totalLessons)
    }

    // MARK: - XP System

    func awardXP(_ amount: Int) {
        totalXP += amount
    }

    func awardInteractiveXP() {
        awardXP(10)
        checkBadges()
        saveProgress()
    }

    var currentLevel: XPLevel {
        XPLevel.level(for: totalXP)
    }

    var xpToNextLevel: Int {
        guard let nextLevel = XPLevel.allCases.first(where: { $0.threshold > totalXP }) else { return 0 }
        return nextLevel.threshold - totalXP
    }

    var xpProgressInLevel: Double {
        let current = currentLevel.threshold
        guard let nextIndex = XPLevel.allCases.firstIndex(of: currentLevel),
              nextIndex + 1 < XPLevel.allCases.count else { return 1.0 }
        let next = XPLevel.allCases[nextIndex + 1].threshold
        guard next > current else { return 1.0 }
        return Double(totalXP - current) / Double(next - current)
    }

    // MARK: - Streak System

    func updateStreak() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())

        if let lastDate = lastActivityDate {
            let lastDay = calendar.startOfDay(for: lastDate)
            let dayDiff = calendar.dateComponents([.day], from: lastDay, to: today).day ?? 0

            if dayDiff == 1 {
                currentStreak += 1
            } else if dayDiff > 1 {
                currentStreak = 1
            }
            // dayDiff == 0: same day, no change
        } else {
            currentStreak = 1
        }
        lastActivityDate = Date()
    }

    // MARK: - Bookmarks

    func toggleBookmark(_ lessonId: String) {
        if bookmarkedLessons.contains(lessonId) {
            bookmarkedLessons.remove(lessonId)
        } else {
            bookmarkedLessons.insert(lessonId)
        }
        saveProgress()
    }

    func isBookmarked(_ lessonId: String) -> Bool {
        bookmarkedLessons.contains(lessonId)
    }

    // MARK: - Flashcards

    func markFlashcardReviewed(_ questionId: String) {
        reviewedFlashcards.insert(questionId)
        saveProgress()
    }

    // MARK: - Badges

    func checkBadges() {
        let modules = CourseContent.modules
        let definitions = BadgeDefinitions.all
        var changed = false

        for definition in definitions {
            guard !unlockedBadges.contains(where: { $0.id == definition.id }) else { continue }

            let shouldUnlock: Bool = {
                switch definition.id {
                case "first_lesson":
                    return completedLessons.count >= 1
                case "five_lessons":
                    return completedLessons.count >= 5
                case "ten_lessons":
                    return completedLessons.count >= 10
                case "all_lessons":
                    let totalLessons = modules.reduce(0) { $0 + $1.lessons.count }
                    return completedLessons.count >= totalLessons
                case "first_quiz_pass":
                    return quizAttempts.contains { $0.passed }
                case "quiz_master":
                    let passedQuizIds = Set(quizAttempts.filter { $0.passed }.map { $0.quizId })
                    return passedQuizIds.count >= modules.count
                case "perfect_score":
                    return quizAttempts.contains { $0.percentage >= 100 }
                case "five_day_streak":
                    return currentStreak >= 5
                case "all_modules":
                    return modules.allSatisfy { isModuleComplete(for: $0) }
                case "xp_1000":
                    return totalXP >= 1000
                default:
                    return false
                }
            }()

            if shouldUnlock {
                var badge = definition
                badge.unlockedDate = Date()
                unlockedBadges.append(badge)
                changed = true
            }
        }

        if changed { saveProgress() }
    }

    // MARK: - Certificate

    var allModulesCompleted: Bool {
        CourseContent.modules.allSatisfy { isModuleComplete(for: $0) }
    }

    var completionDate: Date? {
        guard allModulesCompleted else { return nil }
        return quizAttempts.map(\.date).max() ?? Date()
    }

    // MARK: - Persistence

    private func saveProgress() {
        if let lessonsData = try? JSONEncoder().encode(Array(completedLessons)) {
            UserDefaults.standard.set(lessonsData, forKey: lessonsKey)
        }
        if let quizData = try? JSONEncoder().encode(quizAttempts) {
            UserDefaults.standard.set(quizData, forKey: quizKey)
        }

        UserDefaults.standard.set(totalXP, forKey: xpKey)
        UserDefaults.standard.set(currentStreak, forKey: streakKey)

        if let lastDate = lastActivityDate {
            UserDefaults.standard.set(lastDate.timeIntervalSince1970, forKey: lastActivityKey)
        }
        if let badgeData = try? JSONEncoder().encode(unlockedBadges) {
            UserDefaults.standard.set(badgeData, forKey: badgesKey)
        }
        if let bookmarkData = try? JSONEncoder().encode(Array(bookmarkedLessons)) {
            UserDefaults.standard.set(bookmarkData, forKey: bookmarksKey)
        }
        if let flashcardData = try? JSONEncoder().encode(Array(reviewedFlashcards)) {
            UserDefaults.standard.set(flashcardData, forKey: flashcardsKey)
        }
    }

    private func loadProgress() {
        // Core progress
        if let lessonsData = UserDefaults.standard.data(forKey: lessonsKey),
           let lessons = try? JSONDecoder().decode([String].self, from: lessonsData) {
            completedLessons = Set(lessons)
        }
        if let quizData = UserDefaults.standard.data(forKey: quizKey),
           let attempts = try? JSONDecoder().decode([QuizAttempt].self, from: quizData) {
            quizAttempts = attempts
        }
        if let modeString = UserDefaults.standard.string(forKey: modeKey),
           let mode = AppMode(rawValue: modeString) {
            appMode = mode
        }

        // Gamification
        totalXP = UserDefaults.standard.integer(forKey: xpKey)
        currentStreak = UserDefaults.standard.integer(forKey: streakKey)

        let lastActivityTimestamp = UserDefaults.standard.double(forKey: lastActivityKey)
        if lastActivityTimestamp > 0 {
            lastActivityDate = Date(timeIntervalSince1970: lastActivityTimestamp)
            let calendar = Calendar.current
            let today = calendar.startOfDay(for: Date())
            let lastDay = calendar.startOfDay(for: Date(timeIntervalSince1970: lastActivityTimestamp))
            let dayDiff = calendar.dateComponents([.day], from: lastDay, to: today).day ?? 0
            if dayDiff > 1 {
                currentStreak = 0
            }
        }

        if let badgeData = UserDefaults.standard.data(forKey: badgesKey),
           let badges = try? JSONDecoder().decode([Badge].self, from: badgeData) {
            unlockedBadges = badges
        }

        // Bookmarks
        if let bookmarkData = UserDefaults.standard.data(forKey: bookmarksKey),
           let bookmarks = try? JSONDecoder().decode([String].self, from: bookmarkData) {
            bookmarkedLessons = Set(bookmarks)
        }

        // Flashcards
        if let flashcardData = UserDefaults.standard.data(forKey: flashcardsKey),
           let flashcards = try? JSONDecoder().decode([String].self, from: flashcardData) {
            reviewedFlashcards = Set(flashcards)
        }
    }

    func resetProgress() {
        completedLessons.removeAll()
        quizAttempts.removeAll()
        interactiveAnswers.removeAll()
        totalXP = 0
        currentStreak = 0
        lastActivityDate = nil
        unlockedBadges.removeAll()
        bookmarkedLessons.removeAll()
        reviewedFlashcards.removeAll()
        saveProgress()
    }
}
