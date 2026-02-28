import Foundation

struct LearningModule: Identifiable, Codable {
    let id: String
    let title: String
    let description: String
    let icon: String
    let color: String
    let lessons: [Lesson]
    let quiz: Quiz

    var totalLessons: Int { lessons.count }
    var totalQuestions: Int { quiz.questions.count }
}

struct Lesson: Identifiable, Codable {
    let id: String
    let title: String
    let sections: [LessonSection]
}

struct LessonSection: Identifiable, Codable {
    let id: String
    let heading: String
    let content: String
    let interactiveElements: [InteractiveElement]?
}

struct InteractiveElement: Identifiable, Codable {
    let id: String
    let type: InteractiveType
    let prompt: String
    let correctAnswer: String
    let options: [String]?
    let explanation: String
}

enum InteractiveType: String, Codable {
    case fillInBlank
    case multipleChoice
    case trueFalse
    case dragAndDrop
}
