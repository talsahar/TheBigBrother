//
//  NewsTableViewController.swift
//  TheBigShame
//
//  Created by admin on 03/02/2018.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

class NewsTableViewController: UITableViewController{

    var posts=[Post]()
    var dataObserver: Any?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PostModel.instance.postListNotification.observe(callback: {posts in
            self.posts = posts!
            self.tableView.reloadData()
        })
        PostModel.instance.loadAllPostsAndObserve()
        
        self.clearsSelectionOnViewWillAppear = false
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsTabCell", for: indexPath) as! NewsTableViewCell
        cell.clipsToBounds=true
        let post=posts[indexPath.row]
        cell.cellDate.text=post.date.description
        cell.cellTitle.text=post.title
        cell.cellDescription.text=post.content

        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140.0
    }
   
    @IBAction func backToNewsSegue(segue: UIStoryboardSegue) {
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
