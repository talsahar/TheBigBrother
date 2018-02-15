//
//  AuthenticationVC.swift
//  TheBigShame
//
//  Created by admin on 12/02/2018.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit



class AuthenticationVC: UIViewController, RegisterVCDelegate,LoginVCDelegate{
  
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let userName = AuthenticationModel.getCurrentUser()?.displayName{
            onVerified(username: userName)

        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //register || login
    @IBAction func onButton(_ sender: UIButton) {
        if sender.tag == 0{
            let control = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RegisterVC") as! RegisterVC
            control.delegate = self
            self.present(control, animated: true, completion: nil)
            
        }
        if sender.tag == 1{
            let control = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            control.delegate = self
            self.present(control, animated: true, completion: nil)
            
        }
        
    }
    @IBAction func onDisconnectSegue(segue: UIStoryboardSegue) {
    AuthenticationModel.logout()
        
    }
    
    func onVerified(username:String) {
        Logger.log(message: "Authorized as \(username)", event: LogEvent.i)

        performSegue(withIdentifier: "mainMenuSegue", sender: nil)
    }
    
}
