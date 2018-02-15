//
//  AuthenticationModel.swift
//  TheBigShame
//
//  Created by admin on 11/02/2018.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation
import FirebaseAuth
class AuthenticationModel{
    
    
    static func login(email: String, password: String, onSuccess: @escaping (_ user:User)->Void, onFail: @escaping (_ error:Error)->Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            (user != nil) ? onSuccess(user!) : onFail(error!)
        }
    }
    
    static func register(email: String, password: String,nickname:String, onSuccess: @escaping(_ user:User)->Void, onFail: @escaping (_ error:Error)->Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            (user != nil) ? updateProfile(displayName: nickname, photo: nil, thenDo: {onSuccess(user!)}) : onFail(error!)
        }
    }
    
    static func logout() {
        try? Auth.auth().signOut()
    }
    
    static func getCurrentUser()->User?{
        return Auth.auth().currentUser
    }
    
    
    
    
    static func updateProfile(displayName:String?,photo:URL?,thenDo:@escaping ()->Void){
        if let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest(){
            if !(displayName?.isEmpty)!{
                changeRequest.displayName=displayName
            }
            
            if photo != nil{
                changeRequest.photoURL=photo
            }
            changeRequest.commitChanges { (error) in
                thenDo()
            }
        }
    }
    
    
    
    
}
