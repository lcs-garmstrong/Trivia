//
//  TriviaQuestion.swift
//  Trivia
//
//  Created by Graeme Armstrong on 2023-04-19.
//

// MARK: Got Part of this code from CHAT GPT

import Blackbird
import Foundation
import CryptoKit

struct TriviaQuestion: Hashable, Codable, BlackbirdModel {
    static let tableName = "TriviaQuestion"
    static let primaryKey = "id"
    
    @BlackbirdColumn var id: String
    @BlackbirdColumn var category: String
    @BlackbirdColumn var question: String
    @BlackbirdColumn var correct_answer: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        category = try container.decode(String.self, forKey: .category)
        question = try container.decode(String.self, forKey: .question)
        correct_answer = try container.decode(String.self, forKey: .correct_answer)
        self.id = ""
        generateId()
    }
    
    private mutating func generateId() {
        // Generate a unique ID based on the question data
        let data = Data("\(category)\(question)\(correct_answer)".utf8)
        id = SHA256.hash(data: data).compactMap { String(format: "%02x", $0) }.joined()
    }
}
