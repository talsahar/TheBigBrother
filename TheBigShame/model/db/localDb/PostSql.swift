//
//  PostSql.swift
//  TheBigShame
//
//  Created by admin on 09/02/2018.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation
class PostSql{
    
    private init(){
        createTable()
    }
    
    static let instance=PostSql()
    
    let connection = SqliteConnection.getConnection()
    
    let TABLE_NAME="Posts"
    let POST_ID="Id"
    let POST_DATE="Date"
    let POST_TITLE="Title"
    let POST_USER_ID="UserId"
    let POST_CONTENT="Content"
    let POST_IMAGE_URL="ImageUrl"
    let POST_VIDEO_URL="VideoUrl"
    let LAST_UPDATE="LastUpdate"
    func createTable() {
        var errormsg: UnsafeMutablePointer<Int8>? = nil
        
        let result = sqlite3_exec(connection, "CREATE TABLE IF NOT EXISTS " + TABLE_NAME + " ( "
            + POST_ID + " TEXT PRIMARY KEY, "
            + POST_DATE + " DOUBLE, "
            + POST_TITLE + " TEXT, "
            + POST_USER_ID + " TEXT, "
            + POST_CONTENT + " TEXT, "
            + POST_IMAGE_URL + " TEXT, "
            + POST_VIDEO_URL + " TEXT, "
            + LAST_UPDATE + " DOUBLE)", nil, nil, &errormsg);
        
        if(result != 0){
            Logger.log(message: "couldnt create post sqlite table", event: LogEvent.e)
            return
        }
        Logger.log(message: "post sqlite table has been successfully created", event: LogEvent.i)
    }
    
    func insert(post:Post){
        var sqlite3_stmt: OpaquePointer? = nil
        let query="INSERT OR REPLACE INTO "+TABLE_NAME+" ("+POST_ID+", "+POST_DATE+","+POST_TITLE+", "+POST_USER_ID+", "+POST_CONTENT+", "+POST_IMAGE_URL+", "+POST_VIDEO_URL+", "+LAST_UPDATE+") VALUES (?,?,?,?,?,?,?,?);"
        
        if (sqlite3_prepare_v2(connection,query,-1,&sqlite3_stmt,nil) == SQLITE_OK){
            
            let postId=post.id.cString(using: .utf8)
            let postDate=post.date.toDouble()
            let postTitle=post.title.cString(using: .utf8)
            let postUserId=post.userId.cString(using: .utf8)
            let postContent=post.content.cString(using: .utf8)
            let postImageUrl=post.imageUrl.cString(using: .utf8)
            let postVideoUrl=post.videoUrl.cString(using: .utf8)
            let postLastupdate=post.date.toDouble()
            
            
            sqlite3_bind_text(sqlite3_stmt, 1, postId,-1,nil)
            sqlite3_bind_double(sqlite3_stmt, 2, postDate)
            sqlite3_bind_text(sqlite3_stmt, 3, postTitle,-1,nil)
            sqlite3_bind_text(sqlite3_stmt, 4, postUserId,-1,nil)
            sqlite3_bind_text(sqlite3_stmt, 5, postContent,-1,nil)
            sqlite3_bind_text(sqlite3_stmt, 6, postImageUrl,-1,nil)
            sqlite3_bind_text(sqlite3_stmt, 7, postVideoUrl,-1,nil)
            sqlite3_bind_double(sqlite3_stmt, 8, postLastupdate)
            
            if(sqlite3_step(sqlite3_stmt) == SQLITE_DONE){
                Logger.log(message: "post has been added to local db", event: LogEvent.i)
            }
            else{
                Logger.log(message: "error on sqlite insert progress", event: LogEvent.e)
            }
        }
        else{
            Logger.log(message: "error on preparing sqlite insert query", event: LogEvent.e)
        }
        sqlite3_finalize(sqlite3_stmt)
    }
    
    func selectAll()->[Post]{
        var postlist = [Post]()
        var sqlite3_stmt: OpaquePointer? = nil
        if (sqlite3_prepare_v2(connection,"SELECT * from \(TABLE_NAME);",-1,&sqlite3_stmt,nil) == SQLITE_OK){
            while(sqlite3_step(sqlite3_stmt) == SQLITE_ROW){
                
                let postId =  String(validatingUTF8:sqlite3_column_text(sqlite3_stmt,0))
                let postDate = Date.fromDouble(Double(sqlite3_column_double(sqlite3_stmt,1)))
                let postTitle = String(validatingUTF8:sqlite3_column_text(sqlite3_stmt,2))
                let postUserId =  String(validatingUTF8:sqlite3_column_text(sqlite3_stmt,3))
                let postContent =  String(validatingUTF8:sqlite3_column_text(sqlite3_stmt,4))
                let postImageUrl =  String(validatingUTF8:sqlite3_column_text(sqlite3_stmt,5))
                let postVideoUrl=String(validatingUTF8:sqlite3_column_text(sqlite3_stmt,6))
                let postLastupdate =  Date.fromDouble(Double(sqlite3_column_double(sqlite3_stmt,8)))
                
                let post=Post(id: postId!, date: postDate, title: postTitle!, userId: postUserId!, content: postContent!, imageUrl: postImageUrl, videoUrl: postVideoUrl, guests: nil, comments: nil,lastUpdate:postLastupdate)
                postlist.append(post)
                
                Logger.log(message: "post \(post.id) has been loaded from local firebase",event: LogEvent.i)
            }
        }
        else{
            Logger.log(message: "error on preparing reading from local db",event: LogEvent.e)
            
        }
        sqlite3_finalize(sqlite3_stmt)
        return postlist
    }
    
    func delete(id:String){
        var sqlite3_stmt: OpaquePointer? = nil
        let query="DELETE FROM \(TABLE_NAME) where \(POST_ID)=\(id);"
        if sqlite3_prepare_v2(connection, query, -1, &sqlite3_stmt, nil) == SQLITE_OK {
            if sqlite3_step(sqlite3_stmt) == SQLITE_DONE {
                Logger.log(message: "post \(id) has been deleted from local",event: LogEvent.i)
            } else {
                Logger.log(message: "post \(id) couldnt be deleted from local",event: LogEvent.e)
            }
        } else {
            Logger.log(message: "couldnt prepare local db delete statement",event: LogEvent.e)
        }
        
        sqlite3_finalize(sqlite3_stmt)
    }
    
}
