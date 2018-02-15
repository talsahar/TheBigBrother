//
//  PressableButton.swift
//  TimeToTravel
//
//  Created by Admin on 09/12/2017.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

@IBDesignable class PressableButton: UIButton {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.transform=CGAffineTransform(scaleX: 1.1, y: 1.1)
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 6, options: .allowUserInteraction, animations: {
            self.transform=CGAffineTransform.identity

        }, completion: nil)
       super.touchesBegan(touches, with: event)
    }
    
    @IBInspectable var borderWidth: CGFloat = 0.0{
        didSet{
            self.layer.borderWidth=borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear{
        didSet{
            self.layer.borderColor=borderColor.cgColor
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat=0{
        didSet{
            self.layer.cornerRadius=cornerRadius
        }
    }
}
