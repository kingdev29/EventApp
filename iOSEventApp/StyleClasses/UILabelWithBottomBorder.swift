//
//  UILabelWithBottomBorder.swift
//  iOSEventApp
//
//  Created by sunil maharjan on 1/19/16.
//  Copyright © 2016 Swiss Magic. All rights reserved.
//

import UIKit

class UILabelWithBottomBorder: UILabel {

    override func awakeFromNib() {
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.whiteColor().CGColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)
        
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
        
    }

}


class UILabelWithDownInset: UILabel {
    
    override func drawTextInRect(rect: CGRect) {
        super.drawTextInRect(UIEdgeInsetsInsetRect(rect, UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)))
    }
    
    
}


class UILabelWithTopInset: UILabel {
    
    override func drawTextInRect(rect: CGRect) {
        super.drawTextInRect(UIEdgeInsetsInsetRect(rect, UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)))
    }
    
    
}

