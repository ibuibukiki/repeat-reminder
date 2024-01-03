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
            try! notificationDb.insertNotification(notification: notification)
        }
    }
    
    func updateTask() {
        try! taskDb.updateTask(task:task)
    }
    
    func deleteTask() {
        self.task.isDeleted = true
        try! taskDb.updateTask(task:task)
    }
}
