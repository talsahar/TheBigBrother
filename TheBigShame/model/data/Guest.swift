//
//  Guest.swift
//  TheBigShame
//
//  Created by admin on 03/02/2018.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation
class Guest:Hashable,FirebaseDataProtocol{
    
    var hashValue: Int
    let name:String
    let age:Int
    let description:String
    let gender:Gender
    var imageUrl:String?
    var lastUpdate:Date?
    var isDeleted:Bool
    init(id:Int = NSUUID().uuidString.hashValue,name:String,gender:Gender,age:Int,description:String,imageUrl:String = "",lastUpdate:Date?,isDeleted:Bool){
        hashValue = id
        self.name=name
        
        self.imageUrl = imageUrl
        self.age=age
        self.description=description
        self.gender=gender
        self.lastUpdate=lastUpdate
        self.isDeleted = isDeleted
    }
    
    static func initByJson(json: Dictionary<String, Any>) -> FirebaseDataProtocol{
        return Guest(json: json)
    }
    
    
    init(json:Dictionary<String,Any>){
        hashValue = json["id"] as! Int
        name=json["name"]  as! String
        age=json["age"]  as! Int
        description=json["description"]  as! String
        imageUrl=json["imageUrl"]  as? String
        gender=Gender(rawValue: json["gender"]  as! String)!
        lastUpdate=Date.fromDouble(json["lastUpdate"] as! Double)
        isDeleted = json["isDeleted"] as! Bool

    }//check data
  
    func buildJson()->Dictionary<String,Any>{
        var json = Dictionary<String,Any>()
        json["id"] = hashValue
        json["name"] = name
        json["age"] = age
        json["description"] = description
        json["gender"] = gender.rawValue
        imageUrl != nil ? json["imageUrl"] = imageUrl : nil
        json["lastUpdate"] = lastUpdate?.toDouble()
        json["isDeleted"] = isDeleted

        return json
    }
    func firebaseId() -> String {
        return String(hashValue)
    }
    
   
    static func ==(lhs: Guest, rhs: Guest) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    func hasChanged(){
        lastUpdate = Date()
    }
    
    
}
enum Gender:String{
    
    
    case male = "male"
    case female = "female"
}



