//
//  TodoView.swift
//  WatchFocus
//
//  Created by 방유빈 on 2024/02/13.
//

import SwiftUI

struct TodoView: View {
    @EnvironmentObject private var todoStore: TodoStore
    @State private var isShowingAddView: Bool = false
    var body: some View {
        ZStack(alignment: .bottomTrailing){
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
            Button {
                isShowingAddView.toggle()
            } label: {
                Image(systemName: "plus.circle.fill")
                    .foregroundColor(.wfMainPurple)
                    .background(.white)
                    .font(Font.system(size: 50))
                    .clipShape(Circle())
                    .padding()
            }
        }
        .listStyle(.plain)
        .navigationTitle("Todos")
        .scrollContentBackground(.hidden)
        .background(Color.wfBackgroundGray, ignoresSafeAreaEdges: .all)
        .sheet(isPresented: $isShowingAddView) {
            TodoAddView()
                .presentationDetents([.medium])
        }
        .onAppear {
            DispatchQueue.global().async {
                todoStore.loadTodo()
            }
        }
    }
}

#Preview {
    NavigationStack{
        TodoView()
    }
    .environmentObject(TodoStore())
}

