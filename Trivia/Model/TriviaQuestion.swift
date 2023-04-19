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
    let question: String
    let correct_answer: String
    let incorrect_answers: String
    
}

let triviaExample = TriviaQuestion(category: "Entertainment: Music", difficulty: "medium", question: "Which of these languages was NOT included in the 2016 song &quot;Don&#039;t Mind&quot; by Kent Jones?", correct_answer: "Portuguese", incorrect_answers: "Japanese, French, Spanish")
