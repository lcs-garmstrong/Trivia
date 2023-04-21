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
    // for searchbar
    @State var searchText = ""
    
    @BlackbirdLiveModels({ db in
        try await TriviaQuestion.read(from: db,
        sqlWhere: "category LIKE ?", "%\(searchText)")
    }) var savedTrivia
    
    // use to talk to DB
    @Environment(\.blackbirdDatabase) var db: Blackbird.Database?
    
    var body: some View {
        NavigationView{
            List{
                
                ForEach(savedTrivia.results) { currentTrivia in
                    VStack(alignment: .leading) {
                        
                        HStack{
                            Text("Category:")
                                .bold()
                            Text(currentTrivia.category)
                        }
                        Spacer()
                        Text(currentTrivia.question)
                            .font(.title3)
                            .bold()
                        
                        Text(currentTrivia.correct_answer)
                            .font(.title3)
                        
                    }
                    .padding(5)
                }
                .onDelete(perform: removeRows)
            }
            .searchable(text: $searchText)
            .navigationTitle("Saved Trivia:")
        }
    }
    
    // MARK: Functions:
    func removeRows(at offsets: IndexSet){
        Task{
            try await db!.transaction { core in
                var idList = ""
                for offset in offsets {
                    idList += "\(savedTrivia.results[offset].id),"
                }
                
                // romove final coma
                print(idList)
                idList.removeLast()
                print(idList)
                
                try core.query("DELETE FROM TriviaQuestion WHERE id IN (?)", idList)
            }
        }

    }
}


struct SavedTrivia_Previews: PreviewProvider {
    static var previews: some View {
        SavedTrivia()
            .environment(\.blackbirdDatabase, AppDatabase.instance)
        
    }
}
