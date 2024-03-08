//
//  TimerStore.swift
//  WatchFocus
//
//  Created by 방유빈 on 2024/02/14.
//

import SwiftUI
import ActivityKit

class TimerStore: ObservableObject {
    @Published var currentTimer: CurretTimer = CurretTimer() {
        didSet {
            saveTimerSetting()
        }
    }
    @Published var isFinish: Bool = false {
        willSet {
            if newValue == true {
                stopTimer()
            }
        }
    }
    @Published var isRunning: Bool = false
    @Published var totalFocusTime: Int = UserDefaults.standard.integer(forKey: UserDefaultsKeys.totalFocusTime.rawValue)
    
    private var timer: Timer?
    private var activity: Activity<WatchFocusWidgetAttributes>?
   
    var totalTime: Int {
        return  currentTimer.timerType == .focus ? currentTimer.timerSetting.focusTime : currentTimer.timerSetting.restTime
    }
    
    func updateSetting(setting: TimerSetting) {
        stopTimer()
        let newTimer = CurretTimer(timer: setting, currentIterationCount: 0, timerType: .rest, remainTime: 0)
        currentTimer = newTimer
        
    }
    
    func finishSession() {
        stopLiveActivity()
        if currentTimer.timerType == .rest && currentTimer.currentIterationCount == currentTimer.timerSetting.iterationCount {
            isFinish = true
        } else {
            toggleTimerType()
        }
        sendLocalNotification(newTimerType: currentTimer.timerType)
    }
    
    func startTimer(){
        if currentTimer.remainTime == 0 {
            toggleTimerType()
        } else {
            startLiveActivity()
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
            if activity == nil {
                startLiveActivity()
            }
            let newState = WatchFocusWidgetAttributes.ContentState(progress: Double(currentTimer.remainTime) / Double(totalTime), remainTime: currentTimer.remainTime)
            let newContent = ActivityContent(state: newState, staleDate: nil, relevanceScore: 1.0)
            Task { [weak self] in
                guard let self = self else { return }
                await activity?.update(newContent)
            }
            
            if currentTimer.timerType == .focus {
                totalFocusTime += 1
                saveTotalFocusUserDefaults()
            }
        }else{
            finishSession()
        }
    }
    
    func stopTimer(){
        timer?.invalidate()
        isRunning = false
        saveTotalFocusUserDefaults()
        stopLiveActivity()
    }
    
    func resetTimer(){
        stopLiveActivity()
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
    
    private func startLiveActivity() {
        if !ActivityAuthorizationInfo().areActivitiesEnabled {
            return
        }
        let attributes = WatchFocusWidgetAttributes(totalTime: totalTime, timerType: currentTimer.timerType, iterationCount: currentTimer.currentIterationCount)
        let state = WatchFocusWidgetAttributes.ContentState(progress: Double(currentTimer.remainTime) / Double(totalTime), remainTime: currentTimer.remainTime)
        let content = ActivityContent(state: state, staleDate: nil, relevanceScore: 1.0)
        
        do {
            activity = try Activity<WatchFocusWidgetAttributes>.request(attributes: attributes, content: content)
        } catch {
            print(error)
        }
    }
    
    private func stopLiveActivity() {
        let newState = WatchFocusWidgetAttributes.ContentState(progress: Double(currentTimer.remainTime) / Double(totalTime), remainTime: currentTimer.remainTime)
        let newContent = ActivityContent(state: newState, staleDate: nil, relevanceScore: 1.0)
        Task { [weak self] in
            guard let self = self else { return }
            await activity?.end(newContent, dismissalPolicy: .immediate)
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
        
        startLiveActivity()
    }
    
    private func saveTotalFocusUserDefaults() {
        TotalFocusTimeService.shared.checkRestFocusTime()
        UserDefaults.standard.setValue(totalFocusTime, forKey: UserDefaultsKeys.totalFocusTime.rawValue)
        UserDefaults.standard.setValue(Date().timeIntervalSince1970, forKey: UserDefaultsKeys.lastDateSaveTime.rawValue)
    }
    
    private func sendLocalNotification(newTimerType: TimerType) {
        let content = UNMutableNotificationContent()
        content.title = "Session 완료"
        switch newTimerType {
        case .focus:
            content.body = "휴식 시간이 끝났습니다. 다시 집중합시다."
        case .rest:
            content.body = "집중 시간이 끝났습니다. 약간의 휴식 후 다시 시작해요."
        }

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("로컬 알림 스케줄링 오류:", error)
            } else {
                print("로컬 알림이 성공적으로 스케줄링되었습니다.")
            }
        }
        
    }
}
