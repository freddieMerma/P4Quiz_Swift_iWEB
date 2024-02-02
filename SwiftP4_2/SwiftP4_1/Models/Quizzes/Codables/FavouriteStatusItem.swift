//
//  FavouriteStatusItem.swift
//  SwiftP4_1
//
//  Created by c092 DIT UPM on 14/12/23.
//

import Foundation

struct FavouriteStatusItem: Codable {
    //Diferenciar: "quizId" - "id"
    let id: Int
    var favourite: Bool
}
