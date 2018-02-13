//
//  GuestCollectionViewCell.swift
//  TheBigShame
//
//  Created by admin on 04/02/2018.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import AIFlatSwitch

protocol OnSwitchDelegate{
    func tick();
}

class GuestCollectionViewCell: UICollectionViewCell {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var ticker: AIFlatSwitch!
    @IBOutlet var name: UILabel!
    
    var onSWitch:(()->())?
    
    @IBAction func onSwitch(_ sender: Any) {
        onSWitch!()
    }
   
    
}
