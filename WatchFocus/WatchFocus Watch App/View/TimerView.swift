//
//  TimerView.swift
//  WatchFocus
//
//  Created by 방유빈 on 2024/02/20.
//

import SwiftUI

struct TimerView: View {
    @EnvironmentObject private var timerStore: TimerStore
    @State private var isShowingSetting: Bool = false
    var progressColor: Color {
        return timerStore.currentTimer.timerType == .focus ? .wfAlphaPurple : .wfAlphaBlue
    }
    
    var body: some View {
        Form {
            WfTimerProgressView(currentTimer: $timerStore.currentTimer, size: .small)
                .padding(10)
                .listRowBackground(Color.clear)
            Text("\(timerStore.currentTimer.timerSetting.focusTime/60)m/\(timerStore.currentTimer.timerSetting.restTime/60)m - \(timerStore.currentTimer.timerSetting.iterationCount)회")
                .frame(maxWidth: .infinity)
                .listRowBackground(Color.clear)
                .foregroundStyle(Color.wfGray)
            VStack {
                Button {
                    if timerStore.isRunning {
                        timerStore.stopTimer()
                    } else {
                        timerStore.startTimer()
                    }
                } label: {
                    Text(timerStore.isRunning ? "STOP" : "START")
                        .bold()
                }
                Button{
                    timerStore.resetTimer()
                }label: {
                    Text("Reset")
                        .bold()
                }
                .tint(.wfAlphaPurple)
            }
            .buttonStyle(.borderedProminent)
            .tint(progressColor)
            .listRowBackground(Color.clear)

        }
        .navigationTitle("Timer")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button{
                    isShowingSetting.toggle()
                }label: {
                    Image(systemName: "gearshape.fill")
                        .foregroundStyle(Color.wfGray)
                }
            }
        }
        .navigationDestination(isPresented: $isShowingSetting) {
            TimerSettingView()
        }
        .onAppear {
            timerStore.loadTimerSetting()
        }
    }
}

#Preview {
    NavigationStack {
        TimerView()
    }
    .environmentObject(TimerStore())
}
