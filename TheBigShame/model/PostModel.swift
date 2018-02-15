//
//  PostDbManager.swift
//  TheBigShame
//
//  Created by admin on 09/02/2018.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation
import UIKit
class PostModel{
    
    static let instance = PostModel()
    
    var data : [Post]?
    
    let postListNotification = MyNotification<[Post]>(name: "postListNotification")
    
    var dataObserver:Any?
    
    private init(){
        dataObserver = postListNotification.observe { posts in
            self.data=posts!
        }
    }
    
    func storePost(post:Post,image:UIImage?, onComplete:@escaping (Post)->Void){
        let storePost={
            PostSql.instance.insert(post: post)
            PostFirebase.storePost(post: post, onComplete: {post in
                onComplete(post)
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
    
    func loadAllPostsAndObserve(){
        
        let tableName=PostSql.instance.TABLE_NAME
        let lastupdateDate=LastUpdateTable.instnace.getLastUpdate(tableName: tableName)
        
        PostFirebase.loadAllPostsAndObserve(lastupdateDate) { posts in
            
            posts.forEach{PostSql.instance.insert(post: $0)}
            
            let newLastUpdate = posts.map{$0.lastUpdate?.toDouble()}.max(by: {$0! < $1!})
            LastUpdateTable.instnace.setLastUpdate(tableName: tableName, lastUpdate: Date.fromDouble(newLastUpdate!!))
            
            let posts=PostSql.instance.selectAll()
            self.postListNotification.post(data: posts)
            
        }
        
    }
}


