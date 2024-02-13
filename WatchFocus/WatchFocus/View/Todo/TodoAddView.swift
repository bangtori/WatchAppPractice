//
//  TodoAddView.swift
//  WatchFocus
//
//  Created by 방유빈 on 2024/02/13.
//

import SwiftUI

struct TodoAddView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var todoStore: TodoStore
    @State private var taskText: String = ""
    @State private var isTimeSet: Bool = false
    @State private var deadline: Date = Date()
    @State private var isShowingAlert: Bool = false
    var body: some View {
        VStack {
            Text("Add To Do")
                .font(.wfLargeTitleFont)
            WfTodoTextField(placeholder: "Enter Your new Task", text: $taskText)
                .padding(.bottom)
            VStack() {
                Toggle(isOn: $isTimeSet) {
                    Text("시간 설정")
                        .font(.wfBody2Font)
                }
                .tint(.wfMainBlue)
                if isTimeSet {
                    DatePicker("", selection: $deadline, displayedComponents: .hourAndMinute)
                        .datePickerStyle(.compact)
                }
            }
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
            .alert("리뷰 작성", isPresented: $isShowingAlert) {
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
