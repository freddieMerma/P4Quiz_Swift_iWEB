//
//  Endpoints.swift
//  SwiftP4_1
//
//  Created by c092 DIT UPM on 12/12/23.
//

import Foundation

let urlBase = "https://quiz.dit.upm.es"
let token = "XXXXXXXXXXXXXXXXXXXX"

struct Endpoints {

    static func random10() -> URL? {
        let path = "/api/quizzes/random10"
        let str = "\(urlBase)\(path)?token=\(token)"
        return URL(string: str)
    }

    //Importante definir quizItem.. entre ()
    static func checkAnswer(quizItem: QuizItem, answer: String) -> URL? {
        let path = "/api/quizzes/\(quizItem.id)/check"

        guard let escapedAnswer = answer.addingPercentEncoding(withAllowedCharacters:
                .urlQueryAllowed) else { return nil }
        let str = "\(urlBase)\(path)?answer=\(escapedAnswer)&token=\(token)"
        return URL(string: str)
    }

    static func toggleFav(quizItem: QuizItem) -> URL? {
        let path = "/api/users/tokenOwner/favourites/\(quizItem.id)"
        let str = "\(urlBase)\(path)?token=\(token)"
        return URL(string: str)
      }

    static func verRes(quizItem: QuizItem, answer: String) -> URL? {
        let path = "/api/quizzes/\(quizItem.id)/answer"
        let str = "\(urlBase)\(path)?token=\(token)"
        return URL(string: str)
      }

}
