//
//  UIButtonWithGreyBg.swift
//  iOSEventApp
//
//  Created by Kiran Thapa on 1/19/16.
//  Copyright © 2016 Swiss Magic. All rights reserved.
//

import UIKit

class UIButtonWithGreyBg: UIButton {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    override func awakeFromNib() {
        self.layer.backgroundColor = UIColor(red: 89.0/255, green: 91.0/255, blue: 112.0/255, alpha: 1.0).CGColor
        self.titleLabel!.font = UIFont(name: "HelveticaNeue", size: 15.0)
        self.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        
    }

}
