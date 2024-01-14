//
//  SettingList.swift
//  RepeatReminder
//
//  Created by 吉田郁吹 on 2023/12/28.
//

import Foundation

struct SettingList {
    var completedTasks: [Task] = []
    var deletedTasks: [Task] = []
    
    mutating func getCompletedTasks() {
        guard let db = TaskDB.shared else {
            return
        }
        
        do {
            let taskList = try db.getTasks(isCompleted: true, isDeleted: nil)
            /// 締め切り順にソート
            let sortedTasks = taskList.sorted(by: { leftTask, rightTask -> Bool in
                return leftTask.deadline < rightTask.deadline
            })
            return self.completedTasks = sortedTasks
        } catch {
            return
        }
    }
    
    mutating func getDeletedTasks() {
        guard let db = TaskDB.shared else {
            return
        }
        
        do {
            let taskList = try db.getTasks(isCompleted: nil, isDeleted: true)
            /// 締め切り順にソート
            let sortedTasks = taskList.sorted(by: { leftTask, rightTask -> Bool in
                return leftTask.deadline < rightTask.deadline
            })
            return self.deletedTasks = sortedTasks
        } catch {
            return
        }
    }
}
