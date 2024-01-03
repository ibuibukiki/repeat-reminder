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
