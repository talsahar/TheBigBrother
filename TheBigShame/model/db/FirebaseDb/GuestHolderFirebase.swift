//
//  GuestFirebase.swift
//  TheBigShame
//
//  Created by admin on 11/02/2018.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation
import Firebase

    class GuestHolderFirebase : GenericFirebaseMapper{
        
        static let instance = GuestHolderFirebase()
        
        private init(){
            super.init(childRef: "guestHolders")

        }
        
        override func initByJson(json: Dictionary<String,Any>)->FirebaseDataProtocol?{
            return GuestHolder(json: json)
        }
        
//    private static let ref = Database.database().reference().child("guest_holders")
//    
//    static func storeGuest(guest:GuestHolder,onComplete:@escaping (Error?)->Void){
//        let json=guest.buildJson()
//        ref.child(guest.postId).setValue(json){(error, dbref) in
//            if error != nil{
//                Logger.log(message: "error store guest holder \(guest.id) on firebase ", event: LogEvent.e)
//                onComplete(error!)
//            }
//            else{
//                Logger.log(message: "stored guest holder \(guest.id) on firebase ", event: LogEvent.i)
//                onComplete(nil)
//            }
//        }
//    }
//    
//    static func loadAllGuestsAndObserve(_ lastUpdateDate:Date?, onComplete:@escaping ([GuestHolder])->Void){
//        
//        let handler = {(snapshot:DataSnapshot) in
//            Logger.log(message: "loading all guests holders ,from last update: \(lastUpdateDate?.toString ?? "") ", event: LogEvent.i)
//            var guests = [GuestHolder]()
//            for guestChild in snapshot.children.allObjects{
//                if let guestChildData = guestChild as? DataSnapshot{
//                    if let guestJson = guestChildData.value as? Dictionary<String,Any>{
//                        let guest = GuestHolder(json: guestJson)
//                        Logger.log(message: "guest \(guest.id) has loaded from firebase last update: \(String(describing: guest.lastUpdate?.toString)) ", event: LogEvent.i)
//                        guests.append(guest)
//                        
//                    }
//                }
//            }
//            onComplete(guests)
//        }
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
//    static func clearObservers(){
//        ref.removeAllObservers()
//    }
//    
}
