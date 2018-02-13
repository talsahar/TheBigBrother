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
    var isBinding:Bool?
    
    private init(){
        dataObserver = postListNotification.observe { posts in
            self.data=posts!
         //   self.locker.leave()
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
            ImageStorageManager.saveImage(image: image!, name: post.id, onComplete: {url in
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
        
            if data==nil{
                let tableName=PostSql.instance.TABLE_NAME
                let lastupdateDate=LastUpdateTable.instnace.getLastUpdate(tableName: tableName)
                
                PostFirebase.loadAllPostsAndObserve(lastupdateDate) { posts in
                    if posts.count>0{
                        //update last update
                        var maxPost=posts[0]
                        var maxValue:Double = 0
                        for post in posts{
                            PostSql.instance.insert(post: post)
                            if (post.lastUpdate?.toDouble())!>maxValue{
                                maxPost=post
                                maxValue=(maxPost.lastUpdate?.toDouble())!
                            }
                        }
                        LastUpdateTable.instnace.setLastUpdate(tableName: tableName, lastUpdate: Date.fromDouble(maxValue))
                        
                        let posts=PostSql.instance.selectAll()
                        self.postListNotification.post(data: posts)
                        
                    }
                    
                }
            }
            
     
        
    }
}
