//
//  CheckResponseItem.swift
//  SwiftP4_1
//
//  Created by c092 DIT UPM on 14/12/23.
//

import Foundation

struct CheckResponseItem: Codable {
    let quizId: Int
    let answer: String
    let result: Bool
}
