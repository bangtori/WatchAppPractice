//
//  TodoStore.swift
//  WatchFocus
//
//  Created by 방유빈 on 2024/02/13.
//

import Foundation

class TodoStore: ObservableObject {
    @Published var todos: [Todo] = [] {
        didSet {
            saveTodo()
        }
    }
    var progress: Double {
        if todos.count == 0 { return 0.0 }
        let checkCount = todos.filter{ $0.isChecked }.count
        return Double(checkCount) / Double(todos.count)
    }
    
    init() {}
    
    func checkTodo(todoId: String) {
        guard let index = todos.firstIndex(where: {$0.id == todoId }) else { return }
        todos[index].checkTodo()
    }
    
    func loadTodo() {
        let decoder:JSONDecoder = JSONDecoder()
        if let data = UserDefaults.standard.object(forKey: "todo") as? Data{
            if let saveData = try? decoder.decode([Todo].self, from: data){
                todos = saveData
            }
        } 
    }
    
    func addTodo(todo: Todo) {
        todos.append(todo)
    }
    
    func deleteTodo(todoId: String) {
        guard let index = todos.firstIndex(where: {$0.id == todoId }) else { return }
        todos.remove(at: index)
    }
    
    private func saveTodo(){
        let encoder:JSONEncoder = JSONEncoder()
        if let encoded = try? encoder.encode(todos){
            UserDefaults.standard.set(encoded, forKey: "todo")
        }
    }
}
