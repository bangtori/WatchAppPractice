//
//  ToDo.swift
//  WatchFocus
//
//  Created by 방유빈 on 2024/02/13.
//

import SwiftUI
import RealmSwift

struct Todo: Identifiable, Codable {
    var id = UUID().uuidString
    let title: String
    let deadline: Double?
    let createDate : Double
    var isChecked: Bool
    var category: Category?
    
    init(id: String = UUID().uuidString, title: String, deadline: Double? = nil, createDate: Double = Date().timeIntervalSince1970, isChecked: Bool, category: Category? = nil) {
        self.id = id
        self.title = title
        self.deadline = deadline
        self.createDate = createDate
        self.isChecked = isChecked
        self.category = category
    }
    
    #if os(iOS)
    init(todoObj: TodoObject) {
        self.id = todoObj.id.stringValue
        self.title = todoObj.title
        self.deadline = todoObj.deadline
        self.createDate = todoObj.createDate
        self.isChecked = todoObj.isChecked
        self.category = idToCategory(withId: todoObj.categoryId)
        
    }
    
    func idToCategory(withId id: String?) -> Category? {
        let decoder:JSONDecoder = JSONDecoder()
        if let data = UserDefaults.groupShared.object(forKey: UserDefaultsKeys.categorys.rawValue) as? Data{
            if let categories = try? decoder.decode([Category].self, from: data){
                return categories.first { $0.id == id }
            }
        }
        
        return nil
    }
    #endif
    
    mutating func checkTodo(){
        isChecked = !self.isChecked
    }
}

struct Category: Identifiable, Codable {
    var id = UUID().uuidString
    let name: String
    let color: CategoryColorCode
    
    init(id: String = UUID().uuidString, name: String, color: CategoryColorCode) {
        self.id = id
        self.name = name
        self.color = color
    }
}

enum CategoryColorCode: String, Codable, CaseIterable, PersistableEnum {
    case blue
    case purple
    case yellow
    case green
    case red
}

class TodoObject: Object, Identifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var title: String
    @Persisted var deadline: Double?
    @Persisted var createDate : Double
    @Persisted var isChecked: Bool
    @Persisted var categoryId: String?
    
}

//class CategoryObject: Object, Identifiable {
//    @Persisted(primaryKey: true) var id: String
//    @Persisted var name: String
//    @Persisted var color: CategoryColorCode
//    
//    convenience init(id: String = UUID().uuidString, name: String, color: CategoryColorCode) {
//        self.init()
//        self.name = name
//        self.color = color
//    }
//}
