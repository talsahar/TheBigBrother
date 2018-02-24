//
//  GuestsHolder.swift
//  TheBigShame
//
//  Created by admin on 04/02/2018.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation

class GuestHolder:FirebaseDataProtocol{
  
    
   
    
    var id:String
    var guest:Guest
    var postId:String
    var lastUpdate:Date?
    
    
    
    init(id:String?,postId:String,guest:Guest,lastupdate:Date?){
        self.id = (id == nil) ? UUID().uuidString : id!
        self.postId = postId
        self.guest = guest
        if lastupdate != nil{
            self.lastUpdate = lastupdate

        }
    }
    static func initByJson(json: Dictionary<String, Any>) -> FirebaseDataProtocol{
        return GuestHolder(json: json)
    }
    init(json:Dictionary<String, Any>){
        self.id=json["id"] as! String
        self.postId=json["postId"] as! String
        let name = json["guest"] as! String
        guest=GuestModel.instance.getByName(name: name)!
        lastUpdate=Date.fromDouble(json["lastUpdate"] as! Double)
        
    }
    
    func buildJson()->Dictionary<String, Any>{
        var json = Dictionary<String, Any>()
        json["id"] = id
        json["postId"] = postId
        json["guest"] = guest.name
        json["lastUpdate"]=lastUpdate?.toDouble()
        return json
    }
    func hasChanged(){
        lastUpdate = Date()
    }
    
 
    
    static func buildList(postId:String,guests:[Guest]?)->[GuestHolder]{
        var guestlist=[GuestHolder]()
            guests?.forEach{guestlist.append(GuestHolder(id: nil, postId: postId, guest: $0, lastupdate: nil))}        
        return guestlist
    }
    func firebaseId() -> String {
        return id
    }
}

