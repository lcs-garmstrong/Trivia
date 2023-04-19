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
                List(foundTrivia, id: \.question) { currentTrivia in
                    VStack {
                        Text(currentTrivia.question)
                            .bold()
                        
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
                            .opacity(correctAnswerOpacity)
                        
                        
                    }
                }
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
    }
}

struct TriviaView_Previews: PreviewProvider {
    static var previews: some View {
        TriviaView()
    }
}
