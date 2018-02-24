//
//  GuestModel.swift
//  TheBigShame
//
//  Created by admin on 07/02/2018.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation
import UIKit
class GuestHolderModel{
    
    
    
    
    static let instance = GuestHolderModel()
    
    var data = [GuestHolder]()
    
    var dataObserver:Any?
    let notificationCenter = MyNotification<[GuestHolder]>(name: "guestHolderListNotification")
    
    private init() {
       
   }
   
    
    func storeMultipleGuests(list:[GuestHolder],onComplete:@escaping([GuestHolder])->Void){
        let dispatchTask = DispatchGroup()
        
        list.forEach{guest in
            dispatchTask.enter()
            storeGuest(guestHolder: guest, onComplete: {_ in dispatchTask.leave()})
        }
        dispatchTask.enter()
        onComplete(list)
    }
    
    func storeGuest(guestHolder:GuestHolder, onComplete:@escaping (GuestHolder?)->Void){
        guestHolder.hasChanged()
        GuestHolderSql.instance.insert(holder: guestHolder)
        GuestHolderFirebase.instance.store(data: guestHolder, onComplete: {data in
            onComplete(data as? GuestHolder)
        })
    }
    
    func loadAndObserve(){
        let tableName=GuestHolderSql.instance.TABLE_NAME
        let lastupdateDate=LastUpdateTable.instnace.getLastUpdate(tableName: tableName)
        
        GuestHolderFirebase.instance.loadAllDataAndObserve(lastupdateDate) { holders in
            if !holders.isEmpty{
            let holders = holders as! [GuestHolder]
                holders.forEach{GuestHolderSql.instance.insert(holder: $0 )}
                let newLastUpdate = holders.map{$0.lastUpdate?.toDouble()}.max(by: {$0! < $1!})
                LastUpdateTable.instnace.setLastUpdate(tableName: tableName, lastUpdate: Date.fromDouble(newLastUpdate!!))
                
                let guestsHolder=GuestHolderSql.instance.selectAll()
                self.data = guestsHolder
                self.notificationCenter.post(data: guestsHolder)
                
            }
            
        }
        
    }
    
}



