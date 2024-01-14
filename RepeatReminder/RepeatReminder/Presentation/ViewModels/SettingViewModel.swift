//
//  SettingViewModel.swift
//  RepeatReminder
//
//  Created by 吉田郁吹 on 2023/12/28.
//

import Foundation

class SettingViewModel: ObservableObject {
    
    func deleteCache() {
        guard let db = TaskDB.shared else {
            return
        }
        do {
            let taskList1 = try db.getTasks(isCompleted: true, isDeleted: true)
            for task in taskList1 {
                try! db.deleteTask(taskId: task.taskId)
            }
            let taskList2 = try db.getTasks(isCompleted: true, isDeleted: false)
            for task in taskList2 {
                try! db.deleteTask(taskId: task.taskId)
            }
            let taskList3 = try db.getTasks(isCompleted: false, isDeleted: true)
            for task in taskList3 {
                try! db.deleteTask(taskId: task.taskId)
            }
            return
        } catch {
            return
        }
    }
}
