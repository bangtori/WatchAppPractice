//
//  TimerSettingView.swift
//  WatchFocus
//
//  Created by 방유빈 on 2024/02/14.
//

import SwiftUI

struct TimerSettingView: View {
    @Environment(\.colorScheme) var scheme
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var timerStore: TimerStore
    @State private var focusTimeValue = 50.0
    @State private var restTimeValue = 10.0
    @State private var iterationCount = 1
    @State private var isShowingAlert: Bool = false
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("집중 시간(분)")
                Spacer()
                Text("\(Int(focusTimeValue))")
            }
            .font(.wfTitleFont)
            HStack {
                Text("10")
                    .font(.wfCalloutFont)
                    .foregroundStyle(WfColor.wfGray.returnColor(scheme: scheme))
                Slider(value: $focusTimeValue, in: 10...120, step: 5)
                    .tint(WfColor.wfMainPurple.returnColor(scheme: scheme))
                Text("120")
                    .font(.wfCalloutFont)
                    .foregroundStyle(WfColor.wfGray.returnColor(scheme: scheme))
            }
            .padding(.bottom, 30)
            
            HStack {
                Text("휴식 시간(분)")
                Spacer()
                Text("\(Int(restTimeValue))")
            }
            .font(.wfTitleFont)
            HStack {
                Text("0")
                    .font(.wfCalloutFont)
                    .foregroundStyle(WfColor.wfGray.returnColor(scheme: scheme))
                Slider(value: $restTimeValue, in: 0...30, step: 5)
                    .tint(WfColor.wfMainBlue.returnColor(scheme: scheme))
                Text("30")
                    .font(.wfCalloutFont)
                    .foregroundStyle(WfColor.wfGray.returnColor(scheme: scheme))
            }
            .padding(.bottom, 30)
            HStack {
                VStack(alignment: .leading) {
                    Text("반복 횟수")
                        .font(.wfTitleFont)
                    Text("min: 1 / max: 10")
                        .font(.wfCalloutFont)
                        .foregroundStyle(WfColor.wfGray.returnColor(scheme: scheme))
                }
                Spacer()
                Button {
                    if iterationCount > 0 {
                        iterationCount -= 1
                    }
                } label: {
                    Image(systemName: "minus")
                }
                .foregroundStyle(WfColor.wfGray.returnColor(scheme: scheme))
                Text("\(iterationCount)")
                    .frame(width: 50)
                Button {
                    if iterationCount < 10 {
                        iterationCount += 1
                    }
                } label: {
                    Image(systemName: "plus")
                }
                .foregroundStyle(WfColor.wfGray.returnColor(scheme: scheme))
            }
            .font(.wfBody1Font)
            Spacer()
            
            Button {
                isShowingAlert.toggle()
            } label: {
                Text("Save Task")
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .font(.wfBody1Font)
                    .foregroundStyle(Color.white)
                    .background(WfColor.wfMainBlue.returnColor(scheme: scheme))
                    .clipShape(RoundedRectangle(cornerRadius: 15))
            }
            .alert("타이머 설정", isPresented: $isShowingAlert) {
                Button("취소", role: .none) {}
                Button("저장", role: .none) {
                    let focusTime = Int(focusTimeValue) * 60
                    let restTime = Int(restTimeValue) * 60
                    let newSetting = TimerSetting(focusTime: focusTime, restTime: restTime, iterationCount: iterationCount)
                    timerStore.updateSetting(setting: newSetting)
                    dismiss()
                }
            }message: {
                Text("설정 값으로 타이머를 초기화합니다.")
            }
        }
        .padding()
        .navigationTitle("Timer Setting")
        .onAppear {
            timerStore.loadTimerSetting()
            focusTimeValue = Double(timerStore.currentTimer.timerSetting.focusTime) / 60.0
            restTimeValue = Double(timerStore.currentTimer.timerSetting.restTime) / 60.0
            iterationCount = timerStore.currentTimer.timerSetting.iterationCount
            
        }
    }
}

#Preview {
    NavigationStack {
        TimerSettingView()
            .environmentObject(TimerStore())
    }
}
