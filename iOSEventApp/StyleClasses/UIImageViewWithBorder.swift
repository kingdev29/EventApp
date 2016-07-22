//
//  UIImageViewWithBorder.swift
//  iOSEventApp
//
//  Created by Kiran Thapa on 1/13/16.
//  Copyright © 2016 Swiss Magic. All rights reserved.
//

import UIKit

class UIImageViewWithBorder: UIImageView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    override func awakeFromNib() {
        self.layer.borderColor = Constants.brightBlueColor.CGColor
        self.layer.borderWidth = 2.0
        
    }

}
