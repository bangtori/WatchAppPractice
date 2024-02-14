//
//  TabBarView.swift
//  WatchFocus
//
//  Created by 방유빈 on 2024/02/13.
//

import SwiftUI

struct TabBarView: View {
    @State private var selectedTab = 0
    var body: some View {
        TabView(selection: $selectedTab,
                content:  {
            NavigationStack {
                TodoView()
            }
            .tabItem {
                Image(systemName: "checklist")
                Text("Todo")
            }
            .tag(0)
            
            NavigationStack {
                TimerView()
            }
            .tabItem {
                Image(systemName: "timer")
                Text("Timer")
            }
            .tag(1)
        })
    }
}
