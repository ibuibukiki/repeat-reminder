//
//  RepeatReminderTests.swift
//  RepeatReminderTests
//
//  Created by 吉田郁吹 on 2023/11/05.
//

import XCTest
@testable import RepeatReminder

final class RepeatReminderTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testInitializedDB() {
        let db = DB.shared
        XCTAssertNotNil(db, "DB instance should not be nil")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
