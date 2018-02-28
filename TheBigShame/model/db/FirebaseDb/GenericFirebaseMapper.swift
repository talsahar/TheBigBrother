//
//  GenericFirebaseManager.swift
//  TheBigShame
//
//  Created by admin on 24/02/2018.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation
import Firebase

protocol FirebaseDataProtocol{
    func buildJson() -> Dictionary<String,Any>
    func firebaseId() -> String
}


class GenericFirebaseMapper{
    
    let ref:DatabaseReference
    
    init(childRef:String){
        ref = Database.database().reference().child(childRef)
    }
    
    func store(data:FirebaseDataProtocol,onComplete:@escaping (FirebaseDataProtocol)->Void){
        let json=data.buildJson()
        ref.child(data.firebaseId()).setValue(json){(error, dbref) in
            
            error == nil ? onComplete(data) : Logger.log(message: "error store data on firebase " + error.debugDescription, event: LogEvent.e)

        }
    }
    
    func loadAllDataAndObserve(_ lastUpdateDate:Date?, onComplete:@escaping ([FirebaseDataProtocol])->Void){
        let handler = {(snapshot:DataSnapshot) in
            Logger.log(message: "\(self.ref.key) : load all data : last update: \(lastUpdateDate?.toString ?? "") ", event: LogEvent.i)
            var dataList = [FirebaseDataProtocol]()
            for child in snapshot.children.allObjects{
                if let childData = child as? DataSnapshot{
                    if let dataJson = childData.value as? Dictionary<String,Any>{
                        let data = self.initByJson(json: dataJson)
                        Logger.log(message: "\(self.ref.key) : \(data?.firebaseId() ?? "-error on id-") has loaded from firebase ", event: LogEvent.i)
                        dataList.append((data)!)
                        
                        //load post's guests
                        
                    }
                }
            }
            onComplete(dataList)
        }
        
        if (lastUpdateDate != nil){
            let query = ref.queryOrdered(byChild:"lastUpdate").queryStarting(atValue:lastUpdateDate?.toDouble())
            query.observe(DataEventType.value, with: handler)
        }else{
            ref.observe(DataEventType.value, with: handler)
        }
        
    }
    
    func clearObservers(){
        ref.removeAllObservers()
    }
 
    func initByJson(json: Dictionary<String,Any>)->FirebaseDataProtocol?{
        //must be overriden\
        Logger.log(message: "This method must be overiden", event: .e)
        return nil
    }
    
}
