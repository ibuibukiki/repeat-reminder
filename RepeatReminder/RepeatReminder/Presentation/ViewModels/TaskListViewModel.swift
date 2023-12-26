//
//  TaskListViewModel.swift
//  RepeatReminder
//
//  Created by 吉田郁吹 on 2023/12/09.
//

import Foundation
import SwiftUI

class TaskListViewModel: ObservableObject {
    @Published var model = TaskList(isCompleted:false,isDeleted:false)
    @Published var tasks: [Task] = []
    @Published var todayTasks: [String] = []
    
    init(){
        readTask()
    }
    
    func readTask(){
        self.tasks = model.tasks
        self.todayTasks = model.todayTasks
    }
}
