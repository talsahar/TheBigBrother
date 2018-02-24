//
//  Post.swift
//  TheBigShame
//
//  Created by admin on 03/02/2018.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation
class Post:FirebaseDataProtocol{
   
   
    
   
    
    var id:String
    var date:Date
    var title:String
    var userId:String
    var content:String
    var imageUrl:String
    var videoUrl:String
    var guests:[GuestHolder]
    var comments:[Comment]
    var lastUpdate:Date?
    
    init(id:String = UUID().uuidString,date:Date,title:String,userId:String,content:String,imageUrl:String = "",videoUrl:String = "",guests:[Guest]?,comments:[Comment]?,lastUpdate:Date?){
        self.id = id
        self.date=date
        self.title=title
        self.userId=userId
        self.content=content
        self.imageUrl = imageUrl
        self.videoUrl = videoUrl
        self.guests = GuestHolder.buildList(postId: self.id,guests: guests)
        self.comments = (comments != nil) ? comments! : [Comment]()
        if lastUpdate != nil{
            self.lastUpdate = lastUpdate
        }
    }
    
    init(json:Dictionary<String, Any>){
        id=json["id"] as! String
        date=Date.fromDouble(json["date"] as! Double)
        title=json["title"]  as! String
        userId=json["userId"]  as! String
        content=json["content"]  as! String
        imageUrl=json["imageUrl"]  as! String
        videoUrl=json["videoUrl"]  as! String
        lastUpdate=Date.fromDouble(json["lastUpdate"] as! Double)
        guests = GuestHolder.buildList(postId: id,guests: nil)
        comments=[Comment]()
    }
    static func initByJson(json: Dictionary<String, Any>) -> FirebaseDataProtocol{
        return Post(json: json)
    }
   
    func buildJson()->Dictionary<String, Any>{
        var json = Dictionary<String, Any>()
        json["id"] = id
        json["date"] = date.toDouble()
        json["title"] = title
        json["userId"] = userId
        json["content"]=content
        json["imageUrl"]=imageUrl
        json["videoUrl"]=videoUrl
        json["lastUpdate"] = lastUpdate!.toDouble()
        return json
    }
    func setChanged(){
        lastUpdate = Date()
    }
    
    func firebaseId() -> String {
        return id
    }
    
   
}

