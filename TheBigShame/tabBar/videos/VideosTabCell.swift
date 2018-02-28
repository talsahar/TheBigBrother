//
//  VideosTabCell.swift
//  TheBigShame
//
//  Created by admin on 25/02/2018.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

class VideosTabCell:    MyCell {

    @IBOutlet var coverImage: UIImageView!
    @IBOutlet var video: UIWebView!
    @IBOutlet var content: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
