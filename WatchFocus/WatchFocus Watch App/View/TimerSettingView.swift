//
//  TimerSettingView.swift
//  WatchFocus Watch App
//
//  Created by 방유빈 on 2024/02/20.
//

import SwiftUI

struct TimerSettingView: View {
    @State private var isShowingTimerView: Bool = false
    @State private var focusSelectedIndex: Int = 0
    @State private var restSelectedIndex: Int = 0
    @State private var iterationSelectedIndex: Int = 0

    private var focusTimeList = [10, 30, 40, 50, 60]
    private var restTimeList = [5, 10, 15, 20, 30]
    private var iterationCountList = [1, 2, 3, 4, 5]
    
    var body: some View {
        VStack {
            HStack {
                VStack {
                    Text("집중 시간")
                        .font(.wfCalloutFont)
                        .padding(.bottom, -10)
                    Picker("", selection: $focusSelectedIndex) {
                        ForEach(0..<focusTimeList.count, id: \.self) { index in
                            Text("\(focusTimeList[index])")
                        }
                    }
                }

                VStack {
                    Text("휴식 시간")
                        .font(.wfCalloutFont)
                        .padding(.bottom, -10)
                    Picker("", selection: $restSelectedIndex) {
                        ForEach(0..<restTimeList.count, id: \.self) { index in
                            Text("\(restTimeList[index])")
                        }
                    }
                }
                VStack {
                    Text("반복 횟수")
                        .font(.wfCalloutFont)
                        .padding(.bottom, -10)
                    Picker("", selection: $iterationSelectedIndex) {
                        ForEach(0..<iterationCountList.count, id: \.self) { index in
                            Text("\(iterationCountList[index])")
                        }
                    }
                }
            }
            .pickerStyle(.wheel)
            
            Spacer()
            Button {
                isShowingTimerView.toggle()
            } label: {
                Text("시작")
                    .bold()
            }
            .padding()
        }
        .navigationTitle("Timer Setting")
        .navigationDestination(isPresented: $isShowingTimerView) {
            let currentTimer = CurretTimer(timer: TimerSetting(focusTime: focusTimeList[focusSelectedIndex] * 60, restTime: restTimeList[restSelectedIndex] * 60, iterationCount: iterationCountList[iterationSelectedIndex]))
            TimerView(currentTimer: currentTimer)
        }
    }
}

#Preview {
    NavigationStack {
        TimerSettingView()
    }
}
