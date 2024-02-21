//
//  TimerView.swift
//  WatchFocus
//
//  Created by 방유빈 on 2024/02/13.
//

import SwiftUI

struct TimerView: View {
    @EnvironmentObject private var timerStore: TimerStore
    @State private var isShowingSetting: Bool = false
    
    var progressColor: Color {
        return timerStore.currentTimer.timerType == .focus ? .wfMainPurple : .wfMainBlue
    }
    var body: some View {
        Form {
            Section("오늘의 집중 시간") {
                Text(timerStore.totalFocusTime.timeFormatting())
                    .font(.wfLargeTitleFont)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .listRowSeparator(.hidden)
                    .listRowBackground(
                        RoundedRectangle(cornerRadius: 15)
                            .background(.clear)
                            .foregroundColor(.white)
                            .padding(
                                EdgeInsets(
                                    top: 10,
                                    leading: 10,
                                    bottom: 10,
                                    trailing: 10
                                )
                            )
                            .shadow(color: Color(hex: "F0F3FF"), radius: 5, x: 5, y: 4)
                    )
            }
            Section {
                VStack {
                    Text("Pomodoro \(timerStore.currentTimer.timerSetting.focusTime/60)m/\(timerStore.currentTimer.timerSetting.restTime/60)m")
                        .font(.wfTitleFont)
                        .foregroundStyle(Color.wfGray)
                    WfTimerProgressView(currentTimer: $timerStore.currentTimer)
                        .padding()
                        .padding(.bottom)
                    Button {
                        if timerStore.isRunning {
                            timerStore.stopTimer()
                        } else {
                            timerStore.startTimer()
                        }
                    } label: {
                        Text(timerStore.isRunning ? "STOP" : "START")
                            .frame(width: 150, height: 50)
                            .font(.wfTitleFont)
                            .foregroundStyle(Color.white)
                            .background(progressColor)
                            .clipShape(RoundedRectangle(cornerRadius: 40))

                    }
                    
                }
            }
            .listRowBackground(Color.wfBackgroundGray)
            .listRowSeparator(.hidden)
        }
        .scrollContentBackground(.hidden)
        .background(Color.wfBackgroundGray, ignoresSafeAreaEdges: .all)
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
            
            ToolbarItem(placement: .topBarLeading) {
                Button{
                    timerStore.resetTimer()
                }label: {
                    Text("Reset")
                        .foregroundStyle(Color.wfGray)
                }
            }
        }
        .alert("타이머 종료", isPresented: $timerStore.isFinish) {
            Button("확인", role: .none) {
                timerStore.resetTimer()
            }
        } message: {
            Text("뽀모도로 집중 시간이 끝났습니다.")
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
            .environmentObject(TimerStore())
    }
}
