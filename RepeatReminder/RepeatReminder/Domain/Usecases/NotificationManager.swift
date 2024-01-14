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
    
    func calcRemainingMessage(deadline: Date, date: Date) -> String {
        var message: String = ""
        let remainingDays = Calendar.current.dateComponents([.day], from: date, to: deadline).day!
        if remainingDays <= 1 {
            let remainingHours = Calendar.current.dateComponents([.hour], from: date, to: deadline).hour!
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
            var message: String = "\(task.name)"
            let deadline = Calendar.current.startOfDay(for: task.deadline)
            if notification.isLimit {
                message = message + "の期限です"
            } else {
                let date = Calendar.current.startOfDay(for: notification.datetime)
                message = message + calcRemainingMessage(deadline: deadline, date: date)
            }
            // 通知を作成
            let content = UNMutableNotificationContent()
            content.body = message
            content.sound = UNNotificationSound.default
            // 通知を登録
            let dateComponent = Calendar.current.dateComponents(in: TimeZone.current, from: notification.datetime)
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: false)
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
