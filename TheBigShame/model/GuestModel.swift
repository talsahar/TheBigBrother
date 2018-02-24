//
//  GuestModel.swift
//  TheBigShame
//
//  Created by admin on 23/02/2018.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation
import UIKit
class GuestModel{
    static let instance = GuestModel()
    
    var data=[Guest]()
    
    let notificationCenter = MyNotification<[Guest]>(name: "guestListNotification")
    
    private init() {}
    
    func saveGuest(data:Guest,onComplete:@escaping (Guest)->Void){
        data.hasChanged()
        GuestSql.instance.insert(guest: data)
        GuestFirebase.instance.store(data: data, onComplete: {_ in
            onComplete(data)
        })
    
    }
    
    func loadAndObserve(){
        
        GuestFirebase.instance.clearObservers()
        let tableName=GuestSql.instance.TABLE_NAME
        let lastupdateDate=LastUpdateTable.instnace.getLastUpdate(tableName: tableName)
        
        GuestFirebase.instance.loadAllDataAndObserve(lastupdateDate) { (guests) in
            if guests.count > 0{
                let guests = guests as! [Guest]
                guests.forEach{GuestSql.instance.insert(guest: $0)}
                
                var newLastUpdate = guests.map{$0.lastUpdate?.toDouble()}.max(by: {$0! < $1!})
                newLastUpdate = newLastUpdate!! + 1
                
                LastUpdateTable.instnace.setLastUpdate(tableName: tableName, lastUpdate: Date.fromDouble(newLastUpdate!!))
                
                self.loadAndObserve()
            }
            self.data = GuestSql.instance.selectAll()
            self.notificationCenter.post(data: self.data.filter{!$0.isDeleted})
        }
    }
}


extension GuestModel{
    
    static func getBoolMapArray()->Array<(key: Guest, value: Bool)>{
        var dic=[Guest:Bool]()
        for guest in GuestModel.instance.data
        {
            dic[guest]=false
        }
        return Array(dic)
    }
    
    static func filterChosens(list:Array<(key: Guest, value: Bool)>)->[Guest]{
        var chosens=[Guest]()
        for entry in list{
            if entry.value == true{
                chosens.append(entry.key)
            }
        }
        return chosens
    }
    
    func getByName(name:String)->Guest?{
        for guest in data{
            if guest.name == name{
                return guest
            }
        }
        Logger.log(message: "No \(name) guest was found", event: LogEvent.e)
        return nil
    }
    
}
