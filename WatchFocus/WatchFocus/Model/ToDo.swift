//
//  ToDo.swift
//  WatchFocus
//
//  Created by 방유빈 on 2024/02/13.
//

import Foundation

struct Todo:Identifiable, Codable{
    var id = UUID().uuidString
    let title: String
    let deadline: Double?
    let createDate : Double
    var isChecked: Bool
    
    mutating func checkTodo(){
        isChecked = !self.isChecked
    }
}
