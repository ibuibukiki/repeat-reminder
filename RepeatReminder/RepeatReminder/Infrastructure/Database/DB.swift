//
//  DB.swift
//  RepeatReminder
//
//  Created by 吉田郁吹 on 2023/11/26.
//

import Foundation
import SQLite3

final class DB {
    static let shared = DB()
    
    private let dbFile = "DBVer1.sqlite"
    private var db: OpaquePointer?
    
    private init() {
        db = openDatabase()
        if !createTable() {
            print("Failed to create table")
        }
    }
    
    private func openDatabase() -> OpaquePointer? {
        let fileURL = try! FileManager.default.url(for: .documentDirectory,
                                                   in: .userDomainMask,
                                                   appropriateFor: nil,
                                                   create: false).appendingPathComponent(dbFile)
        
        var db: OpaquePointer? = nil
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("Failed to open database")
            return nil
        }
        else {
            print("Opened connection to database")
            return db
        }
    }
    
    private func createTable() -> Bool {
        let createSql = """
        CREATE TABLE IF NOT EXISTS tasks (
            task_id INTEGER NOT NULL PRIMARY KEY,
            name TEXT NOT NULL,
            deadline TEXT NOT NULL,
            is_limit_notified INTEGER NOT NULL,
            is_pre_notified INTEGER NOT NULL,
            first_notified_num INTEGER NULL,
            first_notified_range TEXT NULL,
            interval_notified_num INTEGER NULL,
            interval_notified_range TEXT NULL,
            is_completed INTEGER NOT NULL,
            is_deleted INTEGER NOT NULL,
        );
        """
        
        var createStmt: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, (createSql as NSString).utf8String, -1, &createStmt, nil) != SQLITE_OK {
            print("db error: \(getDBErrorMessage(db))")
            return false
        }
        
        if sqlite3_step(createStmt) != SQLITE_DONE {
            print("db error: \(getDBErrorMessage(db))")
            sqlite3_finalize(createStmt)
            return false
        }
        
        sqlite3_finalize(createStmt)
        return true
    }
    
    private func getDBErrorMessage(_ db: OpaquePointer?) -> String {
        if let err = sqlite3_errmsg(db) {
            return String(cString: err)
        } else {
            return ""
        }
    }
    
    func insertTask(task: Task) -> Bool {
        let insertSql = """
                        INSERT INTO tasks (
                                task_id, name, deadline, is_limit_notified, is_pre_notified,
                                first_notified_num, first_notified_range,
                                interval_notified_num, interval_notified_range,
                                is_completed, is_deleted,
                            )
                            VALUES
                            (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);
                        """;
        var insertStmt: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, (insertSql as NSString).utf8String, -1, &insertStmt, nil) != SQLITE_OK {
            print("db error: \(getDBErrorMessage(db))")
            return false
        }
        
        // Date型をString型に変換
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = formatter.string(from: task.deadline)
        
        sqlite3_bind_int(insertStmt, 1, Int32(task.taskId))
        sqlite3_bind_text(insertStmt, 2, (task.name as NSString).utf8String, -1, nil)
        sqlite3_bind_text(insertStmt, 3, (dateString as NSString).utf8String, -1, nil)
        sqlite3_bind_int(insertStmt, 4, Int32(task.isLimitNotified ? 1 : 0))
        sqlite3_bind_int(insertStmt, 5, Int32(task.isPreNotified ? 1 : 0))
        
        if task.isPreNotified {
            sqlite3_bind_int(insertStmt, 6, Int32(task.firstNotifiedNum))
            sqlite3_bind_text(insertStmt, 7, (task.firstNotifiedRange as NSString).utf8String, -1, nil)
            sqlite3_bind_int(insertStmt, 8, Int32(task.intervalNotifiedNum))
            sqlite3_bind_text(insertStmt, 9, (task.intervalNotifiedRange as NSString).utf8String, -1, nil)
        } else {
            sqlite3_bind_null(insertStmt, 6)
            sqlite3_bind_null(insertStmt, 7)
            sqlite3_bind_null(insertStmt, 8)
            sqlite3_bind_null(insertStmt, 9)
        }
        
        sqlite3_bind_int(insertStmt, 10, Int32(task.isCompleted ? 1 : 0))
        sqlite3_bind_int(insertStmt, 11, Int32(task.isDeleted ? 1 : 0))
        
        if sqlite3_step(insertStmt) != SQLITE_DONE {
            print("db error: \(getDBErrorMessage(db))")
            sqlite3_finalize(insertStmt)
            return false
        }
        sqlite3_finalize(insertStmt)
        
        return true
    }
}
