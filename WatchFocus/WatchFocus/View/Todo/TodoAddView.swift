//
//  TodoAddView.swift
//  WatchFocus
//
//  Created by 방유빈 on 2024/02/13.
//

import SwiftUI
import DYColor

struct TodoAddView: View {
    enum AlertType {
        case saveTask
        case addCategory
        case deleteCategory
        case fullCategory
    }
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) var scheme
    
    @EnvironmentObject private var todoStore: TodoStore
    @State private var taskText: String = ""
    @State private var categoryText: String = ""
    @State private var isTimeSet: Bool = false
    @State private var deadline: Date = Date()
    @State private var isShowingAlert: Bool = false
    @State private var selectedCategoryColor: CategoryColorCode = .blue
    @State private var selectedCategory: Category?
    @State private var removeCategory: Category?
//    private let categorys: [Category] = [Category(name: "category1", color: .blue), Category(name: "category2", color: .red), Category(name: "category3", color: .green)]
    @State private var alertType: AlertType = .addCategory
    
    var body: some View {
        VStack {
            Text("Add To Do")
                .font(.wfLargeTitleFont)
            WfTodoTextField(placeholder: "Enter Your new Task", text: $taskText)
                .padding(.bottom)
            VStack() {
                Toggle(isOn: $isTimeSet) {
                    Text("시간 설정")
                        .font(.wfBody1Font)
                }
                .tint(.wfMainBlue)
                if isTimeSet {
                    DatePicker("", selection: $deadline, displayedComponents: .hourAndMinute)
                        .datePickerStyle(.compact)
                }
            }
            .padding(.bottom)
            VStack(alignment: .leading) {
                Text("Category 설정 (최대 5개)")
                    .font(.wfBody1Font)
                VStack(alignment: .leading) {
                    Text("New Category")
                        .font(.wfBody2Font)
                        .fontWeight(.heavy)
                    HStack {
                        WfTodoTextField(placeholder: "Add Category", text: $categoryText)
                        Button {
                            if todoStore.categorys.count == 5 {
                                alertType = .fullCategory
                                isShowingAlert.toggle()
                            } else {
                                alertType = .addCategory
                                isShowingAlert.toggle()
                            }
                        } label: {
                            Image(systemName: "plus")
                                .bold()
                                .frame(width: 50, height: 50)
                                .foregroundStyle(Color.white.opacity(0.7))
                                .background(DYColor.wfAlphaBlue.dynamicColor)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                        }
                        .disabled(categoryText.trimmingCharacters(in: .whitespaces).isEmpty)
                        
                    }
                    .padding(.bottom)
                    Text("Select Category Color")
                        .font(.wfBody2Font)
                        .foregroundStyle(DYColor.wfSubTitleText.dynamicColor)
                    HStack {
                        ForEach(CategoryColorCode.allCases, id: \.rawValue) { category in
                            Button {
                                selectedCategoryColor = category
                            } label: {
                                ColorSelectView(color: category.getDYColor, isSelected: selectedCategoryColor == category ? true : false)
                            }
                        }
                    }
                }
                .padding()
                .overlay {
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(DYColor.wfUnableCategory.dynamicColor, lineWidth: 1)
                }
                VStack(alignment: .leading) {
                    CategoryRadioButton(isSelected: selectedCategory == nil ? true : false, label: "none", color: DYColor(lightColor: .black, darkColor: .white)) {
                        selectedCategory = nil
                    }
                    .padding(.bottom, 5)
                    ForEach(todoStore.categorys) { category in
                        HStack(alignment: .center) {
                            CategoryRadioButton(isSelected: selectedCategory?.id == category.id ? true : false, label: category.name, color: category.color.getDYColor){
                                selectedCategory = category
                            }
                            Button {
                                removeCategory = category
                                alertType = .deleteCategory
                                isShowingAlert.toggle()
                            } label: {
                                Image(systemName: "xmark.circle")
                                    .font(.wfBody2Font)
                                    .padding(.horizontal, 5)
                            }
                        }
                        .padding(.bottom, 5)
                    }
                }
                .padding()
            }
            .font(Font.wfBody1Font)
            .foregroundStyle(DYColor.wfTextDarkGray.dynamicColor)
            
            Spacer()
            Button {
                alertType = .saveTask
                isShowingAlert.toggle()
            } label: {
                Text("Save Task")
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .font(.wfBody1Font)
                    .foregroundStyle(Color.white)
                    .background(Color.wfMainBlue)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .disabled(taskText.trimmingCharacters(in: .whitespaces).isEmpty)
            }
            .alert(alertType.titleText, isPresented: $isShowingAlert) {
                if alertType != .fullCategory {
                    Button("취소", role: .none) {}
                }
                Button(alertType.ConfirmButtonText, role: .none) {
                    switch alertType {
                    case .saveTask:
                        let todoObj = TodoObject()
                        todoObj.title = taskText
                        todoObj.deadline = isTimeSet ? deadline.timeIntervalSince1970 : nil
                        todoObj.createDate = Date().timeIntervalSince1970
                        todoObj.isChecked = false
                        todoObj.categoryId = selectedCategory?.id
                        todoStore.addTodo(todo: todoObj)
                        dismiss()
                    case .addCategory:
                        let newCategory = Category(name: categoryText.trimmingCharacters(in: .whitespaces), color: selectedCategoryColor)
                        todoStore.addCategorys(category: newCategory)
                        categoryText = ""
                    case .deleteCategory:
                        guard let category = removeCategory else { return }
                        todoStore.deleteCategory(categoryId: category.id)
                    case .fullCategory:
                        categoryText = ""
                        break
                    }
                }
            }message: {
                switch alertType {
                case .saveTask:
                    Text("\(taskText)을(를) 할 일에 추가합니다.")
                case .addCategory:
                    Text("\(categoryText)을(를) 카테고리에 추가합니다.")
                case .deleteCategory:
                    Text("\(removeCategory?.name ?? "")을(를) 카테고리에서 삭제합니다.")
                case .fullCategory:
                    Text("카테고리는 최대 5개까지 설정 가능합니다. 한 개를 삭제해주세요.")
                }
            }

        }
        .padding(20)
        .onAppear {
            todoStore.loadCategory()
        }
    }
}

