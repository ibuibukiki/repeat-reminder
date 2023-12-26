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
    @Published var isEditing: Bool
    @Published var task: Task
    var db: DB!
    
    let initialTask = Task(taskId:UUID().uuidString,name:"",deadline:Date(),
                           isLimitNotified:true,isPreNotified:true,
                           firstNotifiedNum:1,firstNotifiedRange:"時間",
                           intervalNotifiedNum:1,intervalNotifiedRange: "時間",
                           isCompleted:false,isDeleted:false)
    
    
    /// 追加画面の初期化処理
    init() {
        self.db = DB.shared
        self.isEditing = false
        self.task = initialTask
    }
    
    /// 編集画面の初期化処理
    init(task: Task?) throws {
        self.db = DB.shared
        self.isEditing = true
        guard task != nil else {
            throw TaskAddEditViewModelError.EditTaskNilError
        }
        self.task = task!
    }
    
    func addTask() {
        try! db.insertTask(task:task)
    }
    
    func updateTask() {
        try! db.updateTask(task:task)
    }
}
