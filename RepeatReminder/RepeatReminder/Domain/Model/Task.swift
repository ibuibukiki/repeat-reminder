//
//  Task.swift
//  RepeatReminder
//
//  Created by 吉田郁吹 on 2023/11/26.
//

import Foundation

enum TaskError: Error {
    case databaseUnavailable
    case insertFailed
    case updateFailed
    case getFailed
    case getNotFound
    case deleteFailed
}

struct Task {
    var taskId: Int
    var name: String
    var deadline: Date
    var isLimitNotified: Bool
    var isPreNotified: Bool
    var firstNotifiedNum: Int?
    var firstNotifiedRange: String?
    var intervalNotifiedNum: Int?
    var intervalNotifiedRange: String?
    var isCompleted: Bool
    var isDeleted: Bool
    
    init(taskId: Int, name: String, deadline: Date, isLimitNotified: Bool, isPreNotified: Bool, firstNotifiedNum: Int?, firstNotifiedRange: String?, intervalNotifiedNum: Int?, intervalNotifiedRange: String?, isCompleted: Bool, isDeleted: Bool) {
        self.taskId = taskId
        self.name = name
        self.deadline = deadline
        self.isLimitNotified = isLimitNotified
        self.isPreNotified = isPreNotified
        self.firstNotifiedNum = firstNotifiedNum
        self.firstNotifiedRange = firstNotifiedRange
        self.intervalNotifiedNum = intervalNotifiedNum
        self.intervalNotifiedRange = intervalNotifiedRange
        self.isCompleted = isCompleted
        self.isDeleted = isDeleted
    }
}
