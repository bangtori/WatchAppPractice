//
//  Timer.swift
//  WatchFocus
//
//  Created by 방유빈 on 2024/02/14.
//

import Foundation

struct CurretTimer: Codable {
    let timerSetting: TimerSetting
    var currentIterationCount: Int
    var timerType: TimerType
    var remainTime: Int
    
    init(timer: TimerSetting = TimerSetting(focusTime: 50 * 60, restTime: 10 * 60, iterationCount: 1), currentIterationCount: Int = 0, timerType: TimerType = .rest, remainTime: Int = 0) {
        self.timerSetting = timer
        self.currentIterationCount = currentIterationCount
        self.timerType = timerType
        self.remainTime = remainTime
    }
}

struct TimerSetting: Codable {
    let focusTime: Int
    let restTime: Int
    let iterationCount: Int
}

enum TimerType: String, Codable {
    case focus
    case rest
}
