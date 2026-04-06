//
//  ViewModel.swift
//  AutoSecLearn
//
//  Created by meagan alfaro on 3/31/26.
//

import Foundation
import Combine

class ViewModel: ObservableObject {
    @Published var selectedAnswers: [Int: Int] = [:]
    @Published var showScore = false
    @Published var score = 0
    
    var questions: [Questions]
    
    init(questions: [Questions]) {
        self.questions = questions.map { question in
        Questions(
            text: question.text,
            options: question.options.shuffled()
        )}
    }
    
    func selectAnswer(questionIndex: Int, optionIndex: Int) {
        selectedAnswers[questionIndex] = optionIndex
    }
    
    func submit() {
        score = questions.indices.filter { qIndex in
            if let selectedIndex = selectedAnswers[qIndex] {
                return questions[qIndex].options[selectedIndex].isCorrect
            }
            return false
        }.count
        showScore = true
    }
    
    func reset(){
        selectedAnswers = [:]
        showScore = false
        score = 0
        
    }
    
    func isSelected(questionIndex: Int, optionIndex: Int) -> Bool {
        selectedAnswers[questionIndex] == optionIndex
    }
}
