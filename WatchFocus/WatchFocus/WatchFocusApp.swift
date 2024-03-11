//
//  WatchFocusApp.swift
//  WatchFocus
//
//  Created by 방유빈 on 2024/02/13.
//

import SwiftUI
import UserNotifications

@main
struct WatchFocusApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @StateObject private var todoStore: TodoStore = TodoStore()
    @StateObject private var timerStore: TimerStore = TimerStore()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(todoStore)
                .environmentObject(timerStore)
                .onAppear {
                    TotalFocusTimeService.shared.checkRestFocusTime()
                }
        }
    }
}
