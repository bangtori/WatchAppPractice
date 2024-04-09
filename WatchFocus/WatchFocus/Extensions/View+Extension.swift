//
//  View+Extension.swift
//  WatchFocus
//
//  Created by 방유빈 on 2024/03/09.
//

import SwiftUI
import UIKit

extension View {
    func toastView(toast: Binding<Toast?>) -> some View {
        self.modifier(ToastModifier(toast: toast))
    }
    
    @MainActor
    func snapshot(scale: CGFloat? = nil) -> UIImage? {
        let renderer = ImageRenderer(content: self)
        renderer.scale = scale ?? UIScreen.main.scale
        return renderer.uiImage
    }
}

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

struct ToastModifier: ViewModifier {
    
    @Binding var toast: Toast?
    @State private var workItem: DispatchWorkItem?
    
    func body(content: Content) -> some View {
        GeometryReader { geometry in
            content
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .overlay(
                    ZStack {
                        mainToastView()
                            .offset(y: -100)
                    }
                        .animation(.spring(), value: toast)
                )
                .customOnChange(toast, action: { _, _ in
                    showToast()
                })
        }
    }
    
    @ViewBuilder func mainToastView() -> some View {
        if let toast = toast {
            VStack {
                Spacer()
                WFToastMessageView(
                    style: toast.style,
                    message: toast.message,
                    width: toast.width
                )
            }
        }
    }
    
    private func showToast() {
        guard let toast = toast else { return }
        
        UIImpactFeedbackGenerator(style: .light)
            .impactOccurred()
        
        if toast.duration > 0 {
            workItem?.cancel()
            
            let task = DispatchWorkItem {
                dismissToast()
            }
            
            workItem = task
            DispatchQueue.main.asyncAfter(deadline: .now() + toast.duration, execute: task)
        }
    }
    
    private func dismissToast() {
        withAnimation {
            toast = nil
        }
        
        workItem?.cancel()
        workItem = nil
    }
}
