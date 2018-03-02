//
//  VideosTab.swift
//  TheBigShame
//
//  Created by admin on 25/02/2018.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

class VideosTab: UIViewController,UITableViewDelegate,UITableViewDataSource ,NewVideoVCProtocol{
    
    

    @IBOutlet var tableview: UITableView!
    var posts=[Post]()
    var dataObserver: Any?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundImage = UIImage(named: "livingRoomBackground")
        let imageView = UIImageView(image: backgroundImage)
        imageView.contentMode = .scaleAspectFill
        tableview.backgroundView = imageView
        
        
        posts = PostModel.instance.data.filter{$0.videoUrl != ""}
        dataObserver = CentralDBDataModel.instance.hasSyncedNotification.observe(callback: {posts in
            self.posts = (posts?.filter{$0.videoUrl != ""})!
            
            self.posts.sort(by: {
                p1,p2 in
                p1.date.toDouble()>p2.date.toDouble()
            })
            
            self.tableview.reloadData()
        })
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

   
    @IBAction func onAddVideo(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewVideoVC") as! NewVideoVC
        vc.delegate = self as! NewVideoVCProtocol
        self.present(vc, animated: true, completion: nil)     }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return posts.count
    }

    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VideosTabCell", for: indexPath) as! VideosTabCell
        let videoUrl=URL(string: posts[indexPath.row].videoUrl)
        cell.video.loadRequest(URLRequest(url:videoUrl!))
        cell.content.text = posts[indexPath.row].title
        return cell
    }
    
   
    func onCancel() {
        
    }
    
    func onAdd(post: Post) {
        
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
