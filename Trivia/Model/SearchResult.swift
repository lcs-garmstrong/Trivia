//
//  SearchResult.swift
//  Trivia
//
//  Created by Graeme Armstrong on 2023-04-19.
//

import Foundation

struct SearchResult: Codable{
    
    let response_code: Int
    let results: [TriviaQuestion]
    
}

