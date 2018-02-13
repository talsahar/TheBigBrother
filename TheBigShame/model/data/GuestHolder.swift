//
//  GuestsHolder.swift
//  TheBigShame
//
//  Created by admin on 04/02/2018.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation

class GuestHolder{
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
        lastUpdate=Date()
        json["lastUpdate"]=lastUpdate?.toDouble()
        return json
    }
    
    static func buildList(postId:String,guests:[Guest]?)->[GuestHolder]{
        var guestlist=[GuestHolder]()
        if let guests = guests{
            for guest in guests{
                guestlist.append(GuestHolder(id: nil,postId: postId,guest: guest, lastupdate: nil))
            }
        }
        
        return guestlist
    }
    
}

