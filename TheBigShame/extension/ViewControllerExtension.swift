//
//  ViewControllerExtension.swift
//  TheBigShame
//
//  Created by admin on 11/02/2018.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

extension UIViewController {
    /**
     * Shows a default alert/info message with an OK button.
     */
    func showAlertMessage(_ message: String, okButtonTitle: String = "Ok") -> Void {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: okButtonTitle, style: .default, handler: nil)
        alert.addAction(okAction)
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
            
        }
    }
    // dismiss keyboard when tapped around a textfield
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
