//
//  NewVideoVC.swift
//  TheBigShame
//
//  Created by admin on 01/03/2018.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

protocol NewVideoVCProtocol{
    func onCancel()
    func onAdd(post:Post)
}

class NewVideoVC: UIViewController ,VideoLinkPopupDelegate{

    @IBOutlet var videoTitle: UITextField!
    @IBOutlet var videoView: UIWebView!
    @IBOutlet var errorField: UILabel!
    var delegate:NewVideoVCProtocol?
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    var videoUrl:URL?{
        didSet{
            if videoUrl != nil{
                videoView.loadRequest(URLRequest(url:videoUrl!))
            }
            else{
                videoView.loadRequest(URLRequest.init(url: URL.init(string: "about:blank")!))
            }
            spinner.stopAnimating()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.videoUrl = nil
        
       
    }
    
  

    @IBAction func onAddVideo(_ sender: Any) {
        spinner.startAnimating()
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "VideoLinkPopup") as! VideoLinkPopup
        newViewController.delegate=self
        self.present(newViewController, animated: true, completion: nil)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func onAdd(_ sender: Any) {
        if (videoTitle.text?.count)! < 5
        {
            errorField.text = "כותרת קצרה מידי"
            
        }
        else if videoUrl == nil{
                errorField.text = "לא נטען ווידאו"
            }
        else{
            spinner.startAnimating()
            let newPostVideo = Post(id: UUID().uuidString, date: Date(), title: videoTitle.text!, userId: (AuthenticationModel.getCurrentUser()?.displayName)!, content: "", imageUrl: nil, videoUrl: videoUrl?.absoluteString, guests: nil, comments: nil, lastUpdate: nil, isDeleted: false)
            CentralDBDataModel.instance.savePost(post: newPostVideo, image: nil, onComplete: { (post) in
                self.delegate?.onAdd(post: newPostVideo)
                self.dismiss(animated: true, completion: nil)
                })
        }
    }
    @IBAction func onCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    

   
    
    func setVideo(url:URL?) {
        self.videoUrl=url
    }
    
    func onVideoPopupCancel() {
        spinner.stopAnimating()
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
