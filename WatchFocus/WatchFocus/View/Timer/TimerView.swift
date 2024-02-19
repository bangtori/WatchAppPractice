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
                    TimerProgressView()
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
                            .background(timerStore.progressColor)
                            .clipShape(RoundedRectangle(cornerRadius: 40))
                    }
                    .buttonStyle(.plain)
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
        }message: {
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

struct TimerProgressView: View {
    @EnvironmentObject private var timerStore: TimerStore
    
    var progress: Double {
        let totalTime: Int
        switch timerStore.currentTimer.timerType {
        case .focus:
            totalTime = timerStore.currentTimer.timerSetting.focusTime
        case .rest:
            totalTime = timerStore.currentTimer.timerSetting.restTime
        }
        if totalTime == 0 {
            return 0.0
        }
        return Double(timerStore.remainTime) / Double(totalTime)
    }
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.wfLightGray, lineWidth: 20)
            VStack {
                Text("Session \(timerStore.currentTimer.currentIterationCount)")
                    .font(.wfBody1Font)
                    .foregroundStyle(timerStore.progressColor)
                Text(timerStore.remainTime.timeFormatting())
                    .font(.wfLargeTitleFont)
            }
            Circle()
                .trim(from: 0.0, to: CGFloat(min(self.progress, 1.0)))
                .stroke(timerStore.progressColor, style: StrokeStyle(lineWidth: 20, lineCap: .round))
                .rotationEffect(Angle(degrees: -90))
        }
    }
}
