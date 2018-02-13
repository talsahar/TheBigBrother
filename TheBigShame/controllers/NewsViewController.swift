//
//  NewsViewController.swift
//  TheBigShame
//
//  Created by admin on 03/02/2018.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

class NewsViewController: UIViewController {

    @IBOutlet var tableViewContainer: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tableViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewsTableViewController") as! NewsTableViewController
        
        self.addChildViewController(tableViewController)
        tableViewController.view.frame = tableViewContainer.frame
        tableViewController.view.frame.origin=CGPoint(x:0,y:0)
        tableViewContainer.addSubview(tableViewController.view)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
