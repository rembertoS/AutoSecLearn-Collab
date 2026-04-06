import Foundation
import Combine
import SwiftUI

@MainActor
final class ExamViewModel: ObservableObject {
    @Published var questions: [Questions]
    @Published private(set) var selections: [Int: Int] = [:] // questionIndex -> optionIndex
    @Published var showScore: Bool = false
    @Published private(set) var score: Int = 0

    init(questions: [Questions]) {
        self.questions = questions
    }

    func selectAnswer(questionIndex: Int, optionIndex: Int) {
        selections[questionIndex] = optionIndex
    }

    func isSelected(questionIndex: Int, optionIndex: Int) -> Bool {
        selections[questionIndex] == optionIndex
    }

    func submit() {
        var total = 0
        for (qIndex, question) in questions.enumerated() {
            if let selected = selections[qIndex], question.options.indices.contains(selected) {
                if question.options[selected].isCorrect { total += 1 }
            }
        }
        score = total
        showScore = true
    }

    func reset() {
        selections.removeAll()
        score = 0
        showScore = false
    }
}
