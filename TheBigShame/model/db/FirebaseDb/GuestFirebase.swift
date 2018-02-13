//
//  GuestFirebase.swift
//  TheBigShame
//
//  Created by admin on 11/02/2018.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation
import Firebase

class GuestFirebase{
    
    private static let ref = Database.database().reference().child("guests")
    
    static func storeGuest(guest:GuestHolder,onComplete:@escaping (Error?)->Void){
        let json=guest.buildJson()
        ref.child(guest.postId).setValue(json){(error, dbref) in
            if error != nil{
                Logger.log(message: "error store guest \(guest.id) on firebase ", event: LogEvent.e)
                onComplete(error!)
            }
            else{
                Logger.log(message: "stored post \(guest.id) on firebase ", event: LogEvent.i)
            }
            onComplete(nil)
        }
    }
    
    static func loadAllGuestsAndObserve(_ lastUpdateDate:Date?, onComplete:@escaping ([GuestHolder])->Void){
        
        let handler = {(snapshot:DataSnapshot) in
            Logger.log(message: "loading all guests ,from last update: \(lastUpdateDate?.toString ?? "") ", event: LogEvent.i)
            var guests = [GuestHolder]()
            for guestChild in snapshot.children.allObjects{
                if let guestChildData = guestChild as? DataSnapshot{
                    if let guestJson = guestChildData.value as? Dictionary<String,Any>{
                        let guest = GuestHolder(json: guestJson)
                        Logger.log(message: "guest \(guest.id) has loaded from firebase last update: \(String(describing: guest.lastUpdate?.toString)) ", event: LogEvent.i)
                        guests.append(guest)
                        
                    }
                }
            }
            onComplete(guests)
        }
        
        if (lastUpdateDate != nil){
            let query = ref.queryOrdered(byChild:"lastUpdate").queryStarting(atValue:lastUpdateDate?.toDouble())
            query.observe(DataEventType.value, with: handler)
        }else{
            ref.observe(DataEventType.value, with: handler)
        }
        
    }
    
    static func clearObservers(){
        ref.removeAllObservers()
    }
    
}
