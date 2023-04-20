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
            TriviaView()
                .environment(\.blackbirdDatabase, AppDatabase.instance)
        }
    }
}
