//
//  TaskListTests.swift
//  RepeatReminderTests
//
//  Created by 吉田郁吹 on 2023/12/09.
//

import XCTest
@testable import RepeatReminder

final class TaskListViewModelTests: XCTestCase {

    var db: TaskDB!
    
    let task1 = Task(taskId: UUID().uuidString, name: "Today Task", deadline: Date(),
                    isLimitNotified: true, isPreNotified: false,
                    firstNotifiedNum: nil, firstNotifiedRange: nil,
                    intervalNotifiedNum: nil, intervalNotifiedRange: nil,
                    isCompleted: false, isDeleted: false)
    let task2 = Task(taskId: UUID().uuidString, name: "Tomorrow Task", deadline: Date(timeIntervalSinceNow: ( 60 * 60 * 24 )),
                    isLimitNotified: true, isPreNotified: false,
                    firstNotifiedNum: nil, firstNotifiedRange: nil,
                    intervalNotifiedNum: nil, intervalNotifiedRange: nil,
                    isCompleted: false, isDeleted: false)
    
    override func setUpWithError() throws {
        super.setUp()
        db = TaskDB.shared
        
        do {
            try db.insertTask(task: task1)
            try db.insertTask(task: task2)
        } catch {
            throw TaskError.insertFailed
        }
    }

    override func tearDownWithError() throws {
        do {
            try db.deleteTask(taskId: task1.taskId)
            try db.deleteTask(taskId: task2.taskId)
        } catch {
            throw TaskError.deleteFailed
        }
        
        db = nil
        super.tearDown()
    }
    
    func testGetTasks() throws {
        let model = TaskList()
        let tasks = model.tasks
        XCTAssertEqual(tasks.count, 2, "Get task should be all")
    }

    func testGetTodayTasks() throws {
        let model = TaskList()
        let todayTasks = model.todayTasks
        XCTAssertEqual(todayTasks.count, 1, "Get task should be one")
        XCTAssertEqual(todayTasks[0], task1.name, "Get task should be today task")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
