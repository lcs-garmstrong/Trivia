//
//  TriviaView.swift
//  Trivia
//
//  Created by Graeme Armstrong on 2023-04-19.
//

import SwiftUI

struct TriviaView: View {
    // MARK: Stored properties
    
    @State var punchlineOpacity = 0.0
    
    @State var currentTrivia: TriviaQuestion?
    
    
    var body: some View {
        NavigationView{
            VStack{
                
                if let currentTrivia = currentTrivia {
                    
                    Text(currentTrivia.question)
                        .font(.title)
                        .multilineTextAlignment(.center)
                    
                    Button(action: {
                        withAnimation(.easeIn(duration: 1.0)) {
                            punchlineOpacity = 1.0
                        }
                    }, label: {
                        Image(systemName: "arrow.down.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40)
                            .tint(.black)
                    })
                    
                    Text(currentTrivia.correct_answer)
                        .font(.title)
                        .multilineTextAlignment(.center)
                        .opacity(punchlineOpacity)
                    
                } else {
                    
                    // show spinning wheel
                    ProgressView()
                }
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
