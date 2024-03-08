//
//  TodoView.swift
//  WatchFocus
//
//  Created by 방유빈 on 2024/02/13.
//

import SwiftUI

struct TodoView: View {
    @Environment(\.colorScheme) var scheme
    @EnvironmentObject private var todoStore: TodoStore
    @State private var isShowingAddView: Bool = false
    @State private var isShowingAlert: Bool = false
    
    var body: some View {
        ZStack(alignment: .bottomTrailing){
            List{
                Section("Achieve") {
                    WfProgressBar(progress: todoStore.progress)
                }
                .listRowSeparator(.hidden)
                .listRowBackground(WfColor.wfbackgroundColor.returnColor(scheme: scheme))
                Section {
                    ForEach(todoStore.todos) { todo in
                        TodoRowView(todo: todo)
                            .padding(.vertical, 10)
                            .listRowSeparator(.hidden)
                            .listSectionSeparator(.hidden, edges: .all)
                            .listRowBackground(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color(hex: "#6A6A6A"),style: StrokeStyle(lineWidth: scheme == .light ? 0 : 2))
                                    .fill(WfColor.wfRowBackgroundColor.returnColor(scheme: scheme))
                                    .background(.clear)
                                    .padding(
                                        EdgeInsets(
                                            top: 10,
                                            leading: 10,
                                            bottom: 10,
                                            trailing: 10
                                        )
                                    )
                                    .shadow(color: scheme == .light ? Color(hex: "F0F3FF") : Color(hex: "F0F3FF", opacity: 0), radius: 5, x: 5, y: 4)
                            )
                    }
                } header: {
                    HStack {
                        Text("Task")
                        Spacer()
                        Button {
                            isShowingAlert.toggle()
                        } label: {
                            Text("All Remove")
                                .foregroundStyle(WfColor.wfAlphaBlue.returnColor(scheme: scheme))
                        }
                    }
                }
            }
            Button {
                isShowingAddView.toggle()
            } label: {
                Image(systemName: "plus.circle.fill")
                    .foregroundStyle(WfColor.wfMainPurple.returnColor(scheme: scheme))
                    .background(WfColor.wfbackgroundColor.returnColor(scheme: scheme))
                    .font(Font.system(size: 50))
                    .clipShape(Circle())
                    .padding()
            }
        }
        .listStyle(.plain)
        .navigationTitle("Todos")
        .scrollContentBackground(.hidden)
        .background(WfColor.wfbackgroundColor.returnColor(scheme: scheme), ignoresSafeAreaEdges: .all)
        .sheet(isPresented: $isShowingAddView) {
            TodoAddView()
                .presentationDetents([.medium])
        }
        .onAppear {
            DispatchQueue.global().async {
                todoStore.loadTodo()
            }
        }
        .alert("Todo 전체 삭제", isPresented: $isShowingAlert) {
            Button("취소", role: .none) {}
            Button("삭제", role: .none) {
                todoStore.deleteAllTodo()
            }
        }message: {
            Text("작성한 할 일을 저장합니다.")
        }
    }
}

#Preview {
    NavigationStack{
        TodoView()
    }
    .environmentObject(TodoStore())
}

