//
//  AppDelegate.swift
//  WatchFocus
//
//  Created by 방유빈 on 2024/02/22.
//

import Foundation
import UIKit
import UserNotifications
import RealmSwift

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        UNUserNotificationCenter.current().delegate = self
        
        let notificationAuthOptions = UNAuthorizationOptions(arrayLiteral: [.alert, .badge, .sound])
        UNUserNotificationCenter.current().requestAuthorization(options: notificationAuthOptions) { success, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
        
        let defaultRealm = Realm.Configuration.defaultConfiguration.fileURL!
            let container = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.watchFocus")
            let realmURL = container?.appendingPathComponent("default.realm")
            var config: Realm.Configuration!

            // Checking the old realm config is exist
            if FileManager.default.fileExists(atPath: defaultRealm.path) {
                do {
                    _ = try FileManager.default.replaceItemAt(realmURL!, withItemAt: defaultRealm)
                   config = Realm.Configuration(fileURL: realmURL, schemaVersion: 1)
                } catch {
                   print("Error info: \(error)")
                }
            } else {
                 config = Realm.Configuration(fileURL: realmURL, schemaVersion: 1)
            }

            Realm.Configuration.defaultConfiguration = config

        return true
    }
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.list, .banner, .sound])
    }
}
