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
        model.getTask(isCompleted: false, isDeleted: false)
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
