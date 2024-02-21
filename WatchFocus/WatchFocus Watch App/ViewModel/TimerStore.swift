//
//  TimerStore.swift
//  WatchFocus Watch App
//
//  Created by 방유빈 on 2024/02/21.
//

import Foundation

final class TimerStore: ObservableObject {
    @Published var currentTimer: CurretTimer = CurretTimer() {
        didSet {
            saveTimerSetting()
        }
    }
    @Published var isFinish: Bool = false 
    @Published var isRunning: Bool = false
    
    private var timer: Timer?
    
    func updateSetting(setting: TimerSetting) {
        let newTimer = CurretTimer(timer: setting, currentIterationCount: 0, timerType: .rest, remainTime: 0)
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
        if currentTimer.remainTime == 0 {
            toggleTimerType()
        }
        isRunning = true
        isFinish = false
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { _ in
            self.progressTimer()
        })
    }
    
    func progressTimer(){
        if currentTimer.remainTime > 0{
            currentTimer.remainTime -= 1
        }else{
            finishSession()
        }
    }
    
    func stopTimer(){
        timer?.invalidate()
        isRunning = false
    }
    
    func resetTimer(){
        currentTimer.remainTime = 0
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
            currentTimer.remainTime = currentTimer.timerSetting.restTime
        case .rest:
            currentTimer.timerType = .focus
            currentTimer.remainTime = currentTimer.timerSetting.focusTime
            currentTimer.currentIterationCount += 1
        }
    }
}
