//
//  DB.swift
//  RepeatReminder
//
//  Created by 吉田郁吹 on 2023/11/26.
//

import Foundation
import SQLite3

enum DatabaseError: Error {
    case openDatabaseFailed(String)
    case createTableFailed(String)
    case insertTaskFailed(String)
    case noRecordFound
    case updateTaskFailed(String)
    case getTaskFailed(String, Task?)
    case getTasksFailed(String)
    case deleteTaskFailed(String)
}

final class DB {
    static let shared = DB()
    
    private let dbFile = "DBVer2.sqlite"
    private var db: OpaquePointer?
    
    private init?() {
        do {
            db = try openDatabase()
            try createTable()
        } catch let error as DatabaseError {
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
            throw DatabaseError.openDatabaseFailed(errorMessage)
        } else {
            print("Opened connection to database")
            return db
        }
    }
    
    private func createTable() throws {
        let createSql = """
        CREATE TABLE IF NOT EXISTS tasks (
            task_id TEXT NOT NULL PRIMARY KEY,
            name TEXT NOT NULL,
            deadline TEXT NOT NULL,
            is_limit_notified INTEGER NOT NULL,
            is_pre_notified INTEGER NOT NULL,
            first_notified_num INTEGER NULL,
            first_notified_range TEXT NULL,
            interval_notified_num INTEGER NULL,
            interval_notified_range TEXT NULL,
            is_completed INTEGER NOT NULL,
            is_deleted INTEGER NOT NULL
        );
        """
        
        var createStmt: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, (createSql as NSString).utf8String, -1, &createStmt, nil) != SQLITE_OK {
            let errorMessage = getDBErrorMessage(db)
            throw DatabaseError.createTableFailed(errorMessage)
        }
        
        if sqlite3_step(createStmt) != SQLITE_DONE {
            let errorMessage = getDBErrorMessage(db)
            sqlite3_finalize(createStmt)
            throw DatabaseError.createTableFailed(errorMessage)
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
    
    func insertTask(task: Task) throws {
        let insertSql = """
                        INSERT INTO tasks (
                                task_id, name, deadline, is_limit_notified, is_pre_notified,
                                first_notified_num, first_notified_range,
                                interval_notified_num, interval_notified_range,
                                is_completed, is_deleted
                            )
                            VALUES
                            (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);
                        """;
        var insertStmt: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, (insertSql as NSString).utf8String, -1, &insertStmt, nil) != SQLITE_OK {
            let errorMessage = getDBErrorMessage(db)
            throw DatabaseError.insertTaskFailed(errorMessage)
        }
        
        // Date型をString型に変換
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = formatter.string(from: task.deadline)
        
        sqlite3_bind_text(insertStmt, 1, (task.taskId as NSString).utf8String, -1, nil)
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
            let errorMessage = getDBErrorMessage(db)
            sqlite3_finalize(insertStmt)
            throw DatabaseError.insertTaskFailed(errorMessage)
        }
        
