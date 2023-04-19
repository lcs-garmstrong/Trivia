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
    
    
    
    
    var body: some View {
        NavigationView{
            VStack{
                Text("Trivia Question")
                    .font(.title)
                    .multilineTextAlignment(.center)
                
                Button(action: {
                    punchlineOpacity = 1.0
                }, label: {
                    Image(systemName: "arrow.down.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40)
                        .tint(.black)
                })
                
                Text("Trivia Answer")
                    .font(.title)
                    .multilineTextAlignment(.center)
                    .opacity(punchlineOpacity)
                
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
