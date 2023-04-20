//
//  Categories.swift
//  Trivia
//
//  Created by Graeme Armstrong on 2023-04-20.
//

import Foundation

struct CategoryDescription: Hashable { 
    let categoryName: String
    let categoryId: Int
}

let generalKnowledge = CategoryDescription(categoryName: "General Knowledge", categoryId: 9)

let books = CategoryDescription(categoryName: "Entertainment: Books", categoryId: 10)

let film = CategoryDescription(categoryName: "Entertainment: Film", categoryId: 11)

let music = CategoryDescription(categoryName: "Entertainment: Music", categoryId: 12)

let allCategories = [generalKnowledge, books, film, music]
