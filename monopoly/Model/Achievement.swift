//
//  Achievement.swift
//  monopoly
//
//  Created by Lê Ngọc Trâm on 05/09/2023.
//

import Foundation

/// Defines Achievement  struct
struct Achievement: Codable, Hashable, Identifiable, Equatable{
    var id: Int
    var title: String
    var tag: String
    var tagVar: Int
    var completed: Bool
}


let testAchievemnt = Achievement(id: -1, title: "hello", tag: "hello", tagVar: 0, completed: false)


