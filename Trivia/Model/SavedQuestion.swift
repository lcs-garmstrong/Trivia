//
//  SavedQuestion.swift
//  Trivia
//
//  Created by Graeme Armstrong on 2023-06-02.
//

import Foundation


//
//  TriviaQuestion.swift
//  Trivia
//
//  Created by Graeme Armstrong on 2023-04-19.
//

import Blackbird
import Foundation

struct SavedQuestion: Identifiable, BlackbirdModel {
    
    @BlackbirdColumn var id: String
    @BlackbirdColumn var category: String
    @BlackbirdColumn var question: String
    @BlackbirdColumn var correct_answer: String
    @BlackbirdColumn var didUserAnswerCorrectly: Int

}
