//
//  TodoStore.swift
//  WatchFocus Watch App
//
//  Created by 방유빈 on 2024/02/20.
//

import Foundation
import WatchConnectivity

final class TodoStore: NSObject, WCSessionDelegate, ObservableObject {
    @Published var todos: [Todo] = []
    
    var session: WCSession
    init(session: WCSession = .default) {
        self.session = session
        super.init()
        session.delegate = self
        session.activate()
    }
    
    func checkTodo(todoId: String) {
        guard let index = todos.firstIndex(where: {$0.id == todoId }) else { return }
        todos[index].checkTodo()
        sendToIPhone()
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
    
    private func sendToIPhone() {
        let encoder:JSONEncoder = JSONEncoder()
        if let encoded = try? encoder.encode(todos){
            session.sendMessageData(encoded, replyHandler: nil) { error in
                print("ios -> Watch send Error: \(error.localizedDescription)")
            }
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    }
    
}
