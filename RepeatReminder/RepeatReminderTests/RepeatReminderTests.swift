//
//  RepeatReminderTests.swift
//  RepeatReminderTests
//
//  Created by 吉田郁吹 on 2023/11/05.
//

import XCTest
@testable import RepeatReminder

final class RepeatReminderTests: XCTestCase {
    
    var db: DB!
    var task: Task!

    override func setUpWithError() throws {
        super.setUp()
        db = DB.shared
        task = Task(taskId: 1, name: "Test Task", deadline: Date(),
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

    func testInitializedDB() {
        XCTAssertNotNil(db, "DB instance should not be nil")
    }
    
    func testInsertDB() {
        XCTAssertNoThrow(try db.insertTask(task: task), "Insert task should be successfull")
        
        let result = db.getTask(taskId: 1)
        XCTAssertTrue(result.success, "Get task should be successfull")
        XCTAssertEqual(result.task?.name, task.name, "Task name should have the correct name")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
