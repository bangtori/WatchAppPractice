//
//  WfTodoTextField.swift
//  WatchFocus
//
//  Created by 방유빈 on 2024/02/13.
//

import SwiftUI
import DYColor

struct WfTodoTextField: View {
    @Environment(\.colorScheme) var scheme
    var placeholder: String
    @Binding var text: String
    @FocusState private var isFocused: Bool
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .stroke(isFocused ? DYColor.wfMainBlue.dynamicColor : Color.clear, lineWidth: 1)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundStyle(DYColor.wfbackgroundColor.dynamicColor)
                )
            TextField(placeholder, text: $text)
                .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                .font(.wfBody2Font)
                .fontWeight(.heavy)
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
                            .foregroundColor(DYColor.wfAlphaBlue.dynamicColor)
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
