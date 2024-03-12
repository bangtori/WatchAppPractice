//
//  TodoStore.swift
//  WatchFocus
//
//  Created by 방유빈 on 2024/02/13.
//

import Foundation
import WatchConnectivity
import WidgetKit

class TodoStore: NSObject, WCSessionDelegate, ObservableObject {
    @Published var todos: [Todo] = [] {
        didSet {
            saveTodo()
            WidgetCenter.shared.reloadAllTimelines()
        }
    }
    
    @Published var categorys: [Category] = [] {
        didSet {
            saveCategorys()
        }
    }
    
    var session: WCSession
    var progress: Double {
        if todos.count == 0 { return 0.0 }
        let checkCount = todos.filter{ $0.isChecked }.count
        return Double(checkCount) / Double(todos.count)
    }
    
    init(session: WCSession = .default) {
        self.session = session
        super.init()
        session.delegate = self
        session.activate()
    }
    
    func checkTodo(todoId: String) {
        guard let index = todos.firstIndex(where: {$0.id == todoId }) else { return }
        todos[index].checkTodo()
        sendToWatch()
    }
    
    func loadCategory() {
        let decoder:JSONDecoder = JSONDecoder()
        if let data = UserDefaults.groupShared.object(forKey: UserDefaultsKeys.categorys.rawValue) as? Data{
            if let saveData = try? decoder.decode([Category].self, from: data){
                categorys = saveData
            }
        }
    }
    
    func loadTodo() {
        let decoder:JSONDecoder = JSONDecoder()
        if let data = UserDefaults.groupShared.object(forKey: UserDefaultsKeys.todo.rawValue) as? Data{
            if let saveData = try? decoder.decode([Todo].self, from: data){
                todos = saveData
            }
        }
        sendToWatch()
    }
    
    func addCategorys(category: Category) {
        categorys.append(category)
    }
    
    func addTodo(todo: Todo) {
        todos.append(todo)
        sendToWatch()
    }
    
    func deleteCategory(categoryId: String) {
        guard let index = categorys.firstIndex(where: {$0.id == categoryId }) else { return }
        categorys.remove(at: index)
    }
    
    func deleteTodo(todoId: String) {
        guard let index = todos.firstIndex(where: {$0.id == todoId }) else { return }
        todos.remove(at: index)
        sendToWatch()
    }
    
    func deleteAllTodo() {
        todos = []
        sendToWatch()
    }
    
    private func saveTodo(){
        let encoder:JSONEncoder = JSONEncoder()
        if let encoded = try? encoder.encode(todos){
            UserDefaults.groupShared.set(encoded, forKey: UserDefaultsKeys.todo.rawValue)
        }
    }
    
    private func saveCategorys() {
        let encoder:JSONEncoder = JSONEncoder()
        if let encoded = try? encoder.encode(categorys){
            UserDefaults.groupShared.set(encoded, forKey: UserDefaultsKeys.categorys.rawValue)
        }
    }
    
    private func sendToWatch() {
        let encoder:JSONEncoder = JSONEncoder()
        if let encoded = try? encoder.encode(todos){
            session.sendMessageData(encoded, replyHandler: nil) { error in
                print("ios -> Watch send Error: \(error.localizedDescription)")
            }
        }
    }
    
    func session(_ session: WCSession, didReceiveMessageData messageData: Data) {
        let decoder:JSONDecoder = JSONDecoder()
        
        if let saveData = try? decoder.decode([Todo].self, from: messageData){
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                todos = saveData
            }
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
    }
}
