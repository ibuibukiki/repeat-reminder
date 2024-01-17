//
//  TaskListViewModel.swift
//  RepeatReminder
//
//  Created by 吉田郁吹 on 2023/12/09.
//

import Foundation
import SwiftUI

class TaskListViewModel: ObservableObject {
    @Published var model = TaskList()
    
    init(){
        readTask()
    }
    
    var tasks: [Task] {
        return model.tasks
    }
    
    var todayTasks: [String] {
        return model.todayTasks
    }
    
    func readTask(){
        model.getTask()
        model.getTodayTask()
    }
    
    func completeTask(task: Task) {
        guard let taskDb = TaskDB.shared else {
            return
        }
        // タスクをデータベース上で更新
        var completedTask = task
        completedTask.isCompleted = true
        try! taskDb.updateTask(task:completedTask)
        // 削除する通知に関する情報を取得してシステムから通知を削除
        guard let notificationDb = NotificationDB.shared else {
            return
        }
        let notifications = try! notificationDb.getNotifications(taskId: task.taskId)
        var notificationIds: [String] = []
        for notification in notifications {
            notificationIds.append(notification.notificationId)
        }
        let manager = NotificationManager()
        manager.removeNotification(id: notificationIds)
        // 通知をデータベースから削除
        try! notificationDb.deleteNotification(taskId: task.taskId)
        readTask()
    }
}
