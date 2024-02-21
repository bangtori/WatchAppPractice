//
//  TimerView.swift
//  WatchFocus
//
//  Created by 방유빈 on 2024/02/20.
//

import SwiftUI

struct TimerView: View {
    @State var currentTimer: CurretTimer
    var body: some View {
        Form {
                WfTimerProgressView(currentTimer: $currentTimer, size: .small)
                .padding(10)
                .listRowBackground(Color.clear)
            Text("\(currentTimer.timerSetting.focusTime/60)m/\(currentTimer.timerSetting.restTime/60)m - \(currentTimer.timerSetting.iterationCount)회")
                .frame(maxWidth: .infinity)
                .listRowBackground(Color.clear)
                .foregroundStyle(Color.wfGray)
                Button {
                    print(currentTimer)
                } label: {
                    Text("Start")
                        .bold()
                }
                .buttonStyle(.borderedProminent)
                .tint(.wfMainPurple)
                .listRowBackground(Color.clear)

        }
        .navigationTitle("Timer")
    }
}

#Preview {
    NavigationStack {
        TimerView(currentTimer: CurretTimer())
    }
}
