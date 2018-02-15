//
//  CentralDataModel.swift
//  TheBigShame
//
//  Created by admin on 15/02/2018.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation
import UIKit
class CentralDBDataModel{
    
    let hasSyncedNotification = MyNotification<[Post]>(name: "centralDBNotification")

    
    static let instance = CentralDBDataModel()
    
    var allPosts = [Post]()
    var allGuests = [GuestHolder]()
    var waitingGuests = [GuestHolder]()
    var postDBObserver:Any?
    var guestDBObserver:Any?
    var mutex = DispatchGroup()
    var lock = NSLock()
    
    private init(){
        postDBObserver = PostModel.instance.postListNotification.observe(callback: {posts in
        self.lock.lock()
        self.allPosts=posts!
            self.syncGuestsToPosts()
        self.lock.unlock()
        })
        
        guestDBObserver = GuestModel.instance.guestListNotification.observe(callback: {guests in
        self.lock.lock()
            self.allGuests = guests!
            self.syncGuestsToPosts()
        self.lock.unlock()

        })
        
        
    }
    
    func syncGuestsToPosts(){
        for post in allPosts{
            post.guests.removeAll()
        }
        
        for guest in allGuests{
            allPosts.first(where: {$0.id == guest.postId})?.guests.append(guest)
        }
        hasSyncedNotification.post(data: allPosts)

    }
    
    func loadAllPostsAndObserve(){
        
     PostModel.instance.loadAllPostsAndObserve()
    GuestModel.instance.loadAllGuestsAndObserve()
        
        
    }
    
    func storePost(post:Post,image:UIImage?, onComplete:@escaping (Post)->Void){
        let storePost={
            PostSql.instance.insert(post: post)
            PostFirebase.storePost(post: post, onComplete: {post in
                GuestModel.instance.storeMultipleGuests(list: post.guests, onComplete: { guests in
                    onComplete(post)
                })
            })
        }
        //store image
        if image != nil{
            ImageStorageModel.saveImage(image: image!, name: post.id, onComplete: {url in
                post.imageUrl=url!
                storePost()
            })
        }
            //store without an image
        else{
            storePost()
        }
        
    }
    
    
}
