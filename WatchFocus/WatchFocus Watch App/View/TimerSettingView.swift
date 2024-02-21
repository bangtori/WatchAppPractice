//
//  TimerSettingView.swift
//  WatchFocus Watch App
//
//  Created by 방유빈 on 2024/02/20.
//

import SwiftUI

struct TimerSettingView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var timerStore: TimerStore
    @State private var isShowingAlert: Bool = false
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
                let timerSetting = TimerSetting(focusTime: focusTimeList[focusSelectedIndex] * 60, restTime: restTimeList[restSelectedIndex] * 60, iterationCount: iterationCountList[iterationSelectedIndex])
                timerStore.updateSetting(setting: timerSetting)
                dismiss()
            } label: {
                Text("저장")
                    .bold()
            }
            .padding()
        }
        .navigationTitle("Timer Setting")
        .navigationBarBackButtonHidden(true)
        .toolbar(content: {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    isShowingAlert.toggle()
                } label: {
                    Image(systemName: "arrow.left")
                }
            }
        })
        .alert("뒤로 가기", isPresented: $isShowingAlert) {
            Button("취소", role: .none) {}
            Button("확인", role: .destructive) {
                dismiss()
            }
        } message: {
            Text("뒤로가기 시 설정 값은 저장되지 않습니다.")
        }
    }
}

#Preview {
    NavigationStack {
        TimerSettingView()
    }
    .environmentObject(TimerStore())
}
