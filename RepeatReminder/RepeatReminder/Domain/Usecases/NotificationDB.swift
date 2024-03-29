//
//  NotificationDB.swift
//  RepeatReminder
//
//  Created by 吉田郁吹 on 2024/01/02.
//

import Foundation
import SQLite3

enum NotificationDatabaseError: Error {
    case openDatabaseFailed(String)
    case createTableFailed(String)
    case insertNotificationFailed(String)
    case updateNotificationFailed(String)
    case noRecordFound
    case getNotificationsFailed(String)
    case deleteNotificationFailed(String)
}

final class NotificationDB{
    static let shared = NotificationDB()
    
    private let dbFile = "NotificationDBVer4.sqlite"
    private var db: OpaquePointer?
    
    private init?() {
        do {
            db = try openDatabase()
            try createTable()
        } catch let error as NotificationDatabaseError {
            print("Database initialization failed: \(error)")
            return nil
        } catch {
            print("An unexpected error occurred: \(error)")
            return nil
        }
    }
    
    private func openDatabase() throws -> OpaquePointer? {
        let fileURL = try! FileManager.default.url(for: .documentDirectory,
                                                   in: .userDomainMask,
                                                   appropriateFor: nil,
                                                   create: false).appendingPathComponent(dbFile)
        
        var db: OpaquePointer? = nil
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            let errorMessage = getDBErrorMessage(db)
            throw NotificationDatabaseError.openDatabaseFailed(errorMessage)
        } else {
            print("Opened connection to database")
            return db
        }
    }
    
    private func createTable() throws {
        let createSql = """
        CREATE TABLE IF NOT EXISTS notifications (
            notification_id TEXT NOT NULL PRIMARY KEY,
            task_id TEXT NOT NULL,
            delay INTEGER NOT NULL,
            is_limit INTEGER NULL
        );
        """
        
        var createStmt: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, (createSql as NSString).utf8String, -1, &createStmt, nil) != SQLITE_OK {
            let errorMessage = getDBErrorMessage(db)
            throw NotificationDatabaseError.createTableFailed(errorMessage)
        }
        
        if sqlite3_step(createStmt) != SQLITE_DONE {
            let errorMessage = getDBErrorMessage(db)
            sqlite3_finalize(createStmt)
            throw NotificationDatabaseError.createTableFailed(errorMessage)
        }
        
        sqlite3_finalize(createStmt)
    }
    
    private func getDBErrorMessage(_ db: OpaquePointer?) -> String {
        if let err = sqlite3_errmsg(db) {
            return String(cString: err)
        } else {
            return ""
        }
    }
    
    func insertNotification(notification: AppNotification) throws {
        let insertSql = """
                        INSERT INTO notifications (
                                notification_id, task_id, delay, is_limit
                            )
                            VALUES
                            (?, ?, ?, ?);
                        """;
        var insertStmt: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, (insertSql as NSString).utf8String, -1, &insertStmt, nil) != SQLITE_OK {
            let errorMessage = getDBErrorMessage(db)
            throw TaskDatabaseError.insertTaskFailed(errorMessage)
        }
        
        sqlite3_bind_text(insertStmt, 1, (notification.notificationId as NSString).utf8String, -1, nil)
        sqlite3_bind_text(insertStmt, 2, (notification.taskId as NSString).utf8String, -1, nil)
        sqlite3_bind_int(insertStmt, 3, Int32(notification.delay))
        sqlite3_bind_int(insertStmt, 4, Int32(notification.isLimit ? 1 : 0))
        
        if sqlite3_step(insertStmt) != SQLITE_DONE {
            let errorMessage = getDBErrorMessage(db)
            sqlite3_finalize(insertStmt)
            throw TaskDatabaseError.insertTaskFailed(errorMessage)
        }
        
        sqlite3_finalize(insertStmt)
    }
    
    func updateNotification(notification: AppNotification) throws {
        // レコードの存在チェック
        let checkSql = "SELECT COUNT(*) FROM notifications WHERE notification_id = ?"
        var checkStmt: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, checkSql, -1, &checkStmt, nil) == SQLITE_OK {
            sqlite3_bind_text(checkStmt, 1, (notification.notificationId as NSString).utf8String, -1, nil)

            if sqlite3_step(checkStmt) == SQLITE_ROW {
                let count = sqlite3_column_int(checkStmt, 0)
                if count == 0 {
                    // レコードが存在しない場合のエラー
                    throw NotificationDatabaseError.noRecordFound
                }
            }
        }
        sqlite3_finalize(checkStmt)
        
        // 更新処理
        let updateSql = """
        UPDATE  notifications
        SET     task_id = ?,
                delay = ?,
                is_limit = ?
        WHERE   notification_id = ?
        """
        var updateStmt: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, (updateSql as NSString).utf8String, -1, &updateStmt, nil) != SQLITE_OK {
            let errorMessage = getDBErrorMessage(db)
            throw NotificationDatabaseError.updateNotificationFailed(errorMessage)
        }
        
        sqlite3_bind_text(updateStmt, 1, (notification.taskId as NSString).utf8String, -1, nil)
        sqlite3_bind_int(updateStmt, 2, Int32(notification.delay))
        sqlite3_bind_int(updateStmt, 3, Int32(notification.isLimit ? 1 : 0))
        
        sqlite3_bind_text(updateStmt, 4, (notification.notificationId as NSString).utf8String, -1, nil)
        
        if sqlite3_step(updateStmt) != SQLITE_DONE {
            let errorMessage = getDBErrorMessage(db)
            sqlite3_finalize(updateStmt)
            throw NotificationDatabaseError.updateNotificationFailed(errorMessage)
        }
        
        sqlite3_finalize(updateStmt)
    }
    
    func getNotifications(taskId: String) throws -> [AppNotification] {
        
        var notifications: [AppNotification] = []
        
        let sql = """
                SELECT  *
                FROM    notifications
                WHERE   task_id = ?;
                """
        
        var stmt: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, (sql as NSString).utf8String, -1, &stmt, nil) != SQLITE_OK {
            let errorMessage = getDBErrorMessage(db)
            throw NotificationDatabaseError.getNotificationsFailed(errorMessage)
        }
        
        sqlite3_bind_text(stmt, 1, (taskId as NSString).utf8String, -1, nil)
        
        while sqlite3_step(stmt) == SQLITE_ROW {
            let notificationId = String(describing: String(cString: sqlite3_column_text(stmt, 0)))
            let taskId = String(describing: String(cString: sqlite3_column_text(stmt, 1)))
            let delay = Int(sqlite3_column_int(stmt, 2))
            let isLimit = sqlite3_column_int(stmt, 3)==1 ? true : false
            
            let notification = AppNotification(notificationId:notificationId,taskId:taskId,delay:delay,isLimit:isLimit)
            
            notifications.append(notification)
        }
        sqlite3_finalize(stmt)
        
        return notifications
    }
    
    func deleteNotification(taskId: String) throws {
        // レコードの存在チェック
        let checkSql = "SELECT COUNT(*) FROM notifications WHERE task_id = ?"
        var checkStmt: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, checkSql, -1, &checkStmt, nil) == SQLITE_OK {
            sqlite3_bind_text(checkStmt, 1, (taskId as NSString).utf8String, -1, nil)

            if sqlite3_step(checkStmt) == SQLITE_ROW {
                let count = sqlite3_column_int(checkStmt, 0)
                if count == 0 {
                    // レコードが存在しない場合のエラー
                    throw NotificationDatabaseError.noRecordFound
                }
            }
        }
        sqlite3_finalize(checkStmt)
        
        // 削除処理
        let deleteSql = "DELETE FROM notifications WHERE task_id = ?;";
        var deleteStmt: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, (deleteSql as NSString).utf8String, -1, &deleteStmt, nil) != SQLITE_OK {
            let errorMessage = getDBErrorMessage(db)
            throw NotificationDatabaseError.deleteNotificationFailed(errorMessage)
        }
        
        sqlite3_bind_text(deleteStmt, 1, (taskId as NSString).utf8String, -1, nil)
        
        if sqlite3_step(deleteStmt) != SQLITE_DONE {
            let errorMessage = getDBErrorMessage(db)
            sqlite3_finalize(deleteStmt)
            throw NotificationDatabaseError.deleteNotificationFailed(errorMessage)
        }

        sqlite3_finalize(deleteStmt)
    }
}
