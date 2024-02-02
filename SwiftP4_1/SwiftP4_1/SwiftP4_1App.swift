//
//  SwiftP4_1App.swift
//  SwiftP4_1
//
//  Created by c092 DIT UPM on 21/11/23.
//

import SwiftUI

@main
struct SwiftP4_1App: App {
    
    @State var quizzesModel = QuizzesModel()
    @State var scoresModel = ScoresModel()
    
    var body: some Scene {
        WindowGroup {
            QuizzesListView()
                .environment(quizzesModel)
                .environment(scoresModel)
        }
    }
}