#Preview {
    TodoAddView()
        .environmentObject(TodoStore())
}

struct ColorSelectView: View {
    @Environment(\.colorScheme) var scheme
    
    var color: DYColor
    var isSelected: Bool
    var body: some View {
        Circle()
            .fill(isSelected ? color.dynamicColor : color.dynamicColor.opacity(0.3))
            .stroke(DYColor(lightColor: .black, darkColor: .white).dynamicColor, lineWidth: isSelected ? 2 : 0)
            .frame(minWidth: 30, maxWidth: 40, minHeight: 30, maxHeight: 40)
    }
}

struct CategoryRadioButton: View {
    @Environment(\.font) private var font: Font?
    var isSelected: Bool
    var label: String
    var color: DYColor
    var action: () -> Void
    
    var body: some View {
        HStack {
            Button {
                action()
            } label: {
                ZStack {
                    Circle()
                        .stroke(color.dynamicColor, lineWidth: 2)
                    Circle()
                        .fill(isSelected ? color.dynamicColor : color.dynamicColor.opacity(0))
                            .padding(4)
                }
            }
            Text(label)
        }
        .fixedSize()
    }

}

extension TodoAddView.AlertType {
    var titleText: String {
        switch self {
        case .saveTask:
            "할 일 저장"
        case .addCategory:
            "카테고리 추가"
        case .deleteCategory:
            "카테고리 삭제"
        case .fullCategory:
            "카테고리 최대 수 초과"
        }
    }
    
    var ConfirmButtonText: String {
        switch self {
        case .saveTask:
            "저장"
        case .addCategory:
            "추가"
        case .deleteCategory:
            "삭제"
        case .fullCategory:
            "확인"
        }
    }

}
