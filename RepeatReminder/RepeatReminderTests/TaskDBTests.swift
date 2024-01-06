//
//  TaskDBTests.swift
//  RepeatReminderTests
//
//  Created by 吉田郁吹 on 2023/11/05.
//

import XCTest
@testable import RepeatReminder

final class TaskDBTests: XCTestCase {
    
    var db: TaskDB!
    var task: Task!

    override func setUpWithError() throws {
        super.setUp()
        db = TaskDB.shared
        task = Task(taskId: UUID().uuidString, name: "Test Task", deadline: Date(),
                        isLimitNotified: true, isPreNotified: false,
                        firstNotifiedNum: nil, firstNotifiedRange: nil,
                        intervalNotifiedNum: nil, intervalNotifiedRange: nil,
                        isCompleted: false, isDeleted: false)
    }

    override func tearDownWithError() throws {
        db = nil
        task = nil
        super.tearDown()
    }

    func testInitializedTaskDB() {
        XCTAssertNotNil(db, "TaskDB instance should not be nil")
    }
    
    func testInsertTask() {
        XCTAssertNoThrow(try db.insertTask(task: task), "Insert task should be successfull")
        
        var result: Task?
        
        XCTAssertNoThrow(result = try? db.getTask(taskId: task.taskId), "Get task should be successfull")
        XCTAssertEqual(result?.name, task.name, "Task name should have the correct name")
    }
    
    func testGetTaskNotFound() {
        var result: Task?
        
        XCTAssertNoThrow(result = try? db.getTask(taskId: UUID().uuidString), "Get task should be successfull")
        XCTAssertNil(result, "Task should be nil")
    }
    
    func testUpdateTask() {
        XCTAssertNoThrow(try db.insertTask(task: task), "Insert task should be successfull")
        
        let taskUpdated = Task(taskId: task.taskId, name: "Test Task Updated", deadline: Date(),
                            isLimitNotified: true, isPreNotified: false,
                            firstNotifiedNum: nil, firstNotifiedRange: nil,
                            intervalNotifiedNum: nil, intervalNotifiedRange: nil,
                            isCompleted: false, isDeleted: false)
        
        XCTAssertNoThrow(try db.updateTask(task: taskUpdated), "Update task should be successfull")
        
        var result: Task?
        
        XCTAssertNoThrow(result = try? db.getTask(taskId: task.taskId), "Get task should be successfull")
        XCTAssertEqual(result?.name, taskUpdated.name, "Task name should have the correct changed name")
    }
    
    func testUpdateTaskFailed() {
        XCTAssertNoThrow(try db.insertTask(task: task), "Insert task should be successfull")
        
        let taskUpdateFailed = Task(taskId: UUID().uuidString, name: "Test Task Updated", deadline: Date(),
                                    isLimitNotified: true, isPreNotified: false,
                                    firstNotifiedNum: nil, firstNotifiedRange: nil,
                                    intervalNotifiedNum: nil, intervalNotifiedRange: nil,
                                    isCompleted: false, isDeleted: false)
        
        XCTAssertThrowsError(try db.updateTask(task: taskUpdateFailed), "Update task should be failed")
    }
    
    func testDeleteTask() {
        XCTAssertNoThrow(try db.insertTask(task: task), "Insert task should be successfull")
        
        XCTAssertNoThrow(try db.deleteTask(taskId: task.taskId), "Delete task should be successfull")
    }
    
    func testDeleteTaskFailed() {
        XCTAssertNoThrow(try db.insertTask(task: task), "Insert task should be successfull")
        
        XCTAssertThrowsError(try db.deleteTask(taskId: UUID().uuidString), "Delete task should be failed")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
