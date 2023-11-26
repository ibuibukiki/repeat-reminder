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
            sqlite3_bind_int(insertStmt, 6, Int32(task.firstNotifiedNum!))
            sqlite3_bind_text(insertStmt, 7, (task.firstNotifiedRange! as NSString).utf8String, -1, nil)
            sqlite3_bind_int(insertStmt, 8, Int32(task.intervalNotifiedNum!))
            sqlite3_bind_text(insertStmt, 9, (task.intervalNotifiedRange! as NSString).utf8String, -1, nil)
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
    
    func updateTask(task: Task) -> Bool {
        let updateSql = """
        UPDATE  tasks
        SET     name = ?,
                deadline = ?,
                is_limit_notified = ?,
                is_pre_notified = ?,
                first_notified_num = ?,
                first_notified_range = ?,
                interval_notified_num = ?,
                interval_notified_range = ?,
                is_completed = ?,
                is_deleted = ?,
        WHERE   taskid = ?
        """
        var updateStmt: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, (updateSql as NSString).utf8String, -1, &updateStmt, nil) != SQLITE_OK {
            print("db error: \(getDBErrorMessage(db))")
            return false
        }
        
        // Date型をString型に変換
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = formatter.string(from: task.deadline)
        
        sqlite3_bind_text(updateStmt, 1, (task.name as NSString).utf8String, -1, nil)
        sqlite3_bind_text(updateStmt, 2, (dateString as NSString).utf8String, -1, nil)
        sqlite3_bind_int(updateStmt, 3, Int32(task.isLimitNotified ? 1 : 0))
        sqlite3_bind_int(updateStmt, 4, Int32(task.isPreNotified ? 1 : 0))
        
        if task.isPreNotified {
            sqlite3_bind_int(updateStmt, 5, Int32(task.firstNotifiedNum!))
            sqlite3_bind_text(updateStmt, 6, (task.firstNotifiedRange! as NSString).utf8String, -1, nil)
            sqlite3_bind_int(updateStmt, 7, Int32(task.intervalNotifiedNum!))
            sqlite3_bind_text(updateStmt, 8, (task.intervalNotifiedRange! as NSString).utf8String, -1, nil)
        } else {
            sqlite3_bind_null(updateStmt, 5)
            sqlite3_bind_null(updateStmt, 6)
            sqlite3_bind_null(updateStmt, 7)
            sqlite3_bind_null(updateStmt, 8)
        }
        
        sqlite3_bind_int(updateStmt, 9, Int32(task.isCompleted ? 1 : 0))
        sqlite3_bind_int(updateStmt, 10, Int32(task.isDeleted ? 1 : 0))
        sqlite3_bind_int(updateStmt, 11, Int32(task.taskId))
        
        if sqlite3_step(updateStmt) != SQLITE_DONE {
            print("db error: \(getDBErrorMessage(db))")
            sqlite3_finalize(updateStmt)
            return false
        }
        sqlite3_finalize(updateStmt)
        
        return true
    }
    
    func getTask(taskId: Int) -> (success: Bool, errorMessage: String?, task: Task?) {
        
        var task: Task? = nil
        
        let sql = """
                SELECT  *
                FROM    tasks
                WHERE   task_id = ?;
                """
        
        var stmt: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, (sql as NSString).utf8String, -1, &stmt, nil) != SQLITE_OK {
            return (false, "Unexpected error: \(getDBErrorMessage(db)).", task)
        }
        
        sqlite3_bind_int(stmt, 1, Int32(taskId))
        
        // String型をDate型に変換
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.locale = Locale(identifier: "ja_JP")
        
        if sqlite3_step(stmt) == SQLITE_ROW {
            let taskId = Int(sqlite3_column_int(stmt, 0))
            let name = String(describing: String(cString: sqlite3_column_text(stmt, 1)))
            guard let deadline = formatter.date(from: String(cString: sqlite3_column_text(stmt, 2))) else {
                print("value error: deadline null")
                return (false, nil, nil)
            }
            
            let isLimitNotified = sqlite3_column_int(stmt, 3)==1 ? true : false
            let isPreNotified = sqlite3_column_int(stmt, 4)==1 ? true : false
            
            var firstNotifiedNum: Int?
            var firstNotifiedRange: String?
            var intervalNotifiedNum: Int?
            var intervalNotifiedRange: String?
            if isPreNotified {
                firstNotifiedNum = Int(sqlite3_column_int(stmt, 5))
                firstNotifiedRange = String(describing: String(cString: sqlite3_column_text(stmt, 6)))
                intervalNotifiedNum = Int(sqlite3_column_int(stmt, 7))
                intervalNotifiedRange = String(describing: String(cString: sqlite3_column_text(stmt, 8)))
            } else {
                firstNotifiedNum = nil
                firstNotifiedRange = nil
                intervalNotifiedNum = nil
                intervalNotifiedRange = nil
            }
            
            let isCompleted = sqlite3_column_int(stmt, 9)==1 ? true : false
            let isDeleted = sqlite3_column_int(stmt, 10)==1 ? true : false
            
            let task = Task(taskId:taskId, name:name, deadline:deadline, 
                            isLimitNotified:isLimitNotified, isPreNotified:isPreNotified,
                            firstNotifiedNum:firstNotifiedNum,firstNotifiedRange:firstNotifiedRange,
                            intervalNotifiedNum:intervalNotifiedNum, intervalNotifiedRange:intervalNotifiedRange,
                            isCompleted:isCompleted, isDeleted:isDeleted)
        }
        
        sqlite3_finalize(stmt)
        return (true, nil, task)
    }
    
    func deleteTask(taskId: Int) -> Bool {
        let deleteSql = "DELETE FROM tasks WHERE task_id = ?;";
        var deleteStmt: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, (deleteSql as NSString).utf8String, -1, &deleteStmt, nil) != SQLITE_OK {
            print("db error: \(getDBErrorMessage(db))")
            return false
        }
        
        sqlite3_bind_int(deleteStmt, 1, Int32(taskId))
        
        if sqlite3_step(deleteStmt) != SQLITE_DONE {
            print("db error: \(getDBErrorMessage(db))")
            sqlite3_finalize(deleteStmt)
            return false
        }

        sqlite3_finalize(deleteStmt)
        return true
    }

}
