//
//  GuestInfoCell.swift
//  TheBigShame
//
//  Created by admin on 16/02/2018.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

class GuestInfoCell: MyCell {

    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var name: UILabel!
    var guest:Guest?{
        didSet{
            ImageStorageModel.getImage(urlStr: (guest?.imageUrl!)!, callback: {image in self.profileImage.image = image})
            name.text = guest?.name
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        backgroundColor = .clear
        clipsToBounds=true
    }

  
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
