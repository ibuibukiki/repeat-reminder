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
    
    static func insertTask(task: Task) throws {
        guard let db = DB.shared else {
            throw TaskError.databaseUnavailable
        }
        
        if db.insertTask(task: task) {
            print("Insert success")
        } else {
            throw TaskError.insertFailed
        }
    }
    
    static func updateTask(task: Task) throws {
        guard let db = DB.shared else {
            throw TaskError.databaseUnavailable
        }
        
        if db.updateTask(task: task) {
            print("Update success")
        } else {
            throw TaskError.updateFailed
        }
    }
    
    static func getTask(taskId: Int) throws -> Task {
        guard let db = DB.shared else {
            throw TaskError.databaseUnavailable
        }
        
        let (success, errorMessage, task) = db.getTask(taskId: taskId)
        if(success){
            if let task = task {
                print(task)
                return task
            } else {
                print("Task not found")
                throw TaskError.getNotFound
            }
        } else {
            print(errorMessage ?? "Error")
            throw TaskError.getFailed
        }
    }
    
    static func deleteTask(taskId: Int) throws {
        guard let db = DB.shared else {
            throw TaskError.databaseUnavailable
        }
        
        if db.deleteTask(taskId: taskId) {
            print("Delete success")
        } else {
            throw TaskError.deleteFailed
        }
    }
}
