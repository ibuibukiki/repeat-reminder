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
        var notCompletedTask = task
        notCompletedTask.isCompleted = false
        try! db.updateTask(task:notCompletedTask)
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
        var notDeletedTask = task
        notDeletedTask.isDeleted = false
        try! db.updateTask(task:notDeletedTask)
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
