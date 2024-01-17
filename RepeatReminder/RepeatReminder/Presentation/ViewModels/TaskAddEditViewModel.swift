//
//  TaskAddEditViewModel.swift
//  RepeatReminder
//
//  Created by 吉田郁吹 on 2023/11/14.
//

import Foundation
import SwiftUI

enum TaskAddEditViewModelError: Error {
    case EditTaskNilError
}

class TaskAddEditViewModel: ObservableObject,Identifiable {
    var taskDb: TaskDB!
    var notificationDb: NotificationDB!
    @Published var task: Task
    
    // pickerの情報を管理
    @Published var selectedFirstNum = 1
    @Published var selectedFirstRange = "時間"
    @Published var selectedIntervalNum = 1
    @Published var selectedIntervalRange = "時間"
    
    let manager = NotificationManager()
    let initialTask = Task(taskId:UUID().uuidString,name:"",deadline:Date(),
                           isLimitNotified:true,isPreNotified:true,
                           firstNotifiedNum:1,firstNotifiedRange:"時間",
                           intervalNotifiedNum:1,intervalNotifiedRange: "時間",
                           isCompleted:false,isDeleted:false)

    init() {
        self.taskDb = TaskDB.shared
        self.notificationDb = NotificationDB.shared
        self.task = initialTask
    }
    
    func setTask(task:Task) {
        self.task = task
        if task.isPreNotified {
            selectedFirstNum = task.firstNotifiedNum!
            selectedFirstRange = task.firstNotifiedRange!
            selectedIntervalNum = task.intervalNotifiedNum!
            selectedIntervalRange = task.intervalNotifiedRange!
        }
    }
    
    func setPickerValue() {
        task.firstNotifiedNum = selectedFirstNum
        task.firstNotifiedRange = selectedFirstRange
        task.intervalNotifiedNum = selectedIntervalNum
        task.intervalNotifiedRange = selectedIntervalRange
    }
    
    func addTask() {
        if task.isPreNotified {
            setPickerValue()
        }
        // タスクをデータベースに登録
        try! taskDb.insertTask(task:task)
        // 通知を作成してデータベースに登録
        let notifications = manager.createNotification(task:task)
        for notification in notifications {
            try! notificationDb.insertNotification(notification:notification)
        }
        // 通知をシステムに登録
        manager.sendNotifications(task: task, notifications: notifications)
    }
    
    func updateTask() {
        setPickerValue()
        // タスクをデータベース上で更新
        try! taskDb.updateTask(task:task)
        // 通知関連で変更があるか調べる
        let notifications = try! notificationDb.getNotifications(taskId: task.taskId)
        let result = manager.mergeNotification(task:task, notifications:notifications)
        if result.isNeededDelete {
            // 以前登録した通知の削除が必要な場合、変更前の通知を削除して変更後の通知を追加
            // 削除
            try! notificationDb.deleteNotification(taskId: task.taskId)
            var notificationIds: [String] = []
            for notification in notifications {
                notificationIds.append(notification.notificationId)
            }
            manager.removeNotification(id: notificationIds)
            // 追加
            for notification in result.mergedNotifications {
                try! notificationDb.insertNotification(notification: notification)
            }
            manager.sendNotifications(task: task, notifications: result.mergedNotifications)
        } else {
            // 以前登録した通知の削除が不要な場合、通知を更新
            for notification in result.mergedNotifications {
                try! notificationDb.updateNotification(notification: notification)
            }
            manager.sendNotifications(task: task, notifications: result.mergedNotifications)
        }
    }
    
    func deleteTask() {
        // タスクをデータベース上で更新
        task.isDeleted = true
        try! taskDb.updateTask(task:task)
        // 削除する通知に関する情報を取得してシステムから通知を削除
        let notifications = try! notificationDb.getNotifications(taskId: task.taskId)
        var notificationIds: [String] = []
        for notification in notifications {
            notificationIds.append(notification.notificationId)
        }
        manager.removeNotification(id: notificationIds)
        // 通知をデータベースから削除
        try! notificationDb.deleteNotification(taskId:task.taskId)
    }
}
