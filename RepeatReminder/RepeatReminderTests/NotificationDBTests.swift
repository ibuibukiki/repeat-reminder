//
//  NotificationDBTests.swift
//  RepeatReminderTests
//
//  Created by 吉田郁吹 on 2024/01/02.
//

import XCTest
@testable import RepeatReminder

final class AppNotificationDBTests: XCTestCase {
    
    var db: NotificationDB!
    let notification = AppNotification(notificationId:UUID().uuidString,taskId:UUID().uuidString)
    
    override func setUpWithError() throws {
        super.setUp()
        db = NotificationDB.shared
    }
    
    override func tearDownWithError() throws {
        db = nil
        super.tearDown()
    }
    
    func testInitializedNotificationDB() {
        XCTAssertNotNil(db, "NotificationDB instance should not be nil")
    }
    
    func testInsertNotifications() {
        XCTAssertNoThrow(try db.insertNotification(notification: notification), "Insert Notification should be successfull")
        
        var result: [AppNotification] = []
        
        XCTAssertNoThrow(result = try! db.getNotifications(taskId: notification.taskId), "Get Notification should be successfull")
        XCTAssertEqual(result.count, 1, "Notification should be one")
        XCTAssertEqual(result[0].notificationId, notification.notificationId, "Notification ID should have the correct ID")
    }
    
    func testGetNotificationNotFound() {
        var result: [AppNotification] = []
        
        XCTAssertNoThrow(result = try! db.getNotifications(taskId: UUID().uuidString), "Get Notification should be successfull")
        XCTAssertEqual(result.count, 0, "Notification should be zero")
    }
    
    func testDeleteNotification() {
        XCTAssertNoThrow(try db.insertNotification(notification: notification), "Insert notification should be successfull")
        
        XCTAssertNoThrow(try db.deleteNotification(notificationId: notification.notificationId), "Delete Notification should be successfull")
    }
    
    func testDeleteNotificationFailed() {
        XCTAssertNoThrow(try db.insertNotification(notification: notification), "Insert notification should be successfull")
        
        XCTAssertThrowsError(try db.deleteNotification(notificationId: UUID().uuidString), "Delete Notification should be failed")
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
