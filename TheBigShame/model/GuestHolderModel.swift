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
        GuestHolderFirebase.instance.clearObservers()
        let tableName=GuestHolderSql.instance.TABLE_NAME
        let lastupdateDate=LastUpdateTable.instnace.getLastUpdate(tableName: tableName)
        
        GuestHolderFirebase.instance.loadAllDataAndObserve(lastupdateDate) { holders in
            if !holders.isEmpty{
                let holders = holders as! [GuestHolder]
                holders.forEach{
                    $0.isDeleted ? GuestHolderSql.instance.delete(guestHolderid: $0.id) : GuestHolderSql.instance.insert(holder: $0)
                }
                var newLastUpdate = holders.map{$0.lastUpdate?.toDouble()}.max(by: {$0! < $1!})
                newLastUpdate = newLastUpdate!! + 1
                LastUpdateTable.instnace.setLastUpdate(tableName: tableName, lastUpdate: Date.fromDouble(newLastUpdate!!))
                self.loadAndObserve()
                self.data = GuestHolderSql.instance.selectAll()
                self.notificationCenter.post(data: self.data)
            }
        }
        self.data = GuestHolderSql.instance.selectAll()
        self.notificationCenter.post(data: self.data)
        
    }
    
    func deleteMultipleGuestHolders(guests:[GuestHolder],onComplete:@escaping([GuestHolder])->Void){
        
        let dispatchTask = DispatchGroup()
        
        guests.forEach{guest in
            dispatchTask.enter()
            deleteGuestHolder(guestHolder: guest, onComplete: {_ in dispatchTask.leave()})
        }
        dispatchTask.enter()
        onComplete(guests)
        
    }
    
    func deleteGuestHolder(guestHolder:GuestHolder, onComplete:@escaping(GuestHolder)->Void){
        guestHolder.isDeleted = true
        guestHolder.hasChanged()
        GuestHolderSql.instance.delete(guestHolderid: guestHolder.id)
        GuestHolderFirebase.instance.store(data: guestHolder, onComplete: {_ in onComplete(guestHolder)})
    }
    
}



