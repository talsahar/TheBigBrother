//
//  CommentSql.swift
//  TheBigShame
//
//  Created by admin on 09/02/2018.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation
class CommentSql{
    
    private init(){}
    
    static let instance=CommentSql()
    
    let connection = SqliteConnection.getConnection()
    let TABLE_NAME="Comments"
    let COMMENT_ID="Id"
    let POST_ID="PostId"
    let AUTHOR_ID="AuthorId"
    let DATE="Date"
    let TITLE="Title"
    let CONTENT="Content"
    let ISLIKE="IsLike"
    let LAST_UPDATE="LastUpdate"
    
    func createTable() {
        var errormsg: UnsafeMutablePointer<Int8>? = nil
        
        let result = sqlite3_exec(connection, "CREATE TABLE IF NOT EXISTS " + TABLE_NAME + " ( "
            + COMMENT_ID + " TEXT PRIMARY KEY, "
            + POST_ID + " TEXT, "
            + AUTHOR_ID + " TEXT, "
            + DATE + " DOUBLE, "
            + TITLE + " TEXT, "
            + CONTENT + " TEXT, "
            + ISLIKE + " TEXT, "
            + LAST_UPDATE + " DOUBLE)", nil, nil, &errormsg);
        
        if(result != 0){
            Logger.log(message: "couldnt create comment sqlite table", event: LogEvent.e)
            return
        }
        Logger.log(message: "comment sqlite table has been successfully created", event: LogEvent.i)
    }
    
    func insert(comment:Comment){
        var sqlite3_stmt: OpaquePointer? = nil
        let query="INSERT OR REPLACE INTO "+TABLE_NAME+" ("+COMMENT_ID+", "+POST_ID+","+AUTHOR_ID+", "+DATE+", "+TITLE+", "+CONTENT+", "+ISLIKE+", "+LAST_UPDATE+") VALUES (?,?,?,?,?,?,?,?);"
        
        if (sqlite3_prepare_v2(connection,query,-1,&sqlite3_stmt,nil) == SQLITE_OK){
            
            let commentId=comment.commentId?.cString(using: .utf8)
            let postId=comment.postId?.cString(using: .utf8)
            let commentAuthor=comment.authorId?.cString(using: .utf8)
            let commentDate=comment.date?.toDouble()
            let commentTitle=comment.title?.cString(using: .utf8)
            let commentContent=comment.content?.cString(using: .utf8)
            let isLike=comment.isLike?.description.cString(using: .utf8)
            let lastUpdate=comment.lastUpdate?.toDouble()

            sqlite3_bind_text(sqlite3_stmt, 1, commentId,-1,nil)
            sqlite3_bind_text(sqlite3_stmt, 2, postId,-1,nil)
            sqlite3_bind_text(sqlite3_stmt, 3, commentAuthor,-1,nil)
            sqlite3_bind_double(sqlite3_stmt, 4, commentDate!)
            sqlite3_bind_text(sqlite3_stmt, 5, commentTitle,-1,nil)
            sqlite3_bind_text(sqlite3_stmt, 6, commentContent,-1,nil)
            sqlite3_bind_text(sqlite3_stmt, 7, isLike,-1,nil)
            sqlite3_bind_double(sqlite3_stmt, 8, lastUpdate!)
         
            if(sqlite3_step(sqlite3_stmt) == SQLITE_DONE){
                Logger.log(message: "comment has been added to local db", event: LogEvent.i)
            }
            else{
                Logger.log(message: "error on comment sqlite insert progress", event: LogEvent.e)
            }
        }
        else{
            Logger.log(message: "error on comment preparing sqlite insert query", event: LogEvent.e)
        }
        sqlite3_finalize(sqlite3_stmt)
    }
    
    func delete(id:String){
        var sqlite3_stmt: OpaquePointer? = nil
        let query="DELETE FROM \(TABLE_NAME) where \(COMMENT_ID)=\(id);"
        if sqlite3_prepare_v2(connection, query, -1, &sqlite3_stmt, nil) == SQLITE_OK {
            if sqlite3_step(sqlite3_stmt) == SQLITE_DONE {
                Logger.log(message: "comment \(id) has been deleted from local",event: LogEvent.i)
            } else {
                Logger.log(message: "comment \(id) couldnt be deleted from local",event: LogEvent.e)
            }
        } else {
            Logger.log(message: "couldnt prepare local db delete statement",event: LogEvent.e)
        }
        
        sqlite3_finalize(sqlite3_stmt)
    }
    
}
