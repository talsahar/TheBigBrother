//
//  GuestSql.swift
//  TheBigShame
//
//  Created by admin on 23/02/2018.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation
class GuestSql{
    
    private init(){
        createTable()
    }
    
    static let instance=GuestSql()
    
    let connection = SqliteConnection.getConnection()
    
  
    let TABLE_NAME="Guests"
    let GUEST_ID="Id"
    let GUEST_NAME="Name"
    let GUEST_AGE="Age"
    let GUEST_DESCRITPION="Description"
    let GUEST_GENDER="Gender"
    let GUEST_IMAGE_URL="ImageUrl"
    let LAST_UPDATE="LastUpdate"
    let IS_DELETED="IsDeleted"

    func createTable() {
        var errormsg: UnsafeMutablePointer<Int8>? = nil
        
        let result = sqlite3_exec(connection, "CREATE TABLE IF NOT EXISTS " + TABLE_NAME + " ( "
            + GUEST_ID + " TEXT PRIMARY KEY, "
            + GUEST_NAME + " TEXT, "
            + GUEST_AGE + " INTEGER, "
            + GUEST_DESCRITPION + " TEXT, "
            + GUEST_GENDER + " TEXT, "
            + GUEST_IMAGE_URL + " TEXT, "
            + IS_DELETED + " TEXT, "
            + LAST_UPDATE + " DOUBLE)", nil, nil, &errormsg)
        
        if(result != 0){
            Logger.log(message: "couldnt create guests sqlite table", event: LogEvent.e)
            return
        }
        Logger.log(message: "guests sqlite table has been successfully created", event: LogEvent.i)
    }
    
    func insert(guest:Guest){
        var sqlite3_stmt: OpaquePointer? = nil
        let query="INSERT OR REPLACE INTO "+TABLE_NAME+" ("+GUEST_ID+","+GUEST_NAME+","+GUEST_AGE+", "+GUEST_DESCRITPION+", "+GUEST_GENDER+", "+GUEST_IMAGE_URL+", "+IS_DELETED+", "+LAST_UPDATE+") VALUES (?,?,?,?,?,?,?,?);"
        
        if (sqlite3_prepare_v2(connection,query,-1,&sqlite3_stmt,nil) == SQLITE_OK){
         
            let guest_id = String(guest.hashValue).cString(using: .utf8)
            let guest_name = guest.name.cString(using: .utf8)
            let guest_age = guest.age
            let guest_descrption=guest.description.cString(using: .utf8)
            let guest_gender = String(describing: guest.gender).cString(using: .utf8)
            let guest_imageurl = guest.imageUrl?.cString(using: .utf8)
            let isDeleted = guest.isDeleted.description.cString(using: .utf8)
            let guest_lastupdate = guest.lastUpdate?.toDouble()
            
            sqlite3_bind_text(sqlite3_stmt, 1, guest_id,-1,nil)
            sqlite3_bind_text(sqlite3_stmt, 2, guest_name,-1,nil)
            sqlite3_bind_int(sqlite3_stmt, 3, Int32(guest_age))
            sqlite3_bind_text(sqlite3_stmt, 4, guest_descrption,-1,nil)
            sqlite3_bind_text(sqlite3_stmt, 5, guest_gender,-1,nil)
            sqlite3_bind_text(sqlite3_stmt, 6, guest_imageurl,-1,nil)
            sqlite3_bind_text(sqlite3_stmt, 7, isDeleted,-1,nil)
            sqlite3_bind_double(sqlite3_stmt, 8, guest_lastupdate!)

            
            if(sqlite3_step(sqlite3_stmt) == SQLITE_DONE){
                Logger.log(message: "guest has been added to local db", event: LogEvent.i)
            }
            else{
                Logger.log(message: "guest on sqlite insert progress", event: LogEvent.e)
            }
        }
        else{
            Logger.log(message: "error on preparing sqlite insert query", event: LogEvent.e)
        }
        sqlite3_finalize(sqlite3_stmt)
    }
    
    func selectAll()->[Guest]{
        var guestList = [Guest]()
        var sqlite3_stmt: OpaquePointer? = nil
        if (sqlite3_prepare_v2(connection,"SELECT * from \(TABLE_NAME);",-1,&sqlite3_stmt,nil) == SQLITE_OK){
            while(sqlite3_step(sqlite3_stmt) == SQLITE_ROW){
                
                let guest_id = String(validatingUTF8:sqlite3_column_text(sqlite3_stmt,0))
                let guest_name = String(validatingUTF8:sqlite3_column_text(sqlite3_stmt,1))
                let guest_age = Int(sqlite3_column_int(sqlite3_stmt, 2))
                let guest_description = String(validatingUTF8:sqlite3_column_text(sqlite3_stmt,3))
                let gender = Gender(rawValue: String(validatingUTF8:sqlite3_column_text(sqlite3_stmt,4))!)
                let guest_imageurl = String(validatingUTF8:sqlite3_column_text(sqlite3_stmt,5))
                let isDeleted = String(validatingUTF8:sqlite3_column_text(sqlite3_stmt,6))
                let lastupdate =  Date.fromDouble(Double(sqlite3_column_double(sqlite3_stmt,7)))

                let guest = Guest(id:Int(guest_id!)!,name: guest_name!, gender: gender!, age: guest_age, description: guest_description!, imageUrl: guest_imageurl!,lastUpdate: lastupdate,isDeleted: Bool(isDeleted!)!)
               
                guestList.append(guest)
                
                Logger.log(message: "guest \(guest.name) has been loaded from local cache",event: LogEvent.i)
            }
        }
        else{
            Logger.log(message: "error on preparing reading from local db",event: LogEvent.e)
            
        }
        sqlite3_finalize(sqlite3_stmt)
        return guestList
    }
    
//    func delete(id:String){
//        var sqlite3_stmt: OpaquePointer? = nil
//        let query="DELETE FROM \(TABLE_NAME) where \(GUEST_ID)=\(id);"
//        if sqlite3_prepare_v2(connection, query, -1, &sqlite3_stmt, nil) == SQLITE_OK {
//            if sqlite3_step(sqlite3_stmt) == SQLITE_DONE {
//                Logger.log(message: "guest \(id) has been deleted from local",event: LogEvent.i)
//            } else {
//                Logger.log(message: "guest \(id) couldnt be deleted from local",event: LogEvent.e)
//            }
//        } else {
//            Logger.log(message: "couldnt prepare local db delete statement",event: LogEvent.e)
//        }
//        
//        sqlite3_finalize(sqlite3_stmt)
//    }
    
}
