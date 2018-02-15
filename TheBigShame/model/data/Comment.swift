//
//  Comment.swift
//  TheBigShame
//
//  Created by admin on 03/02/2018.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation

class Comment{
    var commentId:String?
    var postId:String?
    var authorId:String?
    var date:Date?
    var title:String?
    var content:String?
    var isLike:Bool?
    var lastUpdate:Date?
   
    init(id:String,postId:String,authorId:String,date:Date,title:String,content:String,isLike:Bool,lastUpdate:Date?){
        self.commentId=id;
        self.postId=postId
        self.authorId=authorId
        self.date=date
        self.title=title
        self.content=content
        self.isLike=isLike
        self.lastUpdate = (lastUpdate != nil) ? lastUpdate! : Date()

    }
    
    init(json:Dictionary<String, Any>){
        self.commentId=json["id"] as? String
        postId=json["postId"]  as! String
        authorId=json["authorId"]  as! String
        date=Date.fromDouble(json["date"] as! Double)
        title=json["title"]  as! String
        content=json["content"]  as! String
        isLike=json["isLike"] as! Bool
        lastUpdate=Date.fromDouble(json["lastUpdate"] as! Double)
    }
    
    func buildJson()->Dictionary<String, Any>{
        var json = Dictionary<String, Any>()
        json["id"] = commentId
        json["postId"] = postId
        json["authorId"] = authorId
        json["date"] = date?.toDouble()
        json["title"]=title
        json["content"]=content
        json["isLike"]=isLike
        json["lastUpdate"] = lastUpdate?.toDouble()
        return json
    }
    
}
