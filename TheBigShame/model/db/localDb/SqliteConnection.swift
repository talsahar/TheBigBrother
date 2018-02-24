//
//  LocalDB.swift
//  TheBigShame
//
//  Created by admin on 09/02/2018.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation
public class SqliteConnection{
    
    static let dbName="TheBigShameDB"
    
    static func getConnection() -> OpaquePointer? {
        
        var database: OpaquePointer? = nil
        if let dir = FileManager.default.urls(for: .documentDirectory, in:
            .userDomainMask).first{
            let path = dir.appendingPathComponent(dbName)
            if sqlite3_open(path.absoluteString, &database) == SQLITE_OK {
                return database
            }
            else{
                Logger.log(message: "Unable to open database.", event: LogEvent.e)
            }
        }
        return nil
    }
    
    
}

extension String{
    
}


extension Date{
    func toDouble()->Double{
        return self.timeIntervalSince1970 * 1000
    }
    
    func fromFirebase(_ interval:String)->Date{
        return Date(timeIntervalSince1970: Double(interval)!)
    }
    
    static func fromDouble(_ interval:Double)->Date{
        return (interval>9999999999) ? Date(timeIntervalSince1970: interval/1000) : Date(timeIntervalSince1970: interval)
    }
    
    var toString: String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.string(from: self)
    }
    
    func onlyDate()->String{
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.none
        dateFormatter.dateStyle = DateFormatter.Style.short
        
        return dateFormatter.string(from: self)
        
    }
    
}

extension String {
    public init?(validatingUTF8 cString: UnsafePointer<UInt8>) {
        if let (result, _) = String.decodeCString(cString, as: UTF8.self,repairingInvalidCodeUnits: false) {
            self = result
        }
        else {
            return nil
        }
    }
}
