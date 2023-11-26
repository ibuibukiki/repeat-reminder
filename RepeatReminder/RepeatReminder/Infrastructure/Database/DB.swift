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
            task_name TEXT NOT NULL,
            is_limit_notified BOOL NOT NULL,
            is_pre_notified BOOL NOT NULL,
            first_notified_num INTEGER NULL,
            first_notified_range TEXT NULL,
            interval_notified_num INTEGER NULL,
            interval_notified_range TEXT NULL,
            is_completed BOOL NOT NULL,
            is_deleted BOOL NOT NULL,
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
}
