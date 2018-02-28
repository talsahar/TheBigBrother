//
//  GuestInfoPopup.swift
//  TheBigShame
//
//  Created by admin on 16/02/2018.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

class GuestInfoPopup: UIViewController {
    @IBOutlet var name: UILabel!
    @IBOutlet var gender: UILabel!
    @IBOutlet var age: UILabel!
    @IBOutlet var deleteButton: PressableButton!
    
    @IBOutlet var info: UITextView!
    @IBOutlet var image: UIImageView!
    var guest:Guest?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if AuthenticationModel.isAdministrator(){
            deleteButton.isHidden = false
        }
        
        if guest != nil{
            name.text = guest?.name
            gender.text = (guest?.gender == .male) ? "זכר" : "נקבה"
            age.text = String(describing: guest?.age ?? Int())
            info.text = guest?.description
            ImageStorageModel.getImage(urlStr: (guest?.imageUrl!)!, callback: { (image) in
                self.image.image = image
            })
        }
       
    }

   
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onDeleteButton(_ sender: Any) {
        
        GuestModel.instance.delete(guest: guest!, onComplete: {guest in
            Logger.log(message: "guest \(guest.name) has been deleted by the admin", event: .i)
        })
        
        dismiss(animated: true, completion: nil)
    }
    @IBAction func onExitButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
  

}
