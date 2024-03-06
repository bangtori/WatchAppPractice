//
//  UserDefaults+Extension.swift
//  WatchFocus
//
//  Created by 방유빈 on 2024/03/05.
//

import Foundation

extension UserDefaults {
    static var groupShared: UserDefaults {
        let groupID = "group.watchFocus"
        return UserDefaults(suiteName: groupID)!
    }
}
