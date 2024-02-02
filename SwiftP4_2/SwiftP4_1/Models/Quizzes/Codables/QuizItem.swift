//
//  QuizItem.swift
//  P4.1 Quiz
//
//  Created by Santiago Pavón Gómez on 11/9/23.
//

import Foundation
//borrar answer
struct QuizItem: Codable, Identifiable {
    let id: Int
    let question: String
    let author: Author?
    let attachment: Attachment?
    var favourite: Bool //Para modificar es necesario que sea "VAR"
    
    struct Author: Codable {
        let isAdmin: Bool?
        let username: String?
        let profileName: String?
        let photo: Attachment?
    }
    
    struct Attachment: Codable {
        let filename: String?
        let mime: String?
        let url: URL?
    }
}

extension QuizItem {
    static let qip = QuizItem(id: 1,
                              question: "Sample question",
                              author: QuizItem.Author(isAdmin: true,
                              username: "Ana",
                              profileName: nil,
                              photo: nil),
                              attachment: nil,
                              favourite: false)
    
}
