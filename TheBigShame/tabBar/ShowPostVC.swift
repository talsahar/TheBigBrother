//
//  ShowPostVC.swift
//  TheBigShame
//
//  Created by admin on 13/02/2018.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

class ShowPostVC: UIViewController ,UICollectionViewDelegate,UICollectionViewDataSource{

    @IBOutlet var guestsCollectionView: UICollectionView!
    @IBOutlet var postVideo: UIWebView!
    @IBOutlet var dateText: UILabel!
    @IBOutlet var author: UILabel!
    @IBOutlet var contentText: UITextView!
    @IBOutlet var titleLabel: UITextView!
    @IBOutlet var postImage: UIImageView!
    
    var post:Post?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setData(post: post!)
        guestsCollectionView.delegate = self
    }

    func setData(post:Post){
        self.titleLabel.text = post.title
        self.contentText.text = post.content
        self.author.text = post.userId
        self.dateText.text = post.date.onlyDate()
        
        if post.imageUrl != ""{
            ImageStorageModel.getImage(urlStr: post.imageUrl, callback: {image in self.postImage.image = image})
        }
        
        if post.videoUrl != ""{
            let videoUrl=URL(string: post.videoUrl)
            postVideo.loadRequest(URLRequest(url:videoUrl!))

        }
        else{
            postVideo.loadRequest(URLRequest.init(url: URL.init(string: "about:blank")!))
            
        }
    }
    
    //view collection
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (post?.guests.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell=collectionView.dequeueReusableCell(withReuseIdentifier: "GuestCollectionViewCell", for: indexPath) as! GuestCollectionViewCell
        let guest=post?.guests[indexPath.row].guest
        cell.name.text=guest?.name
        ImageStorageModel.getImage(urlStr: (guest?.imageUrl)!, callback: {image in cell.imageView.image = image})
      
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }}
