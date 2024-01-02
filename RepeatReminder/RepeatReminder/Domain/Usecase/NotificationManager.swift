//
//  NotificationManager.swift
//  RepeatReminder
//
//  Created by 吉田郁吹 on 2023/12/30.
//

import Foundation
import UserNotifications

final class NotificationManager {
    
    /// 通知の送信設定 (以前設定した通知の変更も可能)
    /// - Parameters:
    ///   - id: 送信する通知IDの配列
    ///   - title: 通知に表示するテキストの配列
    ///   - date: 送信する日時
    func sendNotification(id: [String], title: [String], date:[DateComponents]) {
        for i in 0 ..< id.count {
            let content = UNMutableNotificationContent()
            content.body = title[i]
            content.sound = UNNotificationSound.default
        
            let trigger = UNCalendarNotificationTrigger(dateMatching: date[i], repeats: false)
            
            let request = UNNotificationRequest(identifier: id[i], content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request) { (error: Error?) in
                if error != nil {
                    print("send Notification Error: \(String(describing: error))")
                }
            }
        }
    }
    
    /// 通知設定の削除
    /// - Parameters:
    ///   - id: 削除する通知IDの配列
    func removeNotification(id: [String]) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: id)
    }
}
