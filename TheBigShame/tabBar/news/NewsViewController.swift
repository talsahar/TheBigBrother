//
//  NewsViewController.swift
//  TheBigShame
//
//  Created by admin on 03/02/2018.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

class NewsViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    var posts=[Post]()
    var dataObserver: Any?
    
    @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataObserver = CentralDBDataModel.instance.hasSyncedNotification.observe(callback: {posts in
            // filter only videos
            self.posts = (posts?.filter({ (post) -> Bool in
                post.content != ""
            }))!
            
            
            
            self.posts.sort(by: {
                p1,p2 in
                p1.date.toDouble()>p2.date.toDouble()
            })
            self.tableView.reloadData()
        })
        CentralDBDataModel.instance.loadAllPostsAndObserve()

        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let backgroundImage = UIImage(named: "livingRoomBackground")
        let imageView = UIImageView(image: backgroundImage)
        imageView.contentMode = .scaleAspectFill
        self.tableView.backgroundView = imageView
       
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsTabCell", for: indexPath) as! NewsTableViewCell
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        cell.clipsToBounds=true
        let post=posts[indexPath.row]
        cell.setData(post: post)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let showController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ShowPostVC") as! ShowPostVC
        showController.post = posts[indexPath.row]
        self.present(showController, animated: true, completion: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
