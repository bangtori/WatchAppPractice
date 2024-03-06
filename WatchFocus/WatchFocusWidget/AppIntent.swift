//
//  AppIntent.swift
//  WatchFocusWidget
//
//  Created by 방유빈 on 2024/02/28.
//

import WidgetKit
import AppIntents

struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Configuration"
    static var description = IntentDescription("This is an example widget.")

    // An example configurable parameter.
    // MARK: - 나중에 카테고리 추가 후 카테고리 리스트 넣기
    @Parameter(title: "Favorite Emoji", default: "😃")
    var favoriteEmoji: String
    
}

struct CheckTodoIntent: AppIntent {
    
    static var title: LocalizedStringResource = "Check Todo"
    
    @Parameter(title: "Todo Id")
    var todoId: String
    
    init(todoId: String) {
        self.todoId = todoId
    }
    init() {}
    func perform() async throws -> some IntentResult {
        
        let decoder:JSONDecoder = JSONDecoder()
        if let data = UserDefaults.groupShared.object(forKey: UserDefaultsKeys.todo.rawValue) as? Data{
            if let saveData = try? decoder.decode([Todo].self, from: data){
                var tempTodos = saveData
                guard let index = saveData.firstIndex(where: {$0.id == todoId }) else {
                    return .result()
                }
                tempTodos[index].checkTodo()
                let encoder:JSONEncoder = JSONEncoder()
                if let encoded = try? encoder.encode(tempTodos){
                    UserDefaults.groupShared.set(encoded, forKey: UserDefaultsKeys.todo.rawValue)
                }
            }
        }
        return .result()
    }
}
