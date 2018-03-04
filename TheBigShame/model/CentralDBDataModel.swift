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
    
    var postDBObserver:Any?
    var guestHolderDBObserver:Any?
    var guestDBObserver:Any?
    var mutex = DispatchGroup()
    var lock = NSLock()
    
    private init(){
        
        guestDBObserver = GuestModel.instance.notificationCenter.observe(callback: {data in
        })
        
        postDBObserver = PostModel.instance.notificationCenter.observe(callback: {posts in
            self.lock.lock()
            //self.allPosts=posts!
            self.syncGuestsToPosts()
            self.lock.unlock()
        })
        
        guestHolderDBObserver = GuestHolderModel.instance.notificationCenter.observe(callback: {guests in
            self.lock.lock()
            // self.allGuestHolders = guests!
            self.syncGuestsToPosts()
            self.lock.unlock()
            
        })
        
        
    }
    
    func syncGuestsToPosts(){
        let posts = PostModel.instance.data
        posts.forEach{$0.guests.removeAll()}
        
        let guestHolders = GuestHolderModel.instance.data
        
        for guest in guestHolders{
            posts.first(where: {$0.id == guest.postId})?.guests.append(guest)
        }
        hasSyncedNotification.post(data: posts)
        
    }
    
    func loadAllPostsAndObserve(){
        PostModel.instance.loadAndObserve()
        GuestHolderModel.instance.loadAndObserve()
        
        
    }
    
    func savePost(post:Post,image:UIImage?, onComplete:@escaping (Post)->Void){
        
        let storePost={
            PostModel.instance.savePost(data: post){
                _ in
                GuestHolderModel.instance.storeMultipleGuests(list: post.guests){
                    _ in
                    onComplete(post)
                }
            }
        }
        
        image == nil ? storePost() : ImageStorageModel.saveImage(image: image!, name: post.id, onComplete: {url in post.imageUrl=url!
            storePost()
        })
        
    }
    
    func saveGuest(guest:Guest,image:UIImage?, onComplete:@escaping (Guest)->Void){
        let storeGuest={
            GuestModel.instance.saveGuest(data: guest){
                _ in
                onComplete(guest)
            }
        }
        
        
        image == nil ? storeGuest() : ImageStorageModel.saveImage(image: image!, name: String(guest.hashValue), onComplete: {
            url in guest.imageUrl=url!
            storeGuest()
        })
        
    }
    
    func deletePost(post:Post,onComplete: @escaping (Post)->Void){
        Logger.log(message: "Not implemented - to fix", event: .w)
//        GuestHolderModel.instance.deleteMultipleGuestHolders(guests: post.guests, onComplete: {_ in
//            PostModel.instance.deletePost(post: post, onComplete: onComplete)
//        })
    }
    
}
