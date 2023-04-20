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
    
    // MARK: Computed properties
    var body: some View {
        NavigationView{
            VStack{
                
                // ASK MR GORDON
                List(foundTrivia, id: \.self) { currentTrivia in
                
                    
                    VStack {
                        Text(currentTrivia.question)
                            .multilineTextAlignment(.center)
                            .font(.title)
                        
                        
                        // Show all 4 multiple choice answers
                        
                        //Correct answers
//                        Text(currentTrivia.correct_answer)
                        
                        // Incorrect answers
                        
                        
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
        }
    }
}

struct TriviaView_Previews: PreviewProvider {
    static var previews: some View {
        TriviaView()
    }
}
