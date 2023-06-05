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
    
    @State var animationAnswerOpacity = 0.0
    // list of trivia questions found by our search
    @State var foundTrivia: [TriviaQuestion]? = []
    // List of possible options
    @State var possibleAnswers: [String] = []
    // Category options
    @State var selectedCategory = 0
    // Track whether a trivia question has been saved to database
    @State var savedToDatabase = false

    @State var input = ""
    
    @State var answerChecked = false
    @State var answerCorrect = false

    
    // MARK: Computed properties
    var body: some View {
        NavigationView{
            VStack{
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
                
                if let trivia = foundTrivia {
                    List(trivia, id: \.self) { currentTrivia in
                        VStack {
                            
// Text(currentTrivia.question.htmlDecoded)
                            
                            Text(currentTrivia.question)
                                .font(.title)
                                .multilineTextAlignment(.center)
                                .fixedSize(horizontal: false, vertical: true)
                            
                            // Show all 4 multiple choice answers
                            Text(dump(possibleAnswers).description)
                            
                            HStack {
                                ZStack {
                                    // Only show this when the answer was found to be correct
                                    if answerCorrect == true {
                                        VStack {
                                            Image(systemName: "checkmark.circle")
                                                .foregroundColor(.green)
                                                .font(.title)
                                            Text("CORRECT!")
                                        }
                                    }
                                    // Show this when the answer was checked and found to be false
                                    if answerChecked == true && answerCorrect == false {
                                        VStack {
                                            Image(systemName: "x.square")
                                                .foregroundColor(.red)
                                                .font(.title)
                                            Text("Incorrect, correct answer was \(currentTrivia.correct_answer)")
                                        }
                                    }
                                }
                                
                                Spacer()
                                
                                TextField("Input answer",
                                          text: $input)
                                .multilineTextAlignment(.trailing)
                                .font(.title2)
                            }
                            .padding(.horizontal)
                            
                            Spacer()
                            
                            HStack {
                                Spacer()
                                
                                Button(action: {
                                    Task{
                                        if input == currentTrivia.correct_answer {
                                            answerCorrect = true
                                            answerChecked = true
                                            
                                            animationAnswerOpacity = 1
                                        } else {
                                            answerCorrect = false
                                            answerChecked = true
                                        }
                                    }
                                }) {
                                    Image(systemName: "checkmark.circle")
                                        .foregroundColor(.black)
                                        .font(.title)
                                        .bold()
                                }
                            }
                        }
                    }
                    .listStyle(.plain)
                    .task{
                        foundTrivia = await NetworkService.fetch(resultsFor: selectedCategory)
                    }
                }
                
                Button(action: {
                    // Reset the interface
                    animationAnswerOpacity = 0.0
                    input = ""
                    
                    Task {
                        // Get another joke
                        foundTrivia = await NetworkService.fetch(resultsFor: selectedCategory)
                        
                        processTriviaAnswers()
                        
                        savedToDatabase = false
                        answerChecked = false
                        answerCorrect = false
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
                .disabled(answerChecked == false)
                // once saved can't be saved again.
                .disabled(savedToDatabase == true ? true : false)
                
                .buttonStyle(.borderedProminent)
                .tint(.green)
            }
            .navigationTitle("Trivia")
        }
        .task {
            if foundTrivia == nil{
                foundTrivia = await NetworkService.fetch(resultsFor: selectedCategory)
            }
        }
    }
    
    // MARK: Functions
    func processTriviaAnswers() {
        if let trivia = foundTrivia {
            if trivia.count > 0 {
                possibleAnswers = []
                possibleAnswers.append(trivia.first!.correct_answer)
                possibleAnswers.append(contentsOf: trivia.first!.incorrect_answers)
                possibleAnswers.shuffle()
                print(dump(possibleAnswers))
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
