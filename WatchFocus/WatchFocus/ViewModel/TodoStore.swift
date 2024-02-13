//
//  TodoStore.swift
//  WatchFocus
//
//  Created by 방유빈 on 2024/02/13.
//

import Foundation

class TodoStore: ObservableObject {
    @Published var todos: [Todo] = []
    var progress: Double {
        let checkCount = todos.filter{ $0.isChecked }.count
        return Double(checkCount) / Double(todos.count)
    }
    
    init() {
        let todos: [Todo] = [
            Todo(title: "1111", deadline: nil, createDate: Date().timeIntervalSince1970, isChecked: false),
            Todo(title: "222", deadline: nil, createDate: Date().timeIntervalSince1970, isChecked: false),
            Todo(title: "33333", deadline: nil, createDate: Date().timeIntervalSince1970, isChecked: false),
            Todo(title: "44444", deadline: Date().timeIntervalSince1970, createDate: Date().timeIntervalSince1970, isChecked: false)
        ]
        self.todos = todos
    }
    
    func checkTodo(todoId: String) {
        guard let index = todos.firstIndex(where: {$0.id == todoId }) else { return }
        todos[index].checkTodo()
    }
    func loadTodo() {
        
    }
    
    func addTodo(todo: Todo) {
        todos.append(todo)
    }
    
    func deleteTodo(todoId: String) {
        guard let index = todos.firstIndex(where: {$0.id == todoId }) else { return }
        todos.remove(at: index)
    }
}
