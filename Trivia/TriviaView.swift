//
//  TriviaView.swift
//  Trivia
//
//  Created by Graeme Armstrong on 2023-04-19.
//

import SwiftUI

struct TriviaView: View {
    var body: some View {
        NavigationView{
            VStack{
                Text("Trivia Question")
                    .font(.title)
                    .multilineTextAlignment(.center)
                
                Button(action: {

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
