//
//  ScoresModel.swift
//  SwiftP4_1
//
//  Created by c092 DIT UPM on 22/11/23.
//

import Foundation

@Observable class ScoresModel {
    
    var acertadas: Set<Int> = []

    var record: Set<Int> = []
    
    init () {
        
        let a = UserDefaults.standard.object(forKey: "record") as? [Int] ?? []
        
        record = Set(a)
    }
    
    func check(quizItem: QuizItem, answer: String){
        //ESTO YA NO SE USA
        //if answer =+-= quizItem.answer {
          //  acertadas.insert(quizItem.id)
        //}
    }
    
    func add(quizItem: QuizItem) {
        acertadas.insert(quizItem.id)
        record.insert(quizItem.id)
        
        UserDefaults.standard.set(Array(record), forKey: "record")
        UserDefaults.standard.synchronize()
    }
    
    func cleanup() {
        acertadas = []
    }
    //Funcion para filtrar
    func pendiente(quizItem: QuizItem) -> Bool {
        !acertadas.contains(quizItem.id)
    }
    

}
