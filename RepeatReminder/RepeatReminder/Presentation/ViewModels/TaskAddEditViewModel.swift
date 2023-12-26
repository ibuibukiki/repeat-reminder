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
    var db: DB!
    var task: Task
    
    let initialTask = Task(taskId:UUID().uuidString,name:"",deadline:Date(),
                           isLimitNotified:true,isPreNotified:true,
                           firstNotifiedNum:1,firstNotifiedRange:"時間",
                           intervalNotifiedNum:1,intervalNotifiedRange: "時間",
                           isCompleted:false,isDeleted:false)

    init() {
        self.db = DB.shared
        self.task = initialTask
    }
    
    func setTask(task:Task) {
        self.task = task
    }
    
    func addTask() {
        try! db.insertTask(task:task)
    }
    
    func updateTask() {
        try! db.updateTask(task:task)
    }
}
