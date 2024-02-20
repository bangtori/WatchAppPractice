//
//  Int+Extension.swift
//  WatchFocus
//
//  Created by 방유빈 on 2024/02/20.
//

import Foundation

extension Int {
    func timeFormatting() -> String {
        var seconds = self
        let mins = (seconds % 3600) / 60
        let hours = seconds / 3600
        seconds = seconds % 60
        return NSString(format: "%02d:%02d:%02d", hours, mins, seconds) as String
    }
}

