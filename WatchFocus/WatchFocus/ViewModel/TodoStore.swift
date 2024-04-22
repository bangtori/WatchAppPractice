//
//  TodoStore.swift
//  WatchFocus
//
//  Created by 방유빈 on 2024/02/13.
//

import Foundation
import WatchConnectivity
import WidgetKit
import RealmSwift

class TodoStore: NSObject, WCSessionDelegate, ObservableObject {
    @ObservedResults(TodoObject.self) var todoObjects
    @Published var todos: [Todo] = [] {
        didSet {
            sendToWatch()
            WidgetCenter.shared.reloadAllTimelines()
        }
    }
    
    @Published var categorys: [Category] = [] {
        didSet {
            saveCategorys()
        }
    }
    
    private var token: NotificationToken?
    
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
        setupObserver()
    }
    
    deinit {
        token?.invalidate()
    }
    
    private func setupObserver() {
        do {
            let realm = try Realm(configuration: returnRealmConfig())
            let results = realm.objects(TodoObject.self)
            
            token = results.observe({ [weak self] changes in
                self?.todos = results.map(Todo.init)
                    .sorted(by: { $0.createDate < $1.createDate })
            })
        } catch let error {
            print("옵저버 셋팅 실패")
            print(error.localizedDescription)
        }
    }
    
    private func returnRealmConfig() -> Realm.Configuration {
        let container = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.watchFocus")
        let realmURL = container?.appendingPathComponent("default.realm")
        let config = Realm.Configuration(fileURL: realmURL, schemaVersion: 1)
        return config
    }
    
    func getCategoryProgress(_ categoryId: String) -> Double {
        let categoryTodos = todos.filter{ $0.category?.id == categoryId }
        if categoryTodos.count == 0 { return 0.0 }
        let checkCount = categoryTodos.filter{ $0.isChecked }.count
        return Double(checkCount) / Double(categoryTodos.count)
    }
    
    func checkTodo(todoId: String) {
        do {
            let realm = try Realm(configuration: returnRealmConfig())
            let objectId = try ObjectId(string: todoId)
            let todo = realm.object(ofType: TodoObject.self, forPrimaryKey: objectId)
            if let todo = todo {
                try realm.write {
                    todo.isChecked.toggle()
                    realm.add(todo, update: .modified)
                }
            }
        } catch {
            print("업데이트 실패(할일 체크 실패): \(error.localizedDescription)")
        }
    }
    
    func loadCategory() {
        let decoder:JSONDecoder = JSONDecoder()
        if let data = UserDefaults.groupShared.object(forKey: UserDefaultsKeys.categorys.rawValue) as? Data{
            if let saveData = try? decoder.decode([Category].self, from: data){
                categorys = saveData
            }
        }
    }
    
    
    func addCategorys(category: Category) {
        categorys.append(category)
    }
    
    func addTodo(todo: TodoObject) {
        $todoObjects.append(todo)
    }
    
    func deleteCategory(categoryId: String) {
        guard let index = categorys.firstIndex(where: {$0.id == categoryId }) else { return }
        do {
            let realm = try Realm(configuration: returnRealmConfig())
            let deleteCategoryTodos = realm.objects(TodoObject.self).where {
                $0.categoryId.equals(categoryId)
            }
            try realm.write {
                deleteCategoryTodos.forEach {
                    $0.categoryId = nil
                }
                realm.add(deleteCategoryTodos, update: .modified)
            }
        } catch {
            print("해당 카테고리 todo 초기화 실패 : \(error.localizedDescription)")
        }
        categorys.remove(at: index)
    }
    
    func deleteTodo(todoId: String) {
        do {
            let realm = try Realm(configuration: returnRealmConfig())
            let objectId = try ObjectId(string: todoId)
            if let todo = realm.object(ofType: TodoObject.self, forPrimaryKey: objectId) {
                try realm.write {
                    realm.delete(todo)
                }
            }
        } catch {
            print("데이터 삭제 실패 : \(error)")
        }
    }
    
    func deleteAllTodo(isCheck: Bool) {
        if isCheck {
            do {
                let realm = try Realm(configuration: returnRealmConfig())
                let deleteTodos = realm.objects(TodoObject.self).where {
                    $0.isChecked
                }
                try realm.write {
                    realm.delete(deleteTodos)
                }
            } catch {
                print("체크 데이터 전체 삭제 실패 : \(error.localizedDescription)")
            }
        } else {
            do {
                let realm = try Realm(configuration: returnRealmConfig())
                try realm.write {
                    realm.deleteAll()
                }
            } catch {
                print("데이터 전체 삭제 실패 : \(error.localizedDescription)")
            }
        }
    }
    
    func deleteCategoryTodo(categoryId: String, isCheck: Bool) {
        if isCheck {
            do {
                let realm = try Realm(configuration: returnRealmConfig())
                let deleteTodos = todoObjects.filter {
                    $0.categoryId == categoryId && $0.isChecked
                }
                try realm.write {
                    realm.delete(deleteTodos)
                }
            } catch {
                print("카테고리 선택 데이터 삭제 실패 : \(error.localizedDescription)")
            }
        } else {
            do {
                let realm = try Realm(configuration: returnRealmConfig())
                let deleteTodos = todoObjects.filter {
                    $0.categoryId == categoryId
                }
                try realm.write {
                    realm.delete(deleteTodos)
                }
            } catch {
                print("카테고리 데이터 전체 삭제 실패 : \(error.localizedDescription)")
            }
        }
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
