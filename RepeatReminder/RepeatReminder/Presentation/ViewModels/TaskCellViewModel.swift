//
//  TaskCellViewModel.swift
//  RepeatReminder
//
//  Created by 吉田郁吹 on 2023/12/28.
//

import Foundation
import SwiftUI

class TaskCellViewModel: ObservableObject {
    var task: Task?
    
    func setTask(task:Task){
        self.task = task
    }
    
    var name: String {
        guard (self.task != nil) else {
            return ""
        }
        return task!.name
    }
    
    var deadline: String {
        guard (self.task != nil) else {
            return ""
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "MM月dd日 HH:mm"
        let dateString = formatter.string(from: task!.deadline)
        return dateString
    }
    
    var remainingDays: String {
        guard (self.task != nil) else {
            return ""
        }
        let deadline = Calendar.current.startOfDay(for: task!.deadline)
        let today = Calendar.current.startOfDay(for: Date())
        let remainingDays = Calendar.current.dateComponents([.day], from: today, to: deadline).day!
        return String(remainingDays)
    }
}
