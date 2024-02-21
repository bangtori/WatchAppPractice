//
//  ContentView.swift
//  WatchFocus Watch App
//
//  Created by 방유빈 on 2024/02/13.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var todoStore: TodoStore = TodoStore()
    
    @State private var selectedTab = 0
    var body: some View {
        TabView(selection: $selectedTab,
                content:  {
            NavigationStack {
                TodoView()
            }
            .tag(0)
            
            NavigationStack {
                TimerSettingView()
            }
            .tag(1)
        })
        .environmentObject(todoStore)
    }
}

#Preview {
    ContentView()
}
