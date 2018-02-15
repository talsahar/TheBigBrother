//
//  VideoLinkPopup.swift
//  TheBigShame
//
//  Created by admin on 06/02/2018.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit


protocol VideoLinkPopupDelegate{
    func setVideo(url:URL?)
    func onVideoPopupCancel()
}

class VideoLinkPopup: UIViewController {

    @IBOutlet var popView: UIView!
    @IBOutlet var linkField: UITextField!
    var delegate:VideoLinkPopupDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.layer.cornerRadius=10
        view.layer.masksToBounds=true
        
    }

    @IBAction func onCancel(_ sender: Any) {
        dismiss(animated: true, completion: {
            self.delegate?.onVideoPopupCancel()
        })
       
        
    }
    
    @IBAction func onDone(_ sender: Any) {
        if let videoCode=linkField.text{
            let url=URL(string:"http://www.youtube.com/embed/\(videoCode)")
          	  delegate?.setVideo(url:url)
            dismiss(animated: true, completion: nil)
        }
        
    }
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
