//
//  Guest.swift
//  TheBigShame
//
//  Created by admin on 03/02/2018.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation
class Guest:Hashable{
    var hashValue: Int
    var name:String?
    var imageName:String?
    
    init(name:String,imageName:String){
        hashValue=0
        self.name=name
        self.imageName=imageName
    }
  
    

    static func ==(lhs: Guest, rhs: Guest) -> Bool {
        return lhs.name==rhs.name
    }
}



