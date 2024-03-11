//
//  View+Extension.swift
//  WatchFocus
//
//  Created by 방유빈 on 2024/03/09.
//

import SwiftUI

// MARK: - Modifier 관련
extension View {
    /// ios 17이후에 따른 onChange 분기 처리 modifier
    func customOnChange<V>(_ value: V, action: @escaping (_ oldValue: V, _ newValue: V) -> Void) -> some View where V: Equatable {
        modifier(OnChangeModifier(value: value, action: action))
    }
}

struct OnChangeModifier<V: Equatable>: ViewModifier {
    let value: V
    let action: (_ oldValue: V, _ newValue: V) -> Void
    
    func body(content: Content) -> some View {
        if #available(iOS 17, *) {
            content
                .onChange(of: value) { oldValue, newValue in
                    action(oldValue, newValue)
                }
        } else {
            content
                .onChange(of: value) { [value] newValue in
                    action(value, newValue)
                }
        }
    }
    
}
