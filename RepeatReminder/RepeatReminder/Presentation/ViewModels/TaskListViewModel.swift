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
    
    func authorizeNotification() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert,.sound]) { granted, error in
            if error != nil {
                print("Notification Authorization Error: \(String(describing: error))")
            }
            if granted {
                print("Notification Authorized")
            } else {
                print("Notification Not Authorized")
            }
        }
    }
    
    func readTask(){
        model.getTask()
        model.getTodayTask()
    }
    
    func completeTask(task: Task) {
        guard let db = DB.shared else {
            return
        }
        var completedTask = task
        completedTask.isCompleted = true
        try! db.updateTask(task:completedTask)
        readTask()
    }
}
