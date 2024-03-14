//
//  TodoView.swift
//  WatchFocus
//
//  Created by 방유빈 on 2024/02/13.
//

import SwiftUI
import DYColor

struct TodoView: View {
    enum AlertType {
        case allTask
        case currentCategoryAllTask
        case allCategoryCheckTask
        case currentCategoryCheckTask
    }
    @Environment(\.colorScheme) var scheme
    @EnvironmentObject private var todoStore: TodoStore
    @State private var isShowingAddView: Bool = false
    @State private var isShowingShareView: Bool = false
    @State private var isShowingAlert: Bool = false
    @State private var selectedCategory: Category? = nil
    @State private var alertType: AlertType = .allCategoryCheckTask
    var body: some View {
        ZStack(alignment: .bottomTrailing){
            List{
                Section("Achieve") {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("All")
                                    .font(.wfTitleFont)
                                WfProgressBar(progress: todoStore.progress, progressColor: DYColor.wfMainBlue)
                            }
                            .padding()
                            .background(
                                RowBackgroundView()
                            )
                            .frame(width: UIScreen.main.bounds.width * 0.4)
                            ForEach(todoStore.categorys) { category in
                                VStack(alignment: .leading) {
                                    Text(category.name)
                                        .font(.wfTitleFont)
                                    WfProgressBar(progress: todoStore.getCategoryProgress(category.id), progressColor: category.color.getDYColor)
                                }
                                .padding()
                                .background(
                                    RowBackgroundView()
                                )
                                .frame(width: UIScreen.main.bounds.width * 0.4)
                            }
                        }
                    }
                }
                .listRowSeparator(.hidden)
                .listRowBackground(DYColor.wfbackgroundColor.dynamicColor)
                Section("Task") {
                    ScrollView {
                        HStack {
                            Button {
                                selectedCategory = nil
                            } label: {
                                Text("All")
                                    .foregroundStyle(selectedCategory == nil ? DYColor.wfBlackWhite.dynamicColor : DYColor.wfUnableCategory.dynamicColor)
                            }
                            Text("|")
                            ForEach(todoStore.categorys) { category in
                                Button {
                                    selectedCategory = category
                                } label: {
                                    Text(category.name)
                                        .foregroundStyle(selectedCategory?.id == category.id ? category.color.getDYColor.dynamicColor : DYColor.wfUnableCategory.dynamicColor)
                                }
                            }
                        }
                    }
                    .listRowBackground(DYColor.wfbackgroundColor.dynamicColor)
                    .padding(.top, 5)
                    .listRowSeparator(.hidden)
                    .font(.wfBody1Font)
                    .bold()
                    ForEach(todoStore.todos.filter{
                        if let category = selectedCategory {
                            return $0.category?.id == category.id
                        } else {
                            return true
                        }
                    }) { todo in
                        TodoRowView(todo: todo)
                            .padding(.vertical, 10)
                            .listRowSeparator(.hidden)
                            .listSectionSeparator(.hidden, edges: .all)
                            .listRowBackground(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color.wfGray4,style: StrokeStyle(lineWidth: scheme == .light ? 0 : 2))
                                    .fill(DYColor.wfRowBackgroundColor.dynamicColor)
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
                }
            }
            Button {
                isShowingAddView.toggle()
            } label: {
                Image(systemName: "plus.circle.fill")
                    .foregroundStyle(DYColor.wfMainBlue.dynamicColor)
                    .background(DYColor.wfbackgroundColor.dynamicColor)
                    .font(Font.system(size: 50))
                    .clipShape(Circle())
                    .padding()
            }
        }
        .listStyle(.plain)
        .navigationTitle("Todos")
        .scrollContentBackground(.hidden)
        .background(DYColor.wfbackgroundColor.dynamicColor, ignoresSafeAreaEdges: .all)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button{
                    isShowingShareView.toggle()
                }label: {
                    Image(systemName: "square.and.arrow.up")
                        .foregroundStyle(DYColor.wfTextDarkGray.dynamicColor)
                }
            }
            
            ToolbarItem(placement: .topBarLeading) {
                Menu {
                    Button("전체 할 일 삭제(All Category)") {
                        alertType = .allTask
                        isShowingAlert.toggle()
                    }
                    Button("체크된 할 일 삭제(All Category)") {
                        alertType = .allCategoryCheckTask
                        isShowingAlert.toggle()
                    }
                    Button("전체 할 일 삭제(Current Category)") {
                        alertType = .currentCategoryAllTask
                        isShowingAlert.toggle()
                    }
                    Button("체크된 할 일 삭제(Current Category)") {
                        alertType = .currentCategoryCheckTask
                        isShowingAlert.toggle()
                    }
                } label: {
                    Image(systemName: "trash")
                        .foregroundStyle(DYColor.wfTextDarkGray.dynamicColor)
                }
            }
        }
        .sheet(isPresented: $isShowingAddView) {
            TodoAddView()
        }
        .navigationDestination(isPresented: $isShowingShareView) {
            ShareView()
        }
        .onAppear {
            todoStore.loadTodo()
            todoStore.loadCategory()
        }
        .alert("할 일 삭제", isPresented: $isShowingAlert) {
            Button("취소", role: .none) {}
            Button("삭제", role: .none) {
                switch alertType {
                case .allTask:
                    todoStore.deleteAllTodo(isCheck: false)
                case .currentCategoryAllTask:
                    guard let category = selectedCategory else { return }
                    todoStore.deleteCategoryTodo(categoryId: category.id, isCheck: false)
                case .allCategoryCheckTask:
                    todoStore.deleteAllTodo(isCheck: true)
                case .currentCategoryCheckTask:
                    guard let category = selectedCategory else { return }
                    todoStore.deleteCategoryTodo(categoryId: category.id, isCheck: true)
                }
            }
        }message: {
            alertType.messageText
        }
    }
}

#Preview {
    NavigationStack{
        TodoView()
    }
    .environmentObject(TodoStore())
}

extension TodoView.AlertType {
    var messageText: Text {
        switch self {
        case .allTask:
            Text("저장된 모든 할 일을 삭제합니다.")
        case .currentCategoryAllTask:
            Text("현재 선택된 카테고리의 모든 할 일을 삭제합니다.")
        case .allCategoryCheckTask:
            Text("모든 카테고리의 체크된 할 일을 삭제합니다.")
        case .currentCategoryCheckTask:
            Text("현재 선택된 카테고리의 체크된 할 일을 삭제합니다.")
        }
    }
}

