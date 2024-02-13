//
//  WfTodoTextField.swift
//  WatchFocus
//
//  Created by 방유빈 on 2024/02/13.
//

import SwiftUI

struct WfTodoTextField: View {
    var placeholder: String
    @Binding var text: String
    @FocusState private var isFocused: Bool
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .stroke(isFocused ? Color.wfMainBlue : Color.clear, lineWidth: 1)
                .background(RoundedRectangle(cornerRadius: 20).foregroundStyle(Color.wfBackgroundGray))
            TextField(placeholder, text: $text)
                .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                .font(.wfBody2Font)
                .foregroundStyle(Color.wfBlueGray)
                .focused($isFocused)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
            
            if isFocused {
                HStack {
                    Spacer()
                    Button(action: {
                        text = ""
                    }, label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.wfAlphaBlue)
                    })
                    .padding(.trailing, 20)
                }
            }
        }
        .frame(minHeight: 42, maxHeight: 52)
    }
}

#Preview {
    WfTodoTextField(placeholder: "Enter Your new Task", text: .constant(""))
}
