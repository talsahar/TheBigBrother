//
//  LoginVC.swift
//  TheBigShame
//
//  Created by admin on 12/02/2018.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import SwiftSpinner
protocol LoginVCDelegate{
    func onVerified(username:String)

}

class LoginVC: UIViewController {

    @IBOutlet var errorLabel: UILabel!
    @IBOutlet var passField: UITextField!
    @IBOutlet var emailField: UITextField!
    var delegate:LoginVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    func validFields()->Bool{
        if Policy.isLegalEmail(str: emailField.text!) == false{
            errorLabel.text = "שדה המייל שגוי"
            return false
        }
        
      
        if Policy.isValidPass(str: passField.text!) == false{
            errorLabel.text = "סיסמא לא חוקית, הכנס לפחות 6 תווים"
            return false
        }
      
        return true
        
    }
    @IBAction func loginButton(_ sender: Any) {
        if validFields(){
            SwiftSpinner.show("Signing in..")
            AuthenticationModel.login(email: emailField.text!, password: passField.text!, onSuccess: {user in
                SwiftSpinner.hide()
                self.dismiss(animated: true , completion: {
                self.delegate?.onVerified(username: user.displayName!)
            })}, onFail: {error in
                SwiftSpinner.hide()
                Logger.log(message: error.localizedDescription, event: LogEvent.e)
                self.errorLabel.text = "משתמש אינו קיים או שסיסמתך אינה נכונה"}
            )
        }
    }
    
    @IBAction func onCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: {
        })
    }
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
