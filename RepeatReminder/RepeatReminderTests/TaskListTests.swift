//
//  TaskListTests.swift
//  RepeatReminderTests
//
//  Created by 吉田郁吹 on 2023/12/09.
//

import XCTest
@testable import RepeatReminder

final class TaskListViewModelTests: XCTestCase {

    var db: DB!
    
    let task1 = Task(taskId: 1, name: "Today Task", deadline: Date(),
                    isLimitNotified: true, isPreNotified: false,
                    firstNotifiedNum: nil, firstNotifiedRange: nil,
                    intervalNotifiedNum: nil, intervalNotifiedRange: nil,
                    isCompleted: false, isDeleted: false)
    let task2 = Task(taskId: 2, name: "Tomorrow Task", deadline: Date(timeIntervalSinceNow: ( 60 * 60 * 24 )),
                    isLimitNotified: true, isPreNotified: false,
                    firstNotifiedNum: nil, firstNotifiedRange: nil,
                    intervalNotifiedNum: nil, intervalNotifiedRange: nil,
                    isCompleted: false, isDeleted: false)
    
    override func setUpWithError() throws {
        super.setUp()
        db = DB.shared
        
        do {
            try db.insertTask(task: task1)
            try db.insertTask(task: task2)
        } catch {
            throw TaskError.insertFailed
        }
    }

    override func tearDownWithError() throws {
        do {
            try db.deleteTask(taskId: 1)
            try db.deleteTask(taskId: 2)
        } catch {
            throw TaskError.deleteFailed
        }
        
        db = nil
        super.tearDown()
    }
    
    func testGetTasks() throws {
        let model = TaskList(isCompleted:false,isDeleted:false)
        let tasks = model.tasks
        XCTAssertEqual(tasks.count, 2, "Get task should be all")
    }

    func testGetTodayTasks() throws {
        let model = TaskList(isCompleted:false,isDeleted:false)
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
