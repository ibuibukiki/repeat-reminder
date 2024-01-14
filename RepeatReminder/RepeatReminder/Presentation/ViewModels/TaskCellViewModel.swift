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
    
    private var remainingDays: Int {
        guard (self.task != nil) else {
            return 0
        }
        let deadline = Calendar.current.startOfDay(for: task!.deadline)
        let today = Calendar.current.startOfDay(for: Date())
        let remainingDays = Calendar.current.dateComponents([.day], from: today, to: deadline).day!
        return remainingDays
    }
    
    private var remainingYears: Int {
        guard (self.task != nil) else {
            return 0
        }
        let deadline = Calendar.current.startOfDay(for: task!.deadline)
        let today = Calendar.current.startOfDay(for: Date())
        let remainingDays = Calendar.current.dateComponents([.day], from: today, to: deadline).day!
        return Int(remainingDays/365)
    }
    
    var remainingNumText: Text {
        var remaining = ""
        if remainingDays < 365 {
            remaining = String(abs(remainingDays))
        } else {
            remaining = String(abs(remainingYears))
        }
        if remaining.count < 3 {
            return Text(remaining).font(.largeTitle)
        } else {
            return Text(remaining).font(.title)
        }
    }
    
    var remainingText: String {
        var remaining = ""
        if remainingDays < 365 {
            remaining = "日"
        } else {
            remaining = "年"
        }
        if self.task!.deadline < Date() {
            remaining = remaining + "前"
        } else {
            remaining = remaining + "後"
        }
        return remaining
    }
}
