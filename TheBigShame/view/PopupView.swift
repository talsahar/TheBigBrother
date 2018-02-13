//
//  PopupView.swift
//  TheBigShame
//
//  Created by admin on 11/02/2018.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

class PopupView: UIView {

  
    override func draw(_ rect: CGRect) {
        layer.borderWidth = 2
        layer.cornerRadius = 5
        layer.borderColor = UIColor.white.cgColor
         dropShadow(v:self,color: .black, opacity: 1, offSet: CGSize(width: -1, height: 1), radius: 3, scale: true)
        
    }
    func dropShadow(v:UIView,color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        v.layer.masksToBounds = false
        v.layer.shadowColor = color.cgColor
        v.layer.shadowOpacity = opacity
        v.layer.shadowOffset = offSet
        v.layer.shadowRadius = radius
        
        v.layer.shadowPath = UIBezierPath(rect: v.bounds).cgPath
        v.layer.shouldRasterize = true
        v.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
  
}
