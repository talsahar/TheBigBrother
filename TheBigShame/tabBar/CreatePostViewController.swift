//
//  NewPostViewController.swift
//  TheBigShame
//
//  Created by admin on 03/02/2018.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import TextFieldEffects




class CreatePostViewController: UITableViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate, UICollectionViewDelegate,UICollectionViewDataSource,VideoLinkPopupDelegate{
   
    
    var guestMapArr: [(key: Guest, value: Bool)]?

    @IBOutlet var imageSpinner: UIActivityIndicatorView!
    @IBOutlet var videoSpinner: UIActivityIndicatorView!
    
    @IBOutlet var titleField: UITextField!
    
    @IBOutlet var content: UITextView!
    @IBOutlet var imageView: UIImageView!
    var chosenImage:UIImage?{
        didSet{
            if chosenImage != nil{
                self.imageView.image=chosenImage
            }
            else{
                self.imageView.image=UIImage(named:"add_picture")
            }
            imageSpinner.stopAnimating()
        }
    }
    
    @IBOutlet var noVideoImage: UIImageView!
    @IBOutlet var videoView: UIWebView!
    var videoUrl:URL?{
        didSet{
            if videoUrl != nil{
                videoView.loadRequest(URLRequest(url:videoUrl!))
                noVideoImage.isHidden=true
            }
            else{
                videoView.loadRequest(URLRequest.init(url: URL.init(string: "about:blank")!))
                noVideoImage.isHidden=false
            }
            videoSpinner.stopAnimating()
        }
    }
    
    
    
    
    //view collection
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (guestMapArr?.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell=collectionView.dequeueReusableCell(withReuseIdentifier: "GuestCollectionViewCell", for: indexPath) as! GuestCollectionViewCell
        let guestPair=guestMapArr![indexPath.row]
        cell.name.text=String(describing: guestPair.key.name)
        let imageUrl=guestPair.key.imageUrl
        ImageStorageModel.getImage(urlStr: imageUrl!, callback: {image in cell.imageView.image = image})
        
        cell.ticker.setSelected(guestPair.value, animated: true)
        let onSwitch={
            self.guestMapArr![indexPath.row].value = !self.guestMapArr![indexPath.row].value        }
        
        cell.onSWitch=onSwitch
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imageSpinner.stopAnimating()
        self.videoSpinner.stopAnimating()
        content.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        if let tableView = self.view as? UITableView {
            let imageView = UIImageView(image: UIImage(named: "background1"))
            tableView.backgroundView = imageView
            
            self.guestMapArr=GuestModel.getBoolMapArray()
        }
        
    }
    @IBAction func onComplete(_ sender: Any) {
        
        let chosenGuests=GuestModel.filterChosens(list: guestMapArr!)
      
        let post=Post(date: Date(), title: titleField.text!, userId: (AuthenticationModel.getCurrentUser()?.displayName!)!, content: content.text, videoUrl: (videoUrl?.absoluteString)!, guests: chosenGuests, comments: nil, lastUpdate: nil)
        
        CentralDBDataModel.instance.savePost(post: post, image: chosenImage, onComplete: {post in self.dismiss(animated: true, completion: nil)})
       
    }
    //picture
    @IBAction func onAddPicture(_ sender: Any) {
        imageSpinner.startAnimating()
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
        imageSpinner.stopAnimating()    
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let possibleImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            self.chosenImage=possibleImage
        } else if let possibleImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            self.chosenImage=possibleImage
        } else {
            return
        }
        dismiss(animated: true)
    }
    
    @IBAction func onDeletePicture(_ sender: Any) {
        chosenImage=nil
    }
    
    //video
    
    @IBAction func onAddVideo(_ sender: Any) {
        videoSpinner.startAnimating()
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "VideoLinkPopup") as! VideoLinkPopup
        newViewController.delegate=self
        self.present(newViewController, animated: true, completion: nil)
    }
    
    @IBAction func onDeleteVideo(_ sender: Any) {
        self.videoUrl = nil
    }
    func setVideo(url:URL?) {
        self.videoUrl=url
    }
    
    func onVideoPopupCancel() {
        videoSpinner.stopAnimating()
    }
    

    //header aligment right
    
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        //  header.textLabel?.font = UIFont(name: "YourFontname", size: 14.0)
        header.textLabel?.textAlignment = NSTextAlignment.right
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
   
   
    
}
