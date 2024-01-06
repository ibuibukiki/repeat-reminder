//
//  NotificationManager.swift
//  RepeatReminder
//
//  Created by 吉田郁吹 on 2023/12/30.
//

import Foundation
import UserNotifications

final class NotificationManager {
    
    func createNotification(task: Task) -> [AppNotification] {
        var notifications: [AppNotification] = []
        let calendar = Calendar(identifier: .gregorian)
        
        if task.isPreNotified {
            // 最初に通知が来る日時を取得
            var firstDatetime: Date = Date()
            if task.firstNotifiedNum != nil {
                if task.firstNotifiedRange=="時間" {
                    firstDatetime = calendar.date(byAdding:.hour, value:-1*task.firstNotifiedNum!, to: task.deadline)!
                }
                if task.firstNotifiedRange=="日" {
                    firstDatetime = calendar.date(byAdding:.day, value:-1*task.firstNotifiedNum!, to: task.deadline)!
                }
                if task.firstNotifiedRange=="週間" {
                    firstDatetime = calendar.date(byAdding:.weekOfYear, value:-1*task.firstNotifiedNum!, to: task.deadline)!
                }
            }
            // 繰り返し来る通知を作成
            var intervalDatetime = firstDatetime
            if task.intervalNotifiedNum != nil {
                while intervalDatetime < task.deadline {
                    let notification = AppNotification(notificationId:UUID().uuidString,taskId:task.taskId,datetime:intervalDatetime,isLimit:false)
                    notifications.append(notification)
                    if task.intervalNotifiedRange=="時間" {
                        intervalDatetime = calendar.date(byAdding:.hour, value:task.intervalNotifiedNum!, to: intervalDatetime)!
                    }
                    if task.intervalNotifiedRange=="日" {
                        intervalDatetime = calendar.date(byAdding:.day, value:task.intervalNotifiedNum!, to: intervalDatetime)!
                    }
                    if task.intervalNotifiedRange=="週間" {
                        intervalDatetime = calendar.date(byAdding:.weekOfYear, value:task.intervalNotifiedNum!, to: intervalDatetime)!
                    }
                }
            }
        }
        // 締め切り時に来る通知を作成
        if task.isLimitNotified {
            let notification = AppNotification(notificationId:UUID().uuidString,taskId:task.taskId,datetime:task.deadline,isLimit:true)
            notifications.append(notification)
        }
        
        return notifications
    }
    
    /// 通知関連の変更を確認してマージする
    /// - Parameters:
    ///   - task: 対象のタスク
    ///   - notifications: 変更前の通知が入った配列
    /// - Returns: isNeededDelete:  削除が必要か否か, mergedNotifications: マージ後の通知が入った配列 (変更の必要がなければ空の配列が返る)
    func mergeNotification(task: Task, notifications: [AppNotification]) -> (isNeededDelete: Bool, mergedNotifications: [AppNotification]) {
        var updatedNotifications = createNotification(task:task)
        var mergedNotifications: [AppNotification] = []
        if notifications.count == updatedNotifications.count {
            // 通知の数が同じ場合さらに詳細を比較し、必要があれば更新
            let calendar = Calendar(identifier: .gregorian)
            for i in 0 ..< notifications.count {
                if calendar.isDate(notifications[i].datetime, equalTo: updatedNotifications[i].datetime, toGranularity: .second) {
                    if notifications[i].isLimit == updatedNotifications[i].isLimit {
                        continue
                    }
                }
                updatedNotifications[i].notificationId = notifications[i].notificationId
                mergedNotifications.append(updatedNotifications[i])
            }
            return (false, mergedNotifications)
        } else {
            // 通知の数が違う場合、変更前の通知を削除して変更後の通知を追加
            return (true, updatedNotifications)
        }
    }
    
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
