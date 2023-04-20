//
//  TriviaQuestion.swift
//  Trivia
//
//  Created by Graeme Armstrong on 2023-04-19.
//

import Foundation

struct TriviaQuestion:  Codable, Hashable {
    
    let category: String
    let question: String
    let correct_answer: String
    let incorrect_answers: [String]
    
}
