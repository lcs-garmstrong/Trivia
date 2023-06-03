//
//  TriviaQuestion.swift
//  Trivia
//
//  Created by Graeme Armstrong on 2023-04-19.
//

import Foundation
import CryptoKit

struct TriviaQuestion: Hashable, Codable {
    
    var id: String
    var category: String
    var question: String
    var correct_answer: String
    var incorrect_answers: [String]
    
    // Got Part of this code from CHAT GPT
    // used to geberate unique string ID
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        category = try container.decode(String.self, forKey: .category)
        question = try container.decode(String.self, forKey: .question)
        correct_answer = try container.decode(String.self, forKey: .correct_answer)
        incorrect_answers = try container.decode([String].self, forKey: .incorrect_answers)
        self.id = ""
        generateId()
    }
    
    private mutating func generateId() {
        // Generate a unique ID based on the question data
        let data = Data("\(category)\(question)\(correct_answer)".utf8)
        id = SHA256.hash(data: data).compactMap { String(format: "%02x", $0) }.joined()
    }
}
