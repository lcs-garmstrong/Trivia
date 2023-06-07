//
//  SavedTriviaItemView.swift
//  Trivia
//
//  Created by Graeme Armstrong on 2023-04-20.
//

import Blackbird
import SwiftUI

struct SavedTriviaItemView: View {
    // MARK: Stored properties
    
    // use to talk to DB
    @Environment(\.blackbirdDatabase) var db: Blackbird.Database?
    
    @BlackbirdLiveModels var savedTrivia: Blackbird.LiveResults<SavedQuestion>
    
    
    // MARK: Computed properties
    var body: some View {
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
    }
    
    // MARK: Initializer(s)
    init(filteredOn searchText: String) {
        
        // initialize live model
        _savedTrivia = BlackbirdLiveModels({ db in
            try await SavedQuestion.read(from: db,
            sqlWhere: "category LIKE ?", "%\(searchText)%")
        })
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
                
                try core.query("DELETE FROM SavedQuestion WHERE id IN (?)", idList)
            }
        }
    }
}

struct SavedTriviaItemView_Previews: PreviewProvider {
    static var previews: some View {
        SavedTriviaItemView(filteredOn: "")
        // pull from database
            .environment(\.blackbirdDatabase, AppDatabase.instance)
    }
}
