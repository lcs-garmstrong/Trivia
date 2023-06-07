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
    
    // use to talk to DB
    @Environment(\.blackbirdDatabase) var db: Blackbird.Database?
    
    var body: some View {
        NavigationView{
            VStack{
                
                Text("Search Category")
                
                SavedTriviaItemView(filteredOn: searchText)
                    .searchable(text: $searchText)
            }
            .navigationTitle("Saved Trivia:")
        }
    }
    
}


struct SavedTrivia_Previews: PreviewProvider {
    static var previews: some View {
        SavedTrivia()
            .environment(\.blackbirdDatabase, AppDatabase.instance)
    }
}
