//
//  TheBigShame
//
//  Created by admin on 15/02/2018.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

class TabBarVC: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.selectedIndex = 3
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func tabBarUnwind(segue: UIStoryboardSegue) {
        
    }
  
  
    
}
