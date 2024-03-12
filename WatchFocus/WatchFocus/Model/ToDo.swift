//
//  ToDo.swift
//  WatchFocus
//
//  Created by 방유빈 on 2024/02/13.
//

import SwiftUI

struct Todo: Identifiable, Codable {
    var id = UUID().uuidString
    let title: String
    let deadline: Double?
    let createDate : Double
    var isChecked: Bool
//    var category: Category?
    
    mutating func checkTodo(){
        isChecked = !self.isChecked
    }
}

struct Category: Identifiable, Codable {
    var id = UUID().uuidString
    let name: String
    let color: CategoryColorCode
}

enum CategoryColorCode: String, Codable, CaseIterable{
    case blue
    case purple
    case yellow
    case green
    case red
}
