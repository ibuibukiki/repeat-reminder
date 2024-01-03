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
    var task: Task
    var manager = NotificationManager()
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
    }
    
    func addTask() {
        try! taskDb.insertTask(task:task)
        let notifications = manager.createNotification(task:task)
        for notification in notifications {
            try! notificationDb.insertNotification(notification:notification)
        }
    }
    
    func updateTask() {
        try! taskDb.updateTask(task:task)
        
        let notifications = try! notificationDb.getNotifications(taskId: task.taskId)
        let result = manager.mergeNotification(task:task, notifications:notifications)
        if result.isNeededDelete {
            // 以前登録した通知の削除が必要な場合、変更前の通知を削除して変更後の通知を追加
            try! notificationDb.deleteNotification(taskId: task.taskId)
            for notification in result.mergedNotifications {
                try! notificationDb.insertNotification(notification: notification)
            }
        } else {
            // 以前登録した通知の削除が不要な場合、通知を更新
            for notification in result.mergedNotifications {
                try! notificationDb.updateNotification(notification: notification)
            }
        }
    }
    
    func deleteTask() {
        task.isDeleted = true
        try! taskDb.updateTask(task:task)
    }
}
