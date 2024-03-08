//
//  TimerView.swift
//  WatchFocus
//
//  Created by 방유빈 on 2024/02/13.
//

import SwiftUI

struct TimerView: View {
    @Environment(\.colorScheme) var scheme
    @EnvironmentObject private var timerStore: TimerStore
    @State private var isShowingSetting: Bool = false
    
    var progressColor: WfColor {
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
                            .stroke(Color(hex: "#6A6A6A"),style: StrokeStyle(lineWidth: scheme == .light ? 0 : 2))
                            .fill(WfColor.wfRowBackgroundColor.returnColor(scheme: scheme))
                            .background(.clear)
                            .padding(
                                EdgeInsets(
                                    top: 10,
                                    leading: 10,
                                    bottom: 10,
                                    trailing: 10
                                )
                            )
                            .shadow(color: scheme == .light ? Color(hex: "F0F3FF") : Color(hex: "F0F3FF", opacity: 0), radius: 5, x: 5, y: 4)
                    )
            }
            Section {
                VStack {
                    Text("Pomodoro \(timerStore.currentTimer.timerSetting.focusTime/60)m/\(timerStore.currentTimer.timerSetting.restTime/60)m")
                        .font(.wfTitleFont)
                        .foregroundStyle(WfColor.wfGray.returnColor(scheme: scheme))
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
                            .background(progressColor.returnColor(scheme: scheme))
                            .clipShape(RoundedRectangle(cornerRadius: 40))

                    }
                    
                }
            }
            .listRowBackground(WfColor.wfbackgroundColor.returnColor(scheme: scheme))
            .listRowSeparator(.hidden)
        }
        .scrollContentBackground(.hidden)
        .background(WfColor.wfbackgroundColor.returnColor(scheme: scheme), ignoresSafeAreaEdges: .all)
        .navigationTitle("Timer")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button{
                    isShowingSetting.toggle()
                }label: {
                    Image(systemName: "gearshape.fill")
                        .foregroundStyle(WfColor.wfGray.returnColor(scheme: scheme))
                }
            }
            
            ToolbarItem(placement: .topBarLeading) {
                Button{
                    timerStore.resetTimer()
                }label: {
                    Text("Reset")
                        .foregroundStyle(WfColor.wfGray.returnColor(scheme: scheme))
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
