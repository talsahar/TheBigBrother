//
//  NewsTableViewCell.swift
//  TheBigShame
//
//  Created by admin on 03/02/2018.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    @IBOutlet var cellImage: UIImageView!
    @IBOutlet var cellDate: UILabel!
    @IBOutlet var cellDescription: UITextView!
    @IBOutlet var cellTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
