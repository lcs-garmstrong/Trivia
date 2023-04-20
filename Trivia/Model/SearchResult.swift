//
//  SearchResult.swift
//  Trivia
//
//  Created by Graeme Armstrong on 2023-04-19.
//

import Foundation

struct SearchResult: Codable, Hashable {
    
    let response_code: Int
    let results: [TriviaQuestion]
    
}

