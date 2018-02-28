//
//  NewGuestPopup.swift
//  TheBigShame
//
//  Created by admin on 23/02/2018.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

protocol NewGuestPopupDelegate{
    func onCreate(guest:Guest)
}

class NewGuestPopup: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate{
    
    @IBOutlet var spinner: UIActivityIndicatorView!
    @IBOutlet var guestDetails: UITextView!
    @IBOutlet var ageField: UILabel!
    @IBOutlet var gender: UISegmentedControl!
    @IBOutlet var guestName: UITextField!
    @IBOutlet var profileImage: UIImageView!
    var hasImage = false
    var delegate:NewGuestPopupDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guestDetails.delegate = self
        
        guestDetails.textColor = UIColor.lightGray
        
        gender.selectedSegmentIndex = 1
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        profileImage.isUserInteractionEnabled = true
        profileImage.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        spinner.startAnimating()
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
        spinner.stopAnimating()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let possibleImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            hasImage = true
            self.profileImage.image = possibleImage
        } else if let possibleImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            hasImage = true
            self.profileImage.image = possibleImage
        } else {
            return
        }
        spinner.stopAnimating()
        dismiss(animated: true)
    }
    
    @IBAction func onAgeChanged(_ stepper: UIStepper) {
        ageField.text = Int(stepper.value).description
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func onDone(_ sender: Any) {
        
        if let name=guestName.text{
            if name.count <= 1{
                guestName.text = ""
                guestName.placeholder = "השם קצר מידי"
                return
            }
            if GuestModel.instance.data.first(where: {$0.name == name && $0.isDeleted == false}) != nil{
                guestName.text = ""
                guestName.placeholder = "השם קיים במערכת"
                return
            }
        }
        
        var gander:Gender
        gander = gender.selectedSegmentIndex == 0 ? .female : .male
        
        let guest = Guest(name: guestName.text!, gender: gander, age: Int(ageField.text!)!, description: guestDetails.text, lastUpdate: nil,isDeleted:false)
        
        var image:UIImage?
        image = hasImage ? profileImage.image! : nil
        
        CentralDBDataModel.instance.saveGuest(guest: guest, image: image){
            guest in
            self.delegate?.onCreate(guest: guest)
        }
        
        
        
        dismiss(animated: true, completion: nil)
    }
    @IBAction func closeButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    //placeholder
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "תיאור"
            textView.textColor = UIColor.lightGray
        }
    }
}
