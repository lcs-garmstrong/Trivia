//
//  TriviaView.swift
//  Trivia
//
//  Created by Graeme Armstrong on 2023-04-19.
//

import SwiftUI

struct TriviaView: View {
    // MARK: Stored properties
    
    @State var correctAnswerOpacity = 0.0
    
    // list of trivia questions found by our search
    @State var foundTrivia: [TriviaQuestion] = []
    
    // List of possible options
    @State var possibleAnswers: [String] = []
    
    // Category options
    let catergoryOptions = ["General Knowledge", "Entertainment: Books", "Entertainment: Film", "Entertainment: Music", "Science: Mathematics", "Sports", "History", "Geography", "Celebrities", "Animals", "Vehicles"]
    
    @State var selectedCategory = "General Knowledge"
    
    // MARK: Computed properties
    var body: some View {
        NavigationView{
            VStack{
                List(foundTrivia, id: \.self) { currentTrivia in
                    
                    VStack {
                        
                        Picker("Category",
                               selection: $selectedCategory) {
                            ForEach(catergoryOptions, id: \.self) {currentCategory in
                                Text("\(currentCategory)")
                                    .tag(currentCategory)
                            }
                        }
                               .pickerStyle(.menu)
                               .padding()
                        
                        Text(currentTrivia.question)
                            .font(.title)
                            .multilineTextAlignment(.center)
                            .fixedSize(horizontal: false, vertical: true)

                        
                        // Show all 4 multiple choice answers
                        // DEBUG
                        Text(dump(possibleAnswers).description)
                        
                        
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
                    foundTrivia = await NetworkService.fetch()
                }
                
                Button(action: {
                    // Reset the interface
                    correctAnswerOpacity = 0.0
                    
                    Task {
                        // Get another joke
                        foundTrivia = await NetworkService.fetch()
                    }
                }, label: {
                    Text("Next Question")
                })
                .buttonStyle(.borderedProminent)
                
            }
            .navigationTitle("Trivia")
        }
        .task {
            foundTrivia = await NetworkService.fetch()
            
            // Build the list of possible answers
            if foundTrivia.count > 0 {
                possibleAnswers = []
                possibleAnswers.append(foundTrivia.first!.correct_answer)
                possibleAnswers.append(contentsOf: foundTrivia.first!.incorrect_answers)
                possibleAnswers.shuffle()
                print(dump(possibleAnswers))
            }
        }
    }
}

struct TriviaView_Previews: PreviewProvider {
    static var previews: some View {
        TriviaView()
    }
}
