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
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    TotalFocusTimeService.shared.checkRestFocusTime()
                }
        }
    }
}
