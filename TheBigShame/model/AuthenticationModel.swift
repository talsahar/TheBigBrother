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
    
    static let instance = AuthenticationModel()
    private init(){}
    
    func login(email: String, password: String, onSuccess: @escaping (_ user:User)->Void, onFail: @escaping (_ error:Error)->Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if (user != nil){
                onSuccess(user!)
            }
            else{
                onFail(error!)
            }
        }
    }
    
    func register(email: String, password: String,nickname:String, onSuccess: @escaping(_ user:User)->Void, onFail: @escaping (_ error:Error)->Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if ((user) != nil){
                self.updateProfile(displayName: nickname, photo: nil, thenDo: {
                    onSuccess(user!)
                })
            }
            else{
                onFail(error!)
            }
        }
    }
    
    func logout() {
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            print(signOutError)
        }
    }
    
    func getCurrentUser()->User{
        return Auth.auth().currentUser!
    }
    
    
    func isConnected() -> Bool {
        return (Auth.auth().currentUser != nil)
    }
    
    func updateProfile(displayName:String?,photo:URL?,thenDo:@escaping ()->Void){
        if let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest(){
            if displayName != nil && !(displayName?.isEmpty)!{
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
