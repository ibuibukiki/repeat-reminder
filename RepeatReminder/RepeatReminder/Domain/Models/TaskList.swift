//
//  TaskList.swift
//  RepeatReminder
//
//  Created by 吉田郁吹 on 2023/12/09.
//

import Foundation

struct TaskList {
    var tasks: [Task] = []
    var todayTasks: [String] = []
    
    mutating func getTask() {
        guard let db = TaskDB.shared else {
            return
        }
        
        do {
            let taskList = try db.getTasks(isCompleted: false, isDeleted: false)
            /// 締め切り順にソート
            let sortedTasks = taskList.sorted(by: { leftTask, rightTask -> Bool in
                return leftTask.deadline < rightTask.deadline
            })
            self.tasks = sortedTasks
            return
        } catch {
            return
        }
    }
    
    /// 締め切りが今日中のタスクの名前を取得
    mutating func getTodayTask() {
        var nameList: [String] = []
        
        for task in tasks {
            let calendar = Calendar.current
            
            let today = calendar.dateComponents([.year, .month, .day], from: Date())
            let deadline = calendar.dateComponents([.year, .month, .day], from: task.deadline)
            
            if today == deadline {
                nameList.append(task.name)
            }
        }
        
        self.todayTasks = nameList
    }
}
