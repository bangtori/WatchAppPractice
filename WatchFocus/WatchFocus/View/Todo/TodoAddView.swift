//
//  TodoAddView.swift
//  WatchFocus
//
//  Created by 방유빈 on 2024/02/13.
//

import SwiftUI
import DYColor

struct TodoAddView: View {
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
    private let categorys: [Category] = [Category(name: "category1", color: .blue), Category(name: "category2", color: .red), Category(name: "category3", color: .green)]
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
                            // TODO: - 카테고리 추가 로직
                        } label: {
                            Image(systemName: "plus")
                                .bold()
                                .frame(width: 50, height: 50)
                                .foregroundStyle(Color.white.opacity(0.7))
                                .background(DYColor.wfAlphaBlue.dynamicColor)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                        }
                        
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
                    ForEach(categorys) { category in
                        CategoryRadioButton(isSelected: selectedCategory?.id == category.id ? true : false, label: category.name, color: category.color.getDYColor){
                            selectedCategory = category
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
                isShowingAlert.toggle()
            } label: {
                Text("Save Task")
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .font(.wfBody1Font)
                    .foregroundStyle(Color.white)
                    .background(Color.wfMainBlue)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
            }
            .alert("할 일 작성", isPresented: $isShowingAlert) {
                Button("취소", role: .none) {}
                Button("저장", role: .none) {
                    let newTodo = Todo(title: taskText, deadline: isTimeSet ? deadline.timeIntervalSince1970 : nil, createDate: Date().timeIntervalSince1970, isChecked: false)
                    todoStore.addTodo(todo: newTodo)
                    dismiss()
                }
            }message: {
                Text("작성한 할 일을 저장합니다.")
            }

        }
        .padding(20)
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
            .frame(maxWidth: 40, maxHeight: 40)
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
