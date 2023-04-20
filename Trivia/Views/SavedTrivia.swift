//
//  SavedTrivia.swift
//  Trivia
//
//  Created by Graeme Armstrong on 2023-04-20.
//

import Blackbird
import SwiftUI


struct SavedTrivia: View {
    // MARK: Stored properties
    @BlackbirdLiveModels({ db in
        try await TriviaQuestion.read(from: db)
    }) var savedTrivia
    
    var body: some View {
        NavigationView{
            List(savedTrivia.results) { currentTrivia in
                VStack(alignment: .leading) {
                    Text(currentTrivia.question)
                        .bold()
                    Text(currentTrivia.correct_answer)
                    HStack{
                        Text("Category:")
                        Text(currentTrivia.category)
                    }

                }
            }
            .navigationTitle("Saved Trivia")
        }
    }
}

struct SavedTrivia_Previews: PreviewProvider {
    static var previews: some View {
        SavedTrivia()
            .environment(\.blackbirdDatabase, AppDatabase.instance)

    }
}
