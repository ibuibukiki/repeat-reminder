//
//  NotificationManagerTests.swift
//  RepeatReminderTests
//
//  Created by 吉田郁吹 on 2024/01/06.
//

import Foundation
import XCTest
@testable import RepeatReminder

final class NotificationManagerTests: XCTestCase {
    
    var manager = NotificationManager()
    
    var db: NotificationDB!
    var task1: Task!
    var task2: Task!
    
    override func setUpWithError() throws {
        super.setUp()
        db = NotificationDB.shared
        // 期限の時しか通知しないタスク
        task1 = Task(taskId: UUID().uuidString, name: "Deadline Task", deadline: Date(),
                     isLimitNotified: true, isPreNotified: false,
                     firstNotifiedNum: nil, firstNotifiedRange: nil,
                     intervalNotifiedNum: nil, intervalNotifiedRange: nil,
                     isCompleted: false, isDeleted: false)
        // 期限の前から通知するタスク
        task2 = Task(taskId: UUID().uuidString, name: "Repeat Task", deadline: Date(),
                     isLimitNotified: true, isPreNotified: true,
                     firstNotifiedNum: 2, firstNotifiedRange: "週間",
                     intervalNotifiedNum: 1, intervalNotifiedRange: "週間",
                     isCompleted: false, isDeleted: false)
    }
    
    override func tearDownWithError() throws {
        db = nil
        task1 = nil
        task2 = nil
        super.tearDown()
    }
    
    func testCreateDeadlineNotification() throws {
        let result = manager.createNotification(task: task1)
        let interval = Int(task1.deadline.timeIntervalSinceNow)
        XCTAssertEqual(result.count, 1, "Notification should be one")
        XCTAssertEqual(result[0].taskId, task1.taskId, "Created notification's taskId is correct one")
        XCTAssertEqual(result[0].delay, interval, "Created notification's datetime is correct one")
        XCTAssertTrue(result[0].isLimit, "Created notification is deadline notification")
    }
    
    func testCreateRepeatNotification() throws {
        let interval = Int(task2.deadline.timeIntervalSinceNow)
        let delay1 = interval - 14*60*60*24
        let delay2 = interval - 7*60*60*24
        
        let result = manager.createNotification(task: task2)
        XCTAssertEqual(result.count, 3, "Notification should be three")
        XCTAssertEqual(result[0].delay, delay1, "Created notification's datetime is correct one")
        XCTAssertFalse(result[0].isLimit, "Created notification is not deadline notification")
        XCTAssertEqual(result[1].delay, delay2, "Created notification's datetime is correct one")
        XCTAssertFalse(result[1].isLimit, "Created notification is not deadline notification")
        XCTAssertEqual(result[2].delay, interval, "Created notification's datetime is correct one")
        XCTAssertTrue(result[2].isLimit, "Created notification is deadline notification")
    }
    
    func testCreateMessage() throws {
        let delay0 = 60*50-30
        let message0 = manager.createMessage(delay: delay0)
        XCTAssertEqual(message0, "まであと1時間です")
        
        let delay1 = 60*60-30
        let message1 = manager.createMessage(delay: delay1)
        XCTAssertEqual(message1, "まであと1時間です")
        
        let delay2 = 60*60*12-30
        let message2 = manager.createMessage(delay: delay2)
        XCTAssertEqual(message2, "まであと12時間です")
        
        let delay3 = 60*60*24-30
        let message3 = manager.createMessage(delay: delay3)
        XCTAssertEqual(message3, "まであと24時間です")
        
        let delay4 = 60*60*24*4-30
        let message4 = manager.createMessage(delay: delay4)
        XCTAssertEqual(message4, "まであと4日です")
        
        let delay5 = 60*60*24*7-30
        let message5 = manager.createMessage(delay: delay5)
        XCTAssertEqual(message5, "まであと1週間です")
        
        let delay6 = 60*60*24*8-30
        let message6 = manager.createMessage(delay: delay6)
        XCTAssertEqual(message6, "まであと8日です")
    }
    
