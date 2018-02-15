//
//  RegisterVC.swift
//  TheBigShame
//
//  Created by admin on 12/02/2018.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

protocol RegisterVCDelegate{
    func onVerified(username:String)

}

class RegisterVC: UIViewController {

    @IBOutlet var errorLabel: UILabel!
    @IBOutlet var emailField: UITextField!
    @IBOutlet var nicknameField: UITextField!
    @IBOutlet var passField: UITextField!
    @IBOutlet var passConfirmField: UITextField!
    var delegate:RegisterVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func registerButton(_ sender: Any) {
        if validFields() == true{
            AuthenticationModel.register(email: emailField.text!, password: passField.text!, nickname: nicknameField.text!, onSuccess: { (User) in
                self.dismiss(animated: true, completion: {self.delegate?.onVerified(username: User.displayName!)})
            }) { error in
                Logger.log(message: error.localizedDescription, event: LogEvent.e)
                self.errorLabel.text = "משתמש קיים"
                
            }
        }
        
    }
    
    func validFields()->Bool{
        if Policy.isLegalEmail(str: emailField.text!) == false{
            errorLabel.text = "שדה המייל שגוי"
            return false
        }
        
        if (nicknameField.text?.count)! < 2{
            errorLabel.text = "כינוי קצר מידי"
            return false
        }
        if Policy.isValidPass(str: passField.text!) == false{
            errorLabel.text = "סיסמא לא חוקית, הכנס לפחות 6 תווים"
            return false
        }
        
        if passField.text! != passField.text{
            return false
        }
     return true
        
    }
    @IBAction func onCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: {
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    

   

}
