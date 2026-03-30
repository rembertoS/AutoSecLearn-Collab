//
//  Quiz.swift
//  AutoSecLearn
//
//  Created by Remberto Silva on 3/30/26.
//

import Foundation

struct Quiz: Identifiable, Codable {
    let id: String
    let title: String
    let questions: [QuizQuestion]
}

struct QuizQuestion: Identifiable, Codable {
    let id: String
    let question: String
    let options: [String]
    let correctAnswerIndex: Int
    let explanation: String
    let difficulty: Difficulty
}

enum Difficulty: String, Codable, CaseIterable {
    case beginner = "Beginner"
    case intermediate = "Intermediate"
    case advanced = "Advanced"

    var color: String {
        switch self {
        case .beginner: return "green"
        case .intermediate: return "orange"
        case .advanced: return "red"
        }
    }
}

struct QuizAttempt: Identifiable, Codable {
    let id: UUID
    let quizId: String
    let score: Int
    let totalQuestions: Int
    let date: Date
    let answers: [UserAnswer]

    var percentage: Double {
        guard totalQuestions > 0 else { return 0 }
        return Double(score) / Double(totalQuestions) * 100
    }

    var passed: Bool { percentage >= 70 }
}

struct UserAnswer: Codable {
    let questionId: String
    let selectedIndex: Int
    let isCorrect: Bool
}
