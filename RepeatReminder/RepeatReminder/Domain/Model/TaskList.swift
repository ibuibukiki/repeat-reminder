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
    
    init(isCompleted:Bool?,isDeleted:Bool?) {
        guard let db = DB.shared else {
            return
        }
        
        do {
            self.tasks = try db.getTasks(isCompleted: isCompleted, isDeleted: isDeleted)
        } catch {
            self.tasks = []
        }
        
        self.todayTasks = getTodayTask()
    }
    
    /// 締め切りが今日中のタスクの名前を取得
    func getTodayTask() -> [String]{
        var nameList: [String] = []
        
        for task in tasks {
            let calendar = Calendar.current
            
            let today = calendar.dateComponents([.year, .month, .day], from: Date())
            let deadline = calendar.dateComponents([.year, .month, .day], from: task.deadline)
            
            if today == deadline {
                nameList.append(task.name)
            }
        }
        
        return nameList
    }
}
