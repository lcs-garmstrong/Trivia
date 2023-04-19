//
//  TriviaQuestion.swift
//  Trivia
//
//  Created by Graeme Armstrong on 2023-04-19.
//

import Foundation

struct TriviaQuestion: Codable {
    
    let category: String
    let difficulty: String
    let qestion: String
    let correct_answer: String
    let incorrect_answers: String
    
}