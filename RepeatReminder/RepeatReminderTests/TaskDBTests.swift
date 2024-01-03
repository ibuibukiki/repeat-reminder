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
    
    func testGetTasks() {
        var result1: [Task] = []
        var result2: [Task] = []
        var result3: [Task] = []
        var result4: [Task] = []
        
        let task1 = Task(taskId: UUID().uuidString, name: "Task1", deadline: Date(),
                        isLimitNotified: true, isPreNotified: false,
                        firstNotifiedNum: nil, firstNotifiedRange: nil,
                        intervalNotifiedNum: nil, intervalNotifiedRange: nil,
                        isCompleted: false, isDeleted: false)
        let task2 = Task(taskId: UUID().uuidString, name: "Task2", deadline: Date(),
                        isLimitNotified: true, isPreNotified: false,
                        firstNotifiedNum: nil, firstNotifiedRange: nil,
                        intervalNotifiedNum: nil, intervalNotifiedRange: nil,
                        isCompleted: true, isDeleted: true)
        
        XCTAssertNoThrow(try db.insertTask(task: task1), "Insert task1 should be successfull")
        XCTAssertNoThrow(try db.insertTask(task: task2), "Insert task2 should be successfull")
        
        XCTAssertNoThrow(result1 = try db.getTasks(isCompleted:nil,isDeleted:nil), "Get all tasks should be successfull")
        XCTAssertEqual(result1.count, 2, "Tasks should be all")
        
        XCTAssertNoThrow(result2 = try db.getTasks(isCompleted:false,isDeleted:false), "Get no completed and no deleted task should be successfull")
        XCTAssertEqual(result2.count, 1, "No completed and No deleted Tasks should be one")
        XCTAssertEqual(result2[0].taskId, task1.taskId, "No completed and No deleted Tasks should have correct id")
        
        XCTAssertNoThrow(result3 = try db.getTasks(isCompleted:true,isDeleted:true), "Get completed and deleted task should be successfull")
        XCTAssertEqual(result3.count, 1, "Completed and Deleted Tasks should be one")
        XCTAssertEqual(result3[0].taskId, task2.taskId, "Completed and Deleted Tasks should have correct id")
        
        XCTAssertNoThrow(result4 = try db.getTasks(isCompleted:true,isDeleted:false), "Get completed and no deleted task should be successfull")
        XCTAssertEqual(result4.count, 0, "Completed and no deleted Tasks should be zero")
        
        XCTAssertNoThrow(try db.deleteTask(taskId: task1.taskId), "Delete task should be successfull")
        XCTAssertNoThrow(try db.deleteTask(taskId: task2.taskId), "Delete task should be successfull")
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
