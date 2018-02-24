//
//  PostFirebase.swift
//  TheBigShame
//
//  Created by admin on 09/02/2018.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation
import Firebase

class PostFirebase : GenericFirebaseMapper{
    
    static let instance = PostFirebase()
    
    private init(){
super.init(childRef: "posts")
    }
   override func initByJson(json: Dictionary<String,Any>)->FirebaseDataProtocol?{
        return Post(json: json)
    }
//    private static let ref = Database.database().reference().child("posts")
//
//    static func storePost(post:Post,onComplete:@escaping (Post)->Void){
//        let json=post.buildJson()
//        ref.child(post.id).setValue(json){(error, dbref) in
//            if error != nil{
//                Logger.log(message: "error store post \(post.id) on firebase ", event: LogEvent.e)
//            }
//            else{
//                Logger.log(message: "stored post \(post.id) on firebase ", event: LogEvent.i)
//                onComplete(post)
//
//            }
//        }
//    }
//
//    static func loadAllPostsAndObserve(_ lastUpdateDate:Date?, onComplete:@escaping ([Post])->Void){
//
//        let handler = {(snapshot:DataSnapshot) in
//            Logger.log(message: "loading all posts from last update: \(lastUpdateDate?.toString ?? "") ", event: LogEvent.i)
//            var posts = [Post]()
//            for postChild in snapshot.children.allObjects{
//                if let postChildData = postChild as? DataSnapshot{
//                    if let postJson = postChildData.value as? Dictionary<String,Any>{
//                        let post = Post(json: postJson)
//                        Logger.log(message: "post \(post.id) has loaded from firebase last update: \(String(describing: post.lastUpdate?.toString)) ", event: LogEvent.i)
//                        posts.append(post)
//
//                        //load post's guests
//
//                    }
//                }
//            }
//            onComplete(posts)
//        }
//
//        if (lastUpdateDate != nil){
//            let query = ref.queryOrdered(byChild:"lastUpdate").queryStarting(atValue:lastUpdateDate?.toDouble())
//            query.observe(DataEventType.value, with: handler)
//        }else{
//            ref.observe(DataEventType.value, with: handler)
//        }
//
//    }
//
//    static func clearObservers(){
//        ref.removeAllObservers()
//    }
//
}



