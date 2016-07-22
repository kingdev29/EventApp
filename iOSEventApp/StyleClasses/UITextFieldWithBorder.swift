//
//  UITextFieldWithBorder.swift
//  iOSEventApp
//
//  Created by sunil maharjan on 1/8/16.
//  Copyright © 2016 Swiss Magic. All rights reserved.
//

import UIKit

class UITextFieldWithBorder: UITextField {

       override func awakeFromNib() {
        self.layer.cornerRadius = 0.0
        self.layer.masksToBounds = true
        self.layer.borderColor = UIColor.whiteColor().CGColor
        self.layer.borderWidth = 1.0
        // Change placeholder color
        self.setValue(UIColor(red: 138.0/255.0, green: 142.0/255.0, blue: 157.0/255.0, alpha: 1.0), forKeyPath: "_placeholderLabel.textColor")
    }


}
