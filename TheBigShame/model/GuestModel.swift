//
//  GuestModel.swift
//  TheBigShame
//
//  Created by admin on 07/02/2018.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation
class GuestModel{
    
    static let instance = GuestModel()
    
    var guestArr=[Guest]()
    var guestsHolder = [GuestHolder]()
    
    var dataObserver:Any?
    let guestListNotification = MyNotification<[GuestHolder]>(name: "guestHolderListNotification")
    
    private init() {
        dataObserver = guestListNotification.observe { guests in
            self.guestsHolder=guests!
        }
        guestArr.append(Guest(name: "אביחי אוחנה",imageName: "avihi"))
        guestArr.append(Guest(name: "אנדל קבדה",imageName: "andel"))
        guestArr.append(Guest(name: "חיים שועי",imageName: "haim"))
        guestArr.append(Guest(name: "מעיין אשכנזי",imageName: "maayan"))
        guestArr.append(Guest(name: "עדן סבן",imageName: "eden"))
        guestArr.append(Guest(name: "שם ברדוגו",imageName: "shem"))
        guestArr.append(Guest(name: "שמוליק ספן",imageName: "shmulik"))
    }
    
    func getByName(name:String)->Guest?{
        for guest in guestArr{
            if guest.name == name{
                return guest
            }
        }
        Logger.log(message: "No \(name) guest was found", event: LogEvent.e)
        return nil
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
        GuestsSql.instance.insert(holder: guestHolder)
        GuestFirebase.storeGuest(guest: guestHolder, onComplete: {error in
            error == nil ? onComplete(guestHolder) : onComplete(nil)
        })
    }
    
    func loadAllGuestsAndObserve(){
        let tableName=GuestsSql.instance.TABLE_NAME
        let lastupdateDate=LastUpdateTable.instnace.getLastUpdate(tableName: tableName)
        
        GuestFirebase.loadAllGuestsAndObserve(lastupdateDate) { holders in
            if !holders.isEmpty{
                
                holders.forEach{GuestsSql.instance.insert(holder: $0)}
                let newLastUpdate = holders.map{$0.lastUpdate?.toDouble()}.max(by: {$0! < $1!})
                LastUpdateTable.instnace.setLastUpdate(tableName: tableName, lastUpdate: Date.fromDouble(newLastUpdate!!))
                
                let guestsHolder=GuestsSql.instance.selectAll()
                self.guestListNotification.post(data: guestsHolder)
                
            }
            
        }
        
    }
    
}


extension GuestModel{
    
    static func getBoolMapArray()->Array<(key: Guest, value: Bool)>{
        var dic=[Guest:Bool]()
        for guest in instance.guestArr
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
    
}
