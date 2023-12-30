//
//  NotificationManager.swift
//  RepeatReminder
//
//  Created by 吉田郁吹 on 2023/12/30.
//

import Foundation
import UserNotifications

final class NotificationManager {
    
    func sendNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Notification Title"
        content.body = "Local Notification Test"
        content.sound = UNNotificationSound.default
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: "notification01", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error: Error?) in
            if error != nil {
                print("send Notification Error: \(String(describing: error))")
            }
        }
    }
}
