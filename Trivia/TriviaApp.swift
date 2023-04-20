//
//  TriviaApp.swift
//  Trivia
//
//  Created by Graeme Armstrong on 2023-04-19.
//

import Blackbird
import SwiftUI

@main
struct TriviaApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                TriviaView()
                    .tabItem{
                        Label("Trivia", systemImage: "dice")
                    }
                
                SavedTrivia()
                    .tabItem{
                        Label("Saved", systemImage: "square.and.arrow.down")
                    }
            }
            .environment(\.blackbirdDatabase, AppDatabase.instance)
        }
    }
}
