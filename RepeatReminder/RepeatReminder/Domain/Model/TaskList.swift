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
    
    mutating func getTask(isCompleted:Bool?,isDeleted:Bool?) {
        guard let db = DB.shared else {
            return
        }
        
        do {
            self.tasks = try db.getTasks(isCompleted: isCompleted, isDeleted: isDeleted)
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
