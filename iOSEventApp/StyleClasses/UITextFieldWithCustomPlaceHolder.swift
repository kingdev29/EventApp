//
//  UITextFieldWithClearBorder.swift
//  iOSEventApp
//
//  Created by sunil maharjan on 1/13/16.
//  Copyright © 2016 Swiss Magic. All rights reserved.
//

import UIKit

class UITextFieldWithCustomPlaceHolder: UITextField {

    override func awakeFromNib() {
        self.setValue(UIColor.whiteColor(), forKeyPath: "_placeholderLabel.textColor")
    }

}
