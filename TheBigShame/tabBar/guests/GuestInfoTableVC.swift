//
//  GuestInfoTableVC.swift
//  TheBigShame
//
//  Created by admin on 16/02/2018.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

class GuestInfoTableVC: UIViewController, UITableViewDelegate, UITableViewDataSource,NewGuestPopupDelegate{
    
    var dataObserver:Any?
    
    @IBOutlet var navigation: UINavigationBar!
    
    @IBOutlet var tableView: UITableView!
    var data:[Guest]?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundImage = UIImage(named: "livingRoomBackground")
        let imageView = UIImageView(image: backgroundImage)
        imageView.contentMode = .scaleAspectFill
        self.tableView.backgroundView = imageView
        
        if !AuthenticationModel.isAdministrator(){
            navigation.items?.removeLast()
                 }
        
  
        dataObserver = GuestModel.instance.notificationCenter.observe(callback: {
            self.data = $0?.filter{$0.isDeleted == false}
            self.tableView.reloadData()
        })
        data = GuestModel.instance.data.filter{!$0.isDeleted}
    }

    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data!.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GuestInfoCell", for: indexPath) as! GuestInfoCell
        cell.guest = data?[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        let showController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GuestInfoPopup") as! GuestInfoPopup
        showController.guest = data?[indexPath.row]
        self.present(showController, animated: true, completion: nil)
       
    }
    
    @IBAction func onCreateButton(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewGuestPopup") as! NewGuestPopup
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)    }
    
    func onCreate(guest: Guest) {
        tableView.reloadData()
    }
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
