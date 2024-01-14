//
//  SettingListViewModel.swift
//  RepeatReminder
//
//  Created by 吉田郁吹 on 2023/12/28.
//

import Foundation

class SettingListViewModel: ObservableObject {
    @Published var model = SettingList()
    var notificationDb: NotificationDB!
    var manager = NotificationManager()
    
    init(){
        notificationDb = NotificationDB.shared
        readTask()
    }
    
    var completedTasks: [Task] {
        return model.completedTasks
    }
    
    var deletedTasks: [Task] {
        return model.deletedTasks
    }
    
    func readTask(){
        model.getCompletedTasks()
        model.getDeletedTasks()
    }
    
    func notCompletedTask(task: Task){
        guard let db = TaskDB.shared else {
            return
        }
        // タスクを未完了に変更してデータベースを更新
        var notCompletedTask = task
        notCompletedTask.isCompleted = false
        try! db.updateTask(task:notCompletedTask)
        // 通知を登録
        let notifications = manager.createNotification(task:task)
        for notification in notifications {
            try! notificationDb.insertNotification(notification:notification)
        }
        readTask()
    }
    
    func notDeletedTask(task: Task){
        guard let db = TaskDB.shared else {
            return
        }
        // タスクを復元してデータベースを更新
        var notDeletedTask = task
        notDeletedTask.isDeleted = false
        try! db.updateTask(task:notDeletedTask)
        // 通知を登録
        let notifications = manager.createNotification(task:task)
        for notification in notifications {
            try! notificationDb.insertNotification(notification:notification)
        }
        readTask()
    }
    
    func completelydeletedTask(taskId: String){
        guard let db = TaskDB.shared else {
            return
        }
        try! db.deleteTask(taskId:taskId)
        readTask()
    }
}
