//
//  Double+Extension.swift
//  WatchFocus
//
//  Created by 방유빈 on 2024/02/13.
//

import Foundation

extension Double {
    func toStringDeadLine() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH : mm까지"
        return dateFormatter.string(from: Date(timeIntervalSince1970: self))
    }
    
    func toPercent() -> Int {
        return Int((self * 100).rounded())
    }
}
