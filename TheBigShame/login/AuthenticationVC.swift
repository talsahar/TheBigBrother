//
//  AuthenticationVC.swift
//  TheBigShame
//
//  Created by admin on 12/02/2018.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit



class AuthenticationVC: UIViewController, RegisterVCDelegate,LoginVCDelegate{
    
    
    @IBOutlet var popupView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    func onVerified() {
        performSegue(withIdentifier: "mainMenuSegue", sender: nil)
    }
    
}
