//
//  ContentView.swift
//  WatchFocus
//
//  Created by 방유빈 on 2024/02/13.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var todoStore: TodoStore = TodoStore()
    @StateObject private var timerStore: TimerStore = TimerStore()
    
    var body: some View {
        TabBarView()
            .environmentObject(todoStore)
            .environmentObject(timerStore)
    }
}

#Preview {
    ContentView()
}
