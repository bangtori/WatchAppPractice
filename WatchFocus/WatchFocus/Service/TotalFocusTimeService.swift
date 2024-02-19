//
//  TotalFocusTimeService.swift
//  WatchFocus
//
//  Created by 방유빈 on 2024/02/19.
//

import Foundation

final class TotalFocusTimeService {
    static let shared = TotalFocusTimeService()
    
    func checkRestFocusTime() {
        let lastTime = UserDefaults.standard.double(forKey: UserDefaultsKeys.lastDateSaveTime.rawValue)
        if lastTime == 0 { return } // 저장된 값 없으면 그냥 넘어감
        let now = Date()
        
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: now)
        var components = DateComponents()
        components.year = calendar.component(.year, from: today)
        components.month = calendar.component(.month, from: today)
        components.day = calendar.component(.day, from: today)
        components.hour = 5
        
        if let date = calendar.date(from: components) {
            let nowDouble = now.timeIntervalSince1970
            let fiveAMDouble = date.timeIntervalSince1970
            if lastTime <= fiveAMDouble && fiveAMDouble <= nowDouble {
                UserDefaults.standard.setValue(0, forKey: UserDefaultsKeys.totalFocusTime.rawValue)
            }
        }
    }
}
