import Foundation

struct Badge: Identifiable, Codable, Equatable {
    let id: String
    let name: String
    let icon: String
    let description: String
    var unlockedDate: Date?

    var isUnlocked: Bool { unlockedDate != nil }
}

enum BadgeDefinitions {
    static let all: [Badge] = [
        Badge(id: "first_lesson", name: "First Step", icon: "star.fill",
              description: "Complete your first lesson"),
        Badge(id: "five_lessons", name: "Dedicated Learner", icon: "book.fill",
              description: "Complete 5 lessons"),
        Badge(id: "ten_lessons", name: "Knowledge Seeker", icon: "books.vertical.fill",
              description: "Complete 10 lessons"),
        Badge(id: "all_lessons", name: "Completionist", icon: "trophy.fill",
              description: "Complete all 33 lessons"),
        Badge(id: "first_quiz_pass", name: "Quiz Starter", icon: "checkmark.seal.fill",
              description: "Pass your first quiz"),
        Badge(id: "quiz_master", name: "Quiz Master", icon: "crown.fill",
              description: "Pass all 10 module quizzes"),
        Badge(id: "perfect_score", name: "Perfect Score", icon: "star.circle.fill",
              description: "Score 100% on any quiz"),
        Badge(id: "five_day_streak", name: "On Fire", icon: "flame.fill",
              description: "Maintain a 5-day study streak"),
        Badge(id: "all_modules", name: "Network Guru", icon: "shield.checkered",
              description: "Complete all modules"),
        Badge(id: "xp_1000", name: "XP Hunter", icon: "bolt.fill",
              description: "Earn 1,000 XP")
    ]
}
