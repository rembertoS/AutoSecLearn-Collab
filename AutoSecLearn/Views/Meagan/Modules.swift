//
//  Modules.swift
//  AutoSecLearn
//
//  Created by meagan alfaro on 3/31/26.
//

import Foundation


struct Module{
    var name: String
    var questions:  [Questions]

}

struct Questions {
    var text: String
    var options: [AnswerOption]
}

struct AnswerOption {
    var answer: String
    var isCorrect: Bool
}
