//
//  DatabaseManager.swift
//  SqlitePowerFunction
//
//  Created by Ganesh Waje on 08/10/19.
//  Copyright © 2019 Ganesh Waje. All rights reserved.
//

import UIKit
import SQLite3

class DatabaseManager {
    
    private static let databaseName = "PowerFunction.db"
    private static let createTableQuery = "CREATE TABLE IF NOT EXISTS PowerTable (id INTEGER UNIQUE PRIMARY KEY AUTOINCREMENT, FirstNumber FLOAT NOT NULL, SecondNumber FLOAT NOT NULL)"
    
    // Get the URL to db store file
    let dbURL: URL
    // The database pointer.
    var db: OpaquePointer?
    
    var readEntryStmt: OpaquePointer?
    var insertEntryStmt: OpaquePointer?

    init?() {
        do {
            do {
                self.dbURL = try FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                    .appendingPathComponent(DatabaseManager.databaseName)
            } catch {
                print("Failed to initialize the database url")
                return nil
            }
            
            try self.openDatabase()
            try self.createTable()
            self.registerPowerFunction()
        } catch {
            print("Failed to initialize the database")
            return nil
        }
    }
    
    func openDatabase() throws {
        if sqlite3_open(dbURL.path, &db) != SQLITE_OK {
            print("Failed to open database")
            throw SQLError(message: "Error while opening database \(dbURL.absoluteString)")
        }
    }
    
    func createTable() throws {
        let ret =  sqlite3_exec(db, DatabaseManager.createTableQuery, nil, nil, nil)
        if (ret != SQLITE_OK) {
            throw SQLError(message: "Unable to create table")
        }
    }
    
    func registerPowerFunction() {
        sqlite3_create_function(self.db, "POWER".cString(using: .utf8), 2, SQLITE_UTF8, nil, { context, argc, arguments in
            let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
            let argv = Array(UnsafeBufferPointer(start: arguments, count: Int(argc)))
            guard let firstNumber = Double(String(cString: UnsafePointer(sqlite3_value_text(argv[0])))),
                let secondNumber = Double(String(cString: UnsafePointer(sqlite3_value_text(argv[1])))) else {
                    return sqlite3_result_text(context, "-1", -1, SQLITE_TRANSIENT)
            }
            let result = pow(firstNumber, secondNumber)
            return sqlite3_result_double(context, result)
        }, nil, nil)
    }
}

class SQLError: Error {
    var message = ""
    var error = SQLITE_ERROR
    init(message: String = "") {
        self.message = message
    }
    init(error: Int32) {
        self.error = error
    }
}
