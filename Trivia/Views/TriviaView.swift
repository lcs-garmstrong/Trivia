//
//  TriviaView.swift
//  Trivia
//
//  Created by Graeme Armstrong on 2023-04-19.
//

import Blackbird
import SwiftUI

struct TriviaView: View {
    // MARK: Stored properties
    
    // use to talk to DB
    @Environment(\.blackbirdDatabase) var db: Blackbird.Database?
    
    @State var correctAnswerOpacity = 0.0
    
    // list of trivia questions found by our search
    @State var foundTrivia: [TriviaQuestion]? = []
    
    // List of possible options
    @State var possibleAnswers: [String] = []
    
    // Category options
    @State var selectedCategory = 0
    
    // Track whether a trivia question has been saved to database
    @State var savedToDatabase = false
    
    // MARK: Computed properties
    var body: some View {
        NavigationView{
            VStack{
                if let trivia = foundTrivia {
                    List(trivia, id: \.self) { currentTrivia in
                        
                        VStack {
                            
                            Picker("Categories:",
                                   selection: $selectedCategory) {
                                ForEach(allCategories, id: \.categoryId) {currentCategory in
                                    Text("\(currentCategory.categoryName)")
                                        .tag(currentCategory.categoryId)
                                }
                            }
                                   .pickerStyle(.menu)
                                   .padding()
                                   .font(.title2)

                            
                            Text(currentTrivia.question.htmlDecoded)
                                .font(.title)
                                .multilineTextAlignment(.center)
                                .fixedSize(horizontal: false, vertical: true)
                            
                            // Show all 4 multiple choice answers
                            // DEBUG
                            //
                            //                                                 Text(dump(possibleAnswers).description)
                            
                            Button(action: {
                                correctAnswerOpacity = 1.0
                            }, label: {
                                Image(systemName: "arrow.down.circle.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40)
                                    .tint(.black)
                            })
                            
                            Text(currentTrivia.correct_answer)
                                .font(.title2)
                                .opacity(correctAnswerOpacity)
                            
                        }
                        
                    }
                    .listStyle(.plain)
                    .task{
                        foundTrivia = await NetworkService.fetch(resultsFor: selectedCategory)
                    }
                }
                
                Button(action: {
                    // Reset the interface
                    correctAnswerOpacity = 0.0
                    
                    Task {
                        // Get another joke
                        foundTrivia = await NetworkService.fetch(resultsFor: selectedCategory)
                    }
                }, label: {
                    Text("Next Question")
                })
                .buttonStyle(.borderedProminent)
                
                
                Button(action:{
                    Task {
                        // Write to database
                        if let triviaQuestions = foundTrivia {
                            try await db!.transaction { core in
                                for triviaQuestion in triviaQuestions {
                                    try core.query("INSERT INTO SavedQuestion (id, category, question, correct_answer) VALUES (?, ?, ?, ?)",
                                                   triviaQuestion.id,
                                                   triviaQuestion.category,
                                                   triviaQuestion.question,
                                                   triviaQuestion.correct_answer)
                                    
                                    // record if it's been saved to database
                                    savedToDatabase = true
                                }
                            }
                        }
                    }
                }, label: {
                    Text("Save Question")
                })
                // disable button until correct answer in shown
                .disabled(correctAnswerOpacity == 0.0 ? true : false)
                // once saved can't be saved again.
                
                // Why isn't this working??
                .disabled(savedToDatabase == true ? true : false)
                
                .buttonStyle(.borderedProminent)
                .tint(.green)
         
//                Get a list of all possible answers in random order
//                    Group {
//                        if let trivia = foundTrivia {
//                            if trivia.count > 0 {
//                                possibleAnswers = []
//                                possibleAnswers.append(trivia.first!.correct_answer)
//                                possibleAnswers.append(contentsOf: trivia.first!.incorrect_answers)
//                                possibleAnswers.shuffle()
//                                print(dump(possibleAnswers))
//                            }
//                        }
//                    }
//
            }
            .navigationTitle("Trivia")
        }
        .task {
            if foundTrivia == nil{
                foundTrivia = await NetworkService.fetch(resultsFor: selectedCategory)
            }
        }
    }
}

struct TriviaView_Previews: PreviewProvider {
    static var previews: some View {
        TriviaView()
            .environment(\.blackbirdDatabase, AppDatabase.instance)
    }
}
