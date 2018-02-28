//
//  NewsTableViewCell.swift
//  TheBigShame
//
//  Created by admin on 03/02/2018.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

class NewsTableViewCell: MyCell {
    @IBOutlet var cellImage: UIImageView!
    @IBOutlet var cellDate: UILabel!
    @IBOutlet var cellDescription: UITextView!
    @IBOutlet var cellTitle: UILabel!
    @IBOutlet var imageSpinner: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setData(post:Post){
        if post.imageUrl != ""{
            imageSpinner.startAnimating()
            ImageStorageModel.getImage(urlStr: post.imageUrl, callback: { (image) in
                if image != nil{
                    self.cellImage.image = image
                    self.imageSpinner.stopAnimating()
                }
            })
        }
        cellDate.text = post.date.onlyDate()
        cellTitle.text = post.title
        cellDescription.text = post.content
    }
}
