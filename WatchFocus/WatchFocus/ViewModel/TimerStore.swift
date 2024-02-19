//
//  TimerStore.swift
//  WatchFocus
//
//  Created by 방유빈 on 2024/02/14.
//

import SwiftUI

class TimerStore: ObservableObject {
    @Published var currentTimer: CurretTimer = CurretTimer() {
        didSet {
            saveTimerSetting()
        }
    }
    @Published var isFinish: Bool = false {
        willSet {
            if newValue == true {
                saveTotalFocusUserDefaults()
            }
        }
    }
    @Published var isRunning: Bool = false
    @Published var remainTime: Int = 0
    @Published var totalFocusTime: Int = UserDefaults.standard.integer(forKey: UserDefaultsKeys.totalFocusTime.rawValue)
    
    var progressColor: Color {
        return currentTimer.timerType == .focus ? .wfMainPurple : .wfMainBlue
    }
    
    private var timer: Timer?
    
    func updateSetting(setting: TimerSetting) {
        let newTimer = CurretTimer(timer: setting, currentIterationCount: 0, timerType: .rest)
        currentTimer = newTimer
        
    }
    
    func finishSession() {
        if currentTimer.timerType == .rest && currentTimer.currentIterationCount == currentTimer.timerSetting.iterationCount {
            isFinish = true
        } else {
            toggleTimerType()
        }
    }
    
    func startTimer(){
        if remainTime == 0 {
            toggleTimerType()
        }
        isRunning = true
        isFinish = false
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { _ in
            self.progressTimer()
        })
    }
    
    func progressTimer(){
        if remainTime > 0{
            remainTime -= 1
            totalFocusTime += 1
        }else{
            finishSession()
        }
    }
    
    func stopTimer(){
        timer?.invalidate()
        isRunning = false
        saveTotalFocusUserDefaults()
    }
    
    func resetTimer(){
        remainTime = 0
        currentTimer.currentIterationCount = 0
        currentTimer.timerType = .rest
        stopTimer()
    }
    
    func loadTimerSetting() {
        let decoder: JSONDecoder = JSONDecoder()
        if let data = UserDefaults.standard.object(forKey: UserDefaultsKeys.timer.rawValue) as? Data{
            if let saveData = try? decoder.decode(CurretTimer.self, from: data){
                currentTimer = saveData
            }
        }
    }
    
    func saveTimerSetting() {
        let encoder:JSONEncoder = JSONEncoder()
        if let encoded = try? encoder.encode(currentTimer){
            UserDefaults.standard.set(encoded, forKey: UserDefaultsKeys.timer.rawValue)
        }
    }
    
    private func toggleTimerType() {
        switch currentTimer.timerType {
        case .focus:
            currentTimer.timerType = .rest
            remainTime = currentTimer.timerSetting.restTime
        case .rest:
            currentTimer.timerType = .focus
            remainTime = currentTimer.timerSetting.focusTime
            currentTimer.currentIterationCount += 1
        }
    }
    
    private func saveTotalFocusUserDefaults() {
        TotalFocusTimeService.shared.checkRestFocusTime()
        UserDefaults.standard.setValue(totalFocusTime, forKey: UserDefaultsKeys.totalFocusTime.rawValue)
        UserDefaults.standard.setValue(Date().timeIntervalSince1970, forKey: UserDefaultsKeys.lastDateSaveTime.rawValue)
    }
}