    func testUpdateNotificationNoChanged() throws {
        // タスク1の通知を追加
        let result1 = manager.createNotification(task: task1)
        XCTAssertNoThrow(try db.insertNotification(notification: result1[0]), "Insert Notification should be successfull")
        
        var notifications: [AppNotification] = []
        
        // 通知に関係のない変更があった場合
        task1.name = "Updated Deadline Task"
        
        XCTAssertNoThrow(notifications = try! db.getNotifications(taskId: task1.taskId), "Get Notification should be successfull")
        let result2 = manager.mergeNotification(task:task1, notifications:notifications)
        XCTAssertFalse(result2.isNeededDelete, "Notification doesn't need to be deleted")
        XCTAssertEqual(result2.mergedNotifications.count, 0, "Notification doesn't needed to be updated")
    }
    
    func testUpdateNotificationChangedDeadline() throws {
        // タスク1の通知を追加
        let result1 = manager.createNotification(task: task1)
        XCTAssertNoThrow(try db.insertNotification(notification: result1[0]), "Insert Notification should be successfull")
        
        var notifications: [AppNotification] = []
        
        // 通知に関する変更があった場合(通知の個数は変化しない)
        let calendar = Calendar(identifier: .gregorian)
        task1.deadline = calendar.date(byAdding:.day, value:1, to: task1.deadline)!
        let interval = Int(task1.deadline.timeIntervalSinceNow)
        
        XCTAssertNoThrow(notifications = try! db.getNotifications(taskId: task1.taskId), "Get Notification should be successfull")
        let result2 = manager.mergeNotification(task:task1, notifications:notifications)
        XCTAssertFalse(result2.isNeededDelete, "Notification doesn't need to be deleted")
        XCTAssertEqual(result2.mergedNotifications.count, 1, "Notification need to be updated")
        XCTAssertEqual(result2.mergedNotifications[0].delay, interval, "Created notification's datetime is correct one")
    }
    
    func testUpdateNotificationChangedRepeat() throws {
        // タスク1の通知を追加
        let result1 = manager.createNotification(task: task1)
        XCTAssertNoThrow(try db.insertNotification(notification: result1[0]), "Insert Notification should be successfull")
        
        var notifications: [AppNotification] = []
        
        // 通知に関する変更があった場合(通知の個数が変化する)
        task1.isPreNotified = true
        task1.firstNotifiedNum = 2
        task1.firstNotifiedRange = "時間"
        task1.intervalNotifiedNum = 1
        task1.intervalNotifiedRange = "時間"
        
        XCTAssertNoThrow(notifications = try! db.getNotifications(taskId: task1.taskId), "Get Notification should be successfull")
        let result2 = manager.mergeNotification(task:task1, notifications:notifications)
        XCTAssertTrue(result2.isNeededDelete, "Notification need to be deleted")
        XCTAssertEqual(result2.mergedNotifications.count, 3, "Notifications need to be updated")
        
        let calendar = Calendar(identifier: .gregorian)
        
        let datetime1 = calendar.date(byAdding:.hour, value:-2, to: task1.deadline)!
        let datetime2 = calendar.date(byAdding:.hour, value:-1, to: task1.deadline)!
        
        let interval1 = Int(datetime1.timeIntervalSinceNow)
        let interval2 = Int(datetime2.timeIntervalSinceNow)
        let interval3 = Int(task1.deadline.timeIntervalSinceNow)
        
        XCTAssertEqual(result2.mergedNotifications[0].delay, interval1, "Created notification's datetime is correct one")
        XCTAssertEqual(result2.mergedNotifications[1].delay, interval2, "Created notification's datetime is correct one")
        XCTAssertEqual(result2.mergedNotifications[2].delay, interval3, "Created notification's datetime is correct one")
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
