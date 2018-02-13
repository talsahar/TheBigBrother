//
//  GuestHolderSql.swift
//  TheBigShame
//
//  Created by admin on 11/02/2018.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation
class GuestsSql{
    private init(){
        createTable()
    }
    
    static let instance=GuestsSql()
    
    let connection = SqliteConnection.getConnection()
    
    let TABLE_NAME="GuestHolders"
    let ROW_ID="Id"
    let GUEST_NAME="Name"
    let POST_ID="PostId"
    let LAST_UPDATE="LastUpdate"
    func createTable() {
        var errormsg: UnsafeMutablePointer<Int8>? = nil
        
        let result = sqlite3_exec(connection, "CREATE TABLE IF NOT EXISTS " + TABLE_NAME + " ( "
            + ROW_ID + " TEXT PRIMARY KEY, "
            + GUEST_NAME + " TEXT, "
            + POST_ID + " TEXT, "
            + LAST_UPDATE + " DOUBLE)", nil, nil, &errormsg);
        
        if(result != 0){
            Logger.log(message: "couldnt create guest sqlite table", event: LogEvent.e)
            return
        }
        Logger.log(message: "guest sqlite table has been successfully created", event: LogEvent.i)
    }
    
    func insert(holder:GuestHolder){
        var sqlite3_stmt: OpaquePointer? = nil
        let query="INSERT OR REPLACE INTO "+TABLE_NAME+" ("+ROW_ID+", "+GUEST_NAME+","+POST_ID+", "+LAST_UPDATE+") VALUES (?,?,?,?);"
        
        if (sqlite3_prepare_v2(connection,query,-1,&sqlite3_stmt,nil) == SQLITE_OK){
            
            let id=holder.id.cString(using: .utf8)
            let guestName=holder.guest.name?.cString(using: .utf8)
            let postId=holder.postId.cString(using: .utf8)
           
            if holder.lastUpdate == nil {
                holder.lastUpdate = Date()
            }
            let lastupdate=holder.lastUpdate?.toDouble()

            sqlite3_bind_text(sqlite3_stmt, 1, id,-1,nil)
            sqlite3_bind_text(sqlite3_stmt, 2, guestName,-1,nil)
            sqlite3_bind_text(sqlite3_stmt, 3, postId,-1,nil)
            sqlite3_bind_double(sqlite3_stmt, 4, lastupdate!)
            
            if(sqlite3_step(sqlite3_stmt) == SQLITE_DONE){
                Logger.log(message: "GuestHolder has been added to local db", event: LogEvent.i)
            }
            else{
                Logger.log(message: "error on sqlite insert GuestHolder progress", event: LogEvent.e)
            }
        }
        else{
            Logger.log(message: "error on preparing sqlite insert query GuestHolder", event: LogEvent.e)
        }
        sqlite3_finalize(sqlite3_stmt)
    }
    
    func selectAll()->[GuestHolder]{
        var guestList = [GuestHolder]()
        var sqlite3_stmt: OpaquePointer? = nil
        if (sqlite3_prepare_v2(connection,"SELECT * from \(TABLE_NAME);",-1,&sqlite3_stmt,nil) == SQLITE_OK){
            while(sqlite3_step(sqlite3_stmt) == SQLITE_ROW){
                
                let _id =  String(validatingUTF8:sqlite3_column_text(sqlite3_stmt,0))
                let _guestName = String(validatingUTF8:sqlite3_column_text(sqlite3_stmt,1))
                let _postId = String(validatingUTF8:sqlite3_column_text(sqlite3_stmt,2))
                let _lastUpdate =   Date.fromDouble(Double(sqlite3_column_double(sqlite3_stmt,3)))
                
                let guest=GuestHolder(id: _id, postId: _postId!, guest: GuestModel.instance.getByName(name: _guestName!)!,lastupdate:_lastUpdate)
                guestList.append(guest)
                
                Logger.log(message: "guest \(String(describing: _id)) has been loaded from local db",event: LogEvent.i)
            }
        }
        else{
            Logger.log(message: "error on preparing reading from local db",event: LogEvent.e)
            
        }
        sqlite3_finalize(sqlite3_stmt)
        return guestList
    }
    
    func delete(guestHolderid:String){
        var sqlite3_stmt: OpaquePointer? = nil
        let query="DELETE FROM \(TABLE_NAME) where \(ROW_ID)=\(guestHolderid);"
        if sqlite3_prepare_v2(connection, query, -1, &sqlite3_stmt, nil) == SQLITE_OK {
            if sqlite3_step(sqlite3_stmt) == SQLITE_DONE {
                Logger.log(message: "GuestHolder \(guestHolderid) has been deleted from local",event: LogEvent.i)
            } else {
                Logger.log(message: "GuestHolder \(guestHolderid) couldnt be deleted from local",event: LogEvent.e)
            }
        } else {
            Logger.log(message: "couldnt prepare local db delete statement",event: LogEvent.e)
        }
        
        sqlite3_finalize(sqlite3_stmt)
    }

}

