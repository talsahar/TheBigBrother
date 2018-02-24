//
//  GuestFirebase.swift
//  TheBigShame
//
//  Created by admin on 23/02/2018.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation
import Firebase
class GuestFirebase : GenericFirebaseMapper{
    
    static let instance = GuestFirebase()
    
    private init(){
        super.init(childRef: "guests")
    }
    
    override func initByJson(json: Dictionary<String,Any>)->FirebaseDataProtocol?{
        return Guest(json: json)
    }
//    private static let ref = Database.database().reference().child("guests")
//
//    static func storeGuest(guest:Guest,onComplete:@escaping (Error?)->Void){
//        let json = guest.buildJson()
//        ref.child(String(guest.hashValue)).setValue(json){(error, dbref) in
//
//
//            if error != nil{
//                Logger.log(message: "error store guest \(guest.name) on firebase ", event: LogEvent.e)
//                onComplete(error!)
//            }
//            else{
//                Logger.log(message: "stored guest \(guest.name) on firebase ", event: LogEvent.i)
//                onComplete(nil)
//            }
//        }
//    }
//
//    static func loadAllAndObserve(_ lastUpdateDate:Date?, onComplete:@escaping ([Guest])->Void){
//
//        let handler = {(snapshot:DataSnapshot) in
//            Logger.log(message: "loading all guests ,from last update: \(lastUpdateDate?.toString ?? "none") ", event: LogEvent.i)
//            var guests = [Guest]()
//            for guestChild in snapshot.children.allObjects{
//                if let guestChildData = guestChild as? DataSnapshot{
//                    if let guestJson = guestChildData.value as? Dictionary<String,Any>{
//                        let guest = Guest(json: guestJson)
//                        Logger.log(message: "guest \(guest.name) has loaded from firebase last update: \(String(describing: guest.lastUpdate?.toString)) ", event: LogEvent.i)
//                        guests.append(guest)
//
//                    }
//                }
//            }
//            onComplete(guests)
//        }
//
//
//        if (lastUpdateDate != nil){
//            let query = ref.queryOrdered(byChild:"lastUpdate").queryStarting(atValue:lastUpdateDate?.toDouble())
//            query.observe(DataEventType.value, with: handler)
//        }else{
//            ref.observe(DataEventType.value, with: handler)
//        }
//
//    }
//
//
//    static func clearObservers(){
//        ref.removeAllObservers()
//    }
}
