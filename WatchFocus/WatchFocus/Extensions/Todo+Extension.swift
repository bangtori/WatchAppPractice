//
//  Todo+Extension.swift
//  WatchFocus
//
//  Created by 방유빈 on 2024/04/01.
//

import Foundation
import RealmSwift

extension Todo {
    static var localRealm: Realm {
        let container = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.watchFocus")
        let realmURL = container?.appendingPathComponent("default.realm")
        let config = Realm.Configuration(fileURL: realmURL, schemaVersion: 1)
        return try! Realm(configuration: config)
    }
}

