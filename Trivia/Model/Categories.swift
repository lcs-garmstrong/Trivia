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

let science = CategoryDescription(categoryName: "Science: Mathematics", categoryId: 19)

let sports = CategoryDescription(categoryName: "Sports", categoryId: 21)

let geography = CategoryDescription(categoryName: "Geography", categoryId: 22)

let history = CategoryDescription(categoryName: "History", categoryId: 23)

let celebrities = CategoryDescription(categoryName: "Celebrities", categoryId: 26)

let animals = CategoryDescription(categoryName: "Animals", categoryId: 27)

let vehicles = CategoryDescription(categoryName: "Vehicles", categoryId: 28)

let allCategories = [generalKnowledge, books, film, music, science, sports, geography, history, celebrities, animals, vehicles]