        sqlite3_finalize(insertStmt)
    }
    
    func updateTask(task: Task) throws {
        // レコードの存在チェック
        let checkSql = "SELECT COUNT(*) FROM tasks WHERE task_id = ?"
        var checkStmt: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, checkSql, -1, &checkStmt, nil) == SQLITE_OK {
            sqlite3_bind_text(checkStmt, 1, (task.taskId as NSString).utf8String, -1, nil)

            if sqlite3_step(checkStmt) == SQLITE_ROW {
                let count = sqlite3_column_int(checkStmt, 0)
                if count == 0 {
                    // レコードが存在しない場合のエラー
                    throw DatabaseError.noRecordFound
                }
            }
        }
        sqlite3_finalize(checkStmt)
        
        // 更新処理
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
                is_deleted = ?
        WHERE   task_id = ?
        """
        var updateStmt: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, (updateSql as NSString).utf8String, -1, &updateStmt, nil) != SQLITE_OK {
            let errorMessage = getDBErrorMessage(db)
            throw DatabaseError.updateTaskFailed(errorMessage)
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
        sqlite3_bind_text(updateStmt, 11, (task.taskId as NSString).utf8String, -1, nil)
        
        if sqlite3_step(updateStmt) != SQLITE_DONE {
            let errorMessage = getDBErrorMessage(db)
            sqlite3_finalize(updateStmt)
            throw DatabaseError.updateTaskFailed(errorMessage)
        }
        
        sqlite3_finalize(updateStmt)
    }
    
    func getTask(taskId: String) throws -> Task? {
        
        var task: Task? = nil
        
        let sql = """
                SELECT  *
                FROM    tasks
                WHERE   task_id = ?;
                """
        
        var stmt: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, (sql as NSString).utf8String, -1, &stmt, nil) != SQLITE_OK {
            let errorMessage = getDBErrorMessage(db)
            throw DatabaseError.getTaskFailed(errorMessage, task)
        }
        
        sqlite3_bind_text(stmt, 1, (taskId as NSString).utf8String, -1, nil)
        
        // String型をDate型に変換
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.locale = Locale(identifier: "ja_JP")
        
        if sqlite3_step(stmt) == SQLITE_ROW {
            let name = String(describing: String(cString: sqlite3_column_text(stmt, 1)))
            
            guard let deadline = formatter.date(from: String(cString: sqlite3_column_text(stmt, 2))) else {
                let errorMessage = "value error: deadline null"
                throw DatabaseError.getTaskFailed(errorMessage, nil)
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
            
            task = Task(taskId:taskId, name:name, deadline:deadline,
                        isLimitNotified:isLimitNotified, isPreNotified:isPreNotified,
                        firstNotifiedNum:firstNotifiedNum,firstNotifiedRange:firstNotifiedRange,
                        intervalNotifiedNum:intervalNotifiedNum, intervalNotifiedRange:intervalNotifiedRange,
                        isCompleted:isCompleted, isDeleted:isDeleted)
        }
        
        sqlite3_finalize(stmt)
        return task
    }
    
    /// 該当するタスクをデータベースから取得
    /// - Parameters:
    ///   - isCompleted: bool?  true=完了済みのタスクを取得 / false=未完了のタスクを取得 nilなら両方
    ///   - isDeleted: bool?  true=画面上から削除したタスクを取得 / false=画面上に表示しているタスクを取得 nilなら両方
    /// - Returns: [Task]  該当するタスクが入ったリスト
    func getTasks(isCompleted: Bool?, isDeleted: Bool?) throws -> [Task] {
        var tasks: [Task] = []
        
        let sql = """
                SELECT  *
                FROM    tasks
                WHERE (is_completed = ? OR is_completed = ?) AND (is_deleted = ? OR is_deleted = ?);
                """
        
        var stmt: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, (sql as NSString).utf8String, -1, &stmt, nil) != SQLITE_OK {
            let errorMessage = getDBErrorMessage(db)
            throw DatabaseError.getTasksFailed(errorMessage)
        }
        
        if isCompleted == nil {
            sqlite3_bind_int(stmt, 1, 1)
            sqlite3_bind_int(stmt, 2, 0)
        } else if isCompleted! {
            sqlite3_bind_int(stmt, 1, 1)
            sqlite3_bind_int(stmt, 2, 1)
        } else {
            sqlite3_bind_int(stmt, 1, 0)
            sqlite3_bind_int(stmt, 2, 0)
        }
        
        if isDeleted == nil {
            sqlite3_bind_int(stmt, 3, 1)
            sqlite3_bind_int(stmt, 4, 0)
        } else if isDeleted! {
            sqlite3_bind_int(stmt, 3, 1)
            sqlite3_bind_int(stmt, 4, 1)
        } else {
            sqlite3_bind_int(stmt, 3, 0)
            sqlite3_bind_int(stmt, 4, 0)
        }
        
        // String型をDate型に変換
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.locale = Locale(identifier: "ja_JP")
        
        while sqlite3_step(stmt) == SQLITE_ROW {
            let taskId = String(describing: String(cString: sqlite3_column_text(stmt, 0)))
            let name = String(describing: String(cString: sqlite3_column_text(stmt, 1)))
            
            guard let deadline = formatter.date(from: String(cString: sqlite3_column_text(stmt, 2))) else {
                let errorMessage = "value error: deadline null"
                throw DatabaseError.getTaskFailed(errorMessage, nil)
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
            print(task.taskId)
            tasks.append(task)
        }
        sqlite3_finalize(stmt)
        
        return tasks
    }
    
    func deleteTask(taskId: String) throws {
        // レコードの存在チェック
        let checkSql = "SELECT COUNT(*) FROM tasks WHERE task_id = ?"
        var checkStmt: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, checkSql, -1, &checkStmt, nil) == SQLITE_OK {
            sqlite3_bind_text(checkStmt, 1, (taskId as NSString).utf8String, -1, nil)

            if sqlite3_step(checkStmt) == SQLITE_ROW {
                let count = sqlite3_column_int(checkStmt, 0)
                if count == 0 {
                    // レコードが存在しない場合のエラー
                    throw DatabaseError.noRecordFound
                }
            }
        }
        sqlite3_finalize(checkStmt)
        
        // 削除処理
        let deleteSql = "DELETE FROM tasks WHERE task_id = ?;";
        var deleteStmt: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, (deleteSql as NSString).utf8String, -1, &deleteStmt, nil) != SQLITE_OK {
            let errorMessage = getDBErrorMessage(db)
            throw DatabaseError.deleteTaskFailed(errorMessage)
        }
        
        sqlite3_bind_text(deleteStmt, 1, (taskId as NSString).utf8String, -1, nil)
        
        if sqlite3_step(deleteStmt) != SQLITE_DONE {
            let errorMessage = getDBErrorMessage(db)
            sqlite3_finalize(deleteStmt)
            throw DatabaseError.deleteTaskFailed(errorMessage)
        }

        sqlite3_finalize(deleteStmt)
    }

}
