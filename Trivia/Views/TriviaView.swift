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
    
    @Environment(\.blackbirdDatabase) var db: Blackbird.Database?
    
    @State var correctAnswerOpacity = 0.0
    
    // list of trivia questions found by our search
    @State var foundTrivia: [TriviaQuestion]? = []
    
    // List of possible options
    @State var possibleAnswers: [String] = []
    
    // Category options
    @State var selectedCategory = 0
    
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
                            
                            
                            //                        if let decodedQuestion = String(htmlEncodedString: currentTrivia.question) {
                            //                            Text(decodedQuestion)
                            //                        } else {
                            //                            // Return when faild to decode
                            //                            Text("Failed to decode question")
                            //                        }
                            
                            
                            Text(currentTrivia.question)
                                .font(.title)
                                .multilineTextAlignment(.center)
                                .fixedSize(horizontal: false, vertical: true)
                            
                            // Show all 4 multiple choice answers
                            // DEBUG
                            //                        Text(dump(possibleAnswers).description)
                            
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
                                    try core.query("INSERT INTO TriviaQuestion (id, category, question, correct_answer) VALUES (?, ?, ?, ?)",
                                                   triviaQuestion.id,
                                                   triviaQuestion.category,
                                                   triviaQuestion.question,
                                                   triviaQuestion.correct_answer)
                                }
                            }
                        }
                    }
                }, label: {
                    Text("Save for later")
                })
                
            }
            .navigationTitle("Trivia")
        }
        .task {
            foundTrivia = await NetworkService.fetch(resultsFor: selectedCategory)
            
            // Build the list of possible answers
            //            if foundTrivia.count > 0 {
            //                possibleAnswers = []
            //                possibleAnswers.append(foundTrivia.first!.correct_answer)
            //                possibleAnswers.append(contentsOf: foundTrivia.first!.incorrect_answers)
            //                possibleAnswers.shuffle()
            //                print(dump(possibleAnswers))
            //            }
        }
    }
}

struct TriviaView_Previews: PreviewProvider {
    static var previews: some View {
        TriviaView()
            .environment(\.blackbirdDatabase, AppDatabase.instance)
    }
}
