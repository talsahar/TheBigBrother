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
    
    var data = [Post]()
    
    let notificationCenter = MyNotification<[Post]>(name: "postListNotification")
    
    var dataObserver:Any?
    
    private init(){}
    
    func savePost(data:Post, onComplete:@escaping (Post)->Void){
        data.setChanged()
            PostSql.instance.insert(post: data)
        PostFirebase.instance.store(data: data, onComplete: {data in onComplete(data as! Post)})
        }
    
    
    func loadAndObserve(){
        PostFirebase.instance.clearObservers()
        let tableName=PostSql.instance.TABLE_NAME
        let lastupdateDate=LastUpdateTable.instnace.getLastUpdate(tableName: tableName)
        
        PostFirebase.instance.loadAllDataAndObserve(lastupdateDate) { posts in
            if posts.count > 0{
                let posts = posts as! [Post]
                posts.forEach{PostSql.instance.insert(post: $0)}
                
                var newLastUpdate = posts.map{$0.lastUpdate?.toDouble()}.max(by: {$0! < $1!})
                newLastUpdate = newLastUpdate!! + 1
                LastUpdateTable.instnace.setLastUpdate(tableName: tableName, lastUpdate: Date.fromDouble(newLastUpdate!!))
                
                self.loadAndObserve()
            }
            self.data = PostSql.instance.selectAll()
            self.notificationCenter.post(data: self.data)
        }
        
    }
}


