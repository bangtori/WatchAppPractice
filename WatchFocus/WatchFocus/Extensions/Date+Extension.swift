//
//  Date+Extension.swift
//  WatchFocus
//
//  Created by 방유빈 on 2024/03/13.
//

import Foundation

extension Date {
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YY.MM.dd.EEE"
        return dateFormatter.string(from: self)
    }
}
