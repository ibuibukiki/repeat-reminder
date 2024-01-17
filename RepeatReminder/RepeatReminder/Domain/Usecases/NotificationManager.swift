//
//  NotificationManager.swift
//  RepeatReminder
//
//  Created by 吉田郁吹 on 2023/12/30.
//

import Foundation
import UserNotifications

final class NotificationManager {
    let calendar = Calendar(identifier: .gregorian)
    
    func createNotification(task: Task) -> [AppNotification] {
        var notifications: [AppNotification] = []
        
        // 期限までの秒数を取得
        let deadlineDelay = Int(task.deadline.timeIntervalSinceNow)
        
        // 期限を過ぎている場合は通知を作成しない
        guard deadlineDelay > 0 else { return [] }
        
        if task.isPreNotified {
            // 最初に通知が来るまでの秒数を取得
            var firstDelay: Int = 0
            if task.firstNotifiedNum != nil {
                if task.firstNotifiedRange=="時間" {
                    firstDelay = deadlineDelay - task.firstNotifiedNum!*60*60
                }
                if task.firstNotifiedRange=="日" {
                    firstDelay = deadlineDelay - task.firstNotifiedNum!*60*60*24
                }
                if task.firstNotifiedRange=="週間" {
                    firstDelay = deadlineDelay - task.firstNotifiedNum!*60*60*24*7
                }
            }
            // 繰り返し来る通知を作成
            var intervalDelay = firstDelay
            if task.intervalNotifiedNum != nil {
                while intervalDelay < deadlineDelay {
                    let notification = AppNotification(notificationId:UUID().uuidString,taskId:task.taskId,delay:intervalDelay,isLimit:false)
                    // 通知時刻を過ぎていない場合のみ通知を作成
                    if intervalDelay > 0 {
                        notifications.append(notification)
                    }
                    if task.intervalNotifiedRange=="時間" {
                        intervalDelay = intervalDelay + task.intervalNotifiedNum!*60*60
                    }
                    if task.intervalNotifiedRange=="日" {
                        intervalDelay = intervalDelay + task.intervalNotifiedNum!*60*60*24
                    }
                    if task.intervalNotifiedRange=="週間" {
                        intervalDelay = intervalDelay + task.intervalNotifiedNum!*60*60*24*7
                    }
                }
            }
        }
        // 締め切り時に来る通知を作成
        if task.isLimitNotified {
            let notification = AppNotification(notificationId:UUID().uuidString,taskId:task.taskId,delay:deadlineDelay,isLimit:true)
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
            for i in 0 ..< notifications.count {
                if abs(notifications[i].delay - updatedNotifications[i].delay) < 60 {
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
    
    func createMessage(delay: Int) -> String {
        var message: String = ""
        let remainingDays = Int(delay/(60*60*24))
        if remainingDays <= 1 {
            let remainingHours = Int(delay/(60*60))
            message = "まであと\(remainingHours)時間です"
        } else if remainingDays % 7 == 0 {
            let remainingWeeks = Int(remainingDays/7)
            message = "まであと\(remainingWeeks)週間です"
        } else {
            message = "まであと\(remainingDays)日です"
        }
        return message
    }
    
    // 通知の送信設定 (以前設定した通知の変更も可能)
    func sendNotifications(task: Task, notifications: [AppNotification]) {
        for notification in notifications {
            // 通知に載せるメッセージを作成
            var message: String = "タスク \(task.name) "
            if notification.isLimit {
                message = message + "の期限です"
            } else {
                let remaining = Int(task.deadline.timeIntervalSinceNow) - Int(notification.delay)
                message = message + createMessage(delay: remaining)
            }
            print(message)
            // 通知を作成
            let content = UNMutableNotificationContent()
            content.body = message
            content.sound = UNNotificationSound.default
            // 通知を登録
            let interval = TimeInterval(notification.delay)
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: false)
            let request = UNNotificationRequest(identifier: notification.notificationId, content: content, trigger: trigger)
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
