//
//  DatabaseManager+PoweFunction.swift
//  SqlitePowerFunction
//
//  Created by Ganesh Waje on 08/10/19.
//  Copyright © 2019 Ganesh Waje. All rights reserved.
//

import UIKit
import SQLite3

extension DatabaseManager {

    func findPower(firstNumber: Double, secondNumber: Double) throws -> Double {
        // ensure statements are created on first usage if nil
        guard self.prepareReadEntryStmt(firstNumber: firstNumber, secondNumber: secondNumber) == SQLITE_OK else { throw SQLError(message: "Error in prepareReadEntryStmt") }
        
        defer {
            // reset the prepared statement on exit.
            sqlite3_reset(self.readEntryStmt)
            self.readEntryStmt = nil
        }
        
        //executing the query to read value
        if sqlite3_step(readEntryStmt) != SQLITE_ROW {
            throw SQLError(message: "Error in executing read statement")
        }
        
        return sqlite3_column_double(readEntryStmt, 0)
    }
    
    func prepareReadEntryStmt(firstNumber: Double, secondNumber: Double) -> Int32 {
        guard readEntryStmt == nil else { return SQLITE_OK }
        let sql = "SELECT POWER (\(firstNumber), \(secondNumber))"

        let r = sqlite3_prepare(db, sql, -1, &readEntryStmt, nil)
        if  r != SQLITE_OK {
            print("power function failed")
        }
        return r
    }
}
