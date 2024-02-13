//
//  TodoView.swift
//  WatchFocus
//
//  Created by 방유빈 on 2024/02/13.
//

import SwiftUI

struct TodoView: View {
    @EnvironmentObject private var todoStore: TodoStore
    var body: some View {
        List{
            Section("Achieve") {
                WfProgressBar(progress: todoStore.progress)
                
            }
            .listRowSeparator(.hidden)
            .listRowBackground(Color.wfBackgroundGray)
            Section("Task") {
                ForEach(todoStore.todos) { todo in
                    TodoRowView(todo: todo)
                        .padding(.vertical, 10)
                        .listRowSeparator(.hidden)
                        .listSectionSeparator(.hidden, edges: .all)
                        .listRowBackground(
                            RoundedRectangle(cornerRadius: 15)
                                .background(.clear)
                                .foregroundColor(.white)
                                .padding(
                                    EdgeInsets(
                                        top: 10,
                                        leading: 10,
                                        bottom: 10,
                                        trailing: 10
                                    )
                                )
                                .shadow(color: Color(hex: "F0F3FF"), radius: 5, x: 5, y: 4)
                        )
                }
            }
        }
        .listStyle(.plain)
        .navigationTitle("Todos")
        .scrollContentBackground(.hidden)
        .background(Color.wfBackgroundGray, ignoresSafeAreaEdges: .all)
    }
}

#Preview {
    NavigationStack{
        TodoView()
    }
    .environmentObject(TodoStore())
}

struct WfProgressBar: View {
    var progress: Double
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading) {
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: geometry.size.width, height: 10)
                        .foregroundStyle(Color.wfLightGray)
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: min(CGFloat(self.progress) * geometry.size.width, geometry.size.width), height: 10)
                        .foregroundStyle(Color.wfMainBlue)
                }
                Text("\(progress.toPercent())%")
                    .font(.wfCalloutFont)
                    .foregroundStyle(Color.wfLightGray)
                    .offset(x: progress == 0 ? 0 : min(CGFloat(self.progress) * geometry.size.width, geometry.size.width) - 15, y: 0)
            }
        }
    }
}

