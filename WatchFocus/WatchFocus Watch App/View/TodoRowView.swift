//
//  TodoRowView.swift
//  WatchFocus
//
//  Created by 방유빈 on 2024/02/20.
//

import SwiftUI

struct TodoRowView: View {
    @EnvironmentObject private var todoStore: TodoStore
    var todo: Todo
    var body: some View {
        HStack{
            Button {
                todoStore.checkTodo(todoId: todo.id)
            } label: {
                todo.isChecked ? Image(systemName: "checkmark.circle.fill") :
                Image(systemName: "circle")
            }
            .buttonStyle(.plain)
            .font(Font.system(size: 30))
            .foregroundStyle(todo.category?.color.getColor() ?? .white)
            .padding(.trailing)
            
            VStack(alignment: .leading) {
                if todo.isChecked {
                    Text(todo.title)
                        .font(.wfTitleFont)
                        .foregroundStyle(Color.wfGray)
                        .strikethrough()
                } else {
                    Text(todo.title)
                        .font(.wfTitleFont)
                        .foregroundStyle(Color.white)
                }
                if let deadline = todo.deadline {
                    Text(deadline.toStringDeadLine())
                        .font(.wfCalloutFont)
                        .foregroundStyle(Color.wfGray)
                }
            }
            Spacer()
        }
        .padding(10)
    }
}

#Preview {
    TodoRowView(todo: Todo(title: "ss", deadline: Date().timeIntervalSince1970, createDate: Date().timeIntervalSince1970, isChecked: false))
        .environmentObject(TodoStore())
}

extension CategoryColorCode {
    func getColor() -> Color {
        switch self {
        case .blue:
            return .wfMainBlue
        case .purple:
            return .wfMainPurple
        case .yellow:
            return .wfCategoryYellow
        case .green:
            return .wfCategoryGreen
        case .red:
            return .wfCategoryRed
        }
    }
}
