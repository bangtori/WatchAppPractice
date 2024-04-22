//
//  TimerProgressView.swift
//  WatchFocus
//
//  Created by 방유빈 on 2024/02/20.
//

import SwiftUI

struct WfTimerProgressView: View {
    @Environment(\.colorScheme) var scheme
    enum Size {
        case large
        case small
    }
    @Binding var currentTimer: CurretTimer
    var size: Size = .large
    var progressColor: Color
    var progress: Double {
        let totalTime: Int
        switch currentTimer.timerType {
        case .focus:
            totalTime = currentTimer.timerSetting.focusTime
        case .rest:
            totalTime = currentTimer.timerSetting.restTime
        }
        if totalTime == 0 {
            return 0.0
        }
        return Double(currentTimer.remainTime) / Double(totalTime)
    }
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.wfLightGray, lineWidth: 20)
            VStack {
                Text("Session \(currentTimer.currentIterationCount)")
                    .font(.wfBody1Font)
                    .foregroundStyle(progressColor)
                Text(currentTimer.remainTime.timeFormatting())
                    .font(size == .large ? .wfLargeTitleFont : .wfBody1Font)
            }
            Circle()
                .trim(from: 0.0, to: CGFloat(min(self.progress, 1.0)))
                .stroke(progressColor, style: StrokeStyle(lineWidth: 20, lineCap: .round))
                .rotationEffect(Angle(degrees: -90))
        }
    }
}
