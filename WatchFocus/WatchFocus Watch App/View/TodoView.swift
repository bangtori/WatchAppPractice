//
//  TodoView.swift
//  WatchFocus Watch App
//
//  Created by 방유빈 on 2024/02/20.
//

import SwiftUI

struct TodoView: View {
    @EnvironmentObject private var todoStore: TodoStore
    
    var body: some View {
        List {
            ForEach(todoStore.todos) { todo in
                TodoRowView(todo: todo)
            }
        }
        .navigationTitle("Todo")
    }
}

#Preview {
    NavigationStack {
        TodoView()
    }
    .environmentObject(TodoStore())
}
