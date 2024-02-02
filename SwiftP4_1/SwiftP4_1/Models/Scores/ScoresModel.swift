//
//  ScoresModel.swift
//  SwiftP4_1
//
//  Created by c092 DIT UPM on 22/11/23.
//

import Foundation

@Observable class ScoresModel {
    
    var acertadas: Set<Int> = []
    
    func check(quizItem: QuizItem, answer: String){
        
        if answer =+-= quizItem.answer {
            acertadas.insert(quizItem.id)
        }
    }
    
}
