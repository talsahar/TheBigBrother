//
//  Policy.swift
//  TheBigShame
//
//  Created by admin on 13/02/2018.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation
class Policy{
    static func isLegalEmail(str:String)->Bool{
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: str)
    }
    
    static func isValidPass(str:String)->Bool{
        return str.count>5
    }
}
