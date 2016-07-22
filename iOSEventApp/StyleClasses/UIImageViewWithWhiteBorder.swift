//
//  UIImageViewWithWhiteBorder.swift
//  iOSEventApp
//
//  Created by sunil maharjan on 1/19/16.
//  Copyright © 2016 Swiss Magic. All rights reserved.
//

import UIKit
import QuartzCore

class UIImageViewWithWhiteBorder: UIImageView {

    override func awakeFromNib() {
        self.awakeFromNib()
        self.layer.masksToBounds = true
        self.layer.borderColor = UIColor.whiteColor().CGColor
        self.layer.borderWidth = 1
    }
    
}
