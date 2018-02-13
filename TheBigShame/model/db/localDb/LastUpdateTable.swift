//
//  LastUpdateTable.swift
//  TheBigShame
//
//  Created by admin on 09/02/2018.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation
class LastUpdateTable{
    
    static let instnace = LastUpdateTable()
    
    let TABLE_NAME = "LastUpdate"
    let NAME = "Name"
    let DATE = "Date"
    
    private init(){
        createTable(database: SqliteConnection.getConnection())
    }
    
    func createTable(database:OpaquePointer?){
        var errormsg: UnsafeMutablePointer<Int8>? = nil
        
        let result = sqlite3_exec(database, "CREATE TABLE IF NOT EXISTS " + TABLE_NAME + " ( "
            + NAME + " TEXT PRIMARY KEY, "
            + DATE + " DOUBLE)", nil, nil, &errormsg);
        if(result != 0){
            Logger.log(message: "error creating last update table", event: LogEvent.e)
        }
        else{
            Logger.log(message: "last update table has been successfully created", event: LogEvent.i)

        }
    }
    
    func setLastUpdate(tableName:String, lastUpdate:Date){
        var sqlite3_stmt: OpaquePointer? = nil
        let db=SqliteConnection.getConnection()
        if (sqlite3_prepare_v2(db,"INSERT OR REPLACE INTO "
            + TABLE_NAME + "("
            + NAME + ","
            + DATE + ") VALUES (?,?);",-1, &sqlite3_stmt,nil) == SQLITE_OK){
            
            let name = tableName.cString(using: .utf8)
            let date = lastUpdate.toDouble()
            sqlite3_bind_text(sqlite3_stmt, 1, name,-1,nil);
            sqlite3_bind_double(sqlite3_stmt, 2, date);
            
            if(sqlite3_step(sqlite3_stmt) == SQLITE_DONE){
                Logger.log(message: "LastUpdateTable update: (\(tableName),\(lastUpdate))", event: LogEvent.i)
            }
            else{
                Logger.log(message: "error updating lastUpdateTable update: (\(tableName),\(lastUpdate))", event: LogEvent.e)
            }
        }
        sqlite3_finalize(sqlite3_stmt)
    }
    
    func getLastUpdate(tableName:String)->Date?{
        var uDate:Date?
        let db=SqliteConnection.getConnection()
        var sqlite3_stmt: OpaquePointer? = nil
        if (sqlite3_prepare_v2(db,"SELECT * from " + TABLE_NAME + " where " + NAME + " = ?;",-1,&sqlite3_stmt,nil) == SQLITE_OK){
            let name = tableName.cString(using: .utf8)
            sqlite3_bind_text(sqlite3_stmt, 1, name,-1,nil);
            
            if(sqlite3_step(sqlite3_stmt) == SQLITE_ROW){
                let date = Double(sqlite3_column_double(sqlite3_stmt, 1))
                uDate = Date.fromDouble(date)
            }
        }
        sqlite3_finalize(sqlite3_stmt)
        return uDate
    }
    
    
}

