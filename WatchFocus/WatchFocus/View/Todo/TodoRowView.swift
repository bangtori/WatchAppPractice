//
//  TodoRowView.swift
//  WatchFocus
//
//  Created by 방유빈 on 2024/02/13.
//

import SwiftUI
import DYColor

struct TodoRowView: View {
    @Environment(\.colorScheme) var scheme
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
            .foregroundStyle(todo.category?.color.getDYColor.dynamicColor ?? DYColor.wfBlackWhite.dynamicColor)
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
                }
                if let deadline = todo.deadline {
                    Text(deadline.toStringDeadLine())
                        .font(.wfCalloutFont)
                        .foregroundStyle(Color.wfGray)
                }
            }
            Spacer()
            Button {
                todoStore.deleteTodo(todoId: todo.id)
            } label: {
                Image(systemName: "xmark")
            }
            .buttonStyle(.plain)
            .font(Font.system(size: 15))
            .tint(.black)
        }
        .padding(10)
    }
}

#Preview {
    TodoRowView(todo: Todo(title: "ss", deadline: Date().timeIntervalSince1970, createDate: Date().timeIntervalSince1970, isChecked: true))
        .environmentObject(TodoStore())
}
