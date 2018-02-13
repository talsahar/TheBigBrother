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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
       delegate?.onVideoPopupCancel()
        
    }
    
    @IBAction func onDone(_ sender: Any) {
        if let videoCode=linkField.text{
            let url=URL(string:"http://www.youtube.com/embed/\(videoCode)")
          	  delegate?.setVideo(url:url)
            dismiss(animated: true, completion: nil)
        }
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
