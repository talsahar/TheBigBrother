//
//  NewPostViewController.swift
//  TheBigShame
//
//  Created by admin on 03/02/2018.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import TextFieldEffects
import SwiftSpinner

protocol EditingDelegate{
    func onEditDone(post:Post)
    func onEditCancel()
}


class CreatePostViewController: UITableViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate, UICollectionViewDelegate,UICollectionViewDataSource,VideoLinkPopupDelegate{
   
    @IBOutlet var navigationBar: UINavigationItem!
    var editingModePost:Post?
    var editingDelegate:EditingDelegate?
    
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
        if imageUrl != ""{
           ImageStorageModel.getImage(urlStr: imageUrl!, callback: {image in cell.imageView.image = image})
        }
       
        cell.ticker.setSelected(guestPair.value, animated: true)
        let onSwitch={
            self.guestMapArr![indexPath.row].value = !self.guestMapArr![indexPath.row].value        }
        
        cell.onSWitch=onSwitch
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        content.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        if let tableView = self.view as? UITableView {
            let imageView = UIImageView(image: UIImage(named: "background1"))
            tableView.backgroundView = imageView
            
            self.guestMapArr=GuestModel.getBoolMapArray()
            
            // on editing mode.
            editingModePost != nil ? asEditingMode(post: editingModePost!) : nil
            
        }
        
    }
    override func viewDidAppear(_ animated: Bool) {
        let backgroundImage = UIImage(named: "livingRoomBackground")
        let imageView = UIImageView(image: backgroundImage)
        imageView.contentMode = .scaleAspectFill
        self.tableView.backgroundView = imageView
    }
    
 
    @IBAction func onComplete(_ sender: Any) {
        SwiftSpinner.show("Storing your Post..")
        let chosenGuests=GuestModel.filterChosens(list: guestMapArr!)
        let post = Post(id: UUID().uuidString, date: Date(), title: titleField.text!, userId: (AuthenticationModel.getCurrentUser()?.displayName)!, content: content.text, imageUrl: nil, videoUrl: videoUrl?.absoluteString, guests: chosenGuests, comments: nil, lastUpdate: nil,isDeleted: false)
      
        if editingModePost != nil{
            post.id = (editingModePost?.id)!
        }
        
        CentralDBDataModel.instance.savePost(post: post, image: chosenImage, onComplete: {post in
            SwiftSpinner.hide(){
                self.editingDelegate?.onEditDone(post: post)
                self.dismiss(animated: true, completion: nil)
            }
        })
       
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
    
   //on edit mode
    func asEditingMode(post:Post){
        navigationBar.title = "עריכת פוסט"
        self.titleField.text = post.title
        self.content.text = post.content
        if post.videoUrl != ""{
            self.videoUrl = URL(string:post.videoUrl)

        }
        if post.imageUrl != ""{
            ImageStorageModel.getImage(urlStr: post.imageUrl, callback: {
                $0 != nil ? self.chosenImage = $0 : nil
            })
        }
        
        for i in 0..<guestMapArr!.count{
            if post.guests.contains(where: {
                $0.guest.name == guestMapArr![i].key.name
            }){
                guestMapArr![i].value = true
            }
        }
        
       
        
        
       
    }

    
}
