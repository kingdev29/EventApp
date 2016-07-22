//
//  PriceTableViewCell.swift
//  iOSEventApp
//
//  Created by sunil maharjan on 2/5/16.
//  Copyright © 2016 Swiss Magic. All rights reserved.
//

import UIKit

class PriceTableViewCell: UITableViewCell {

    @IBOutlet weak var btnRemove: UIButton!
    @IBOutlet weak var textTo: UITextFieldWithBorder!
    @IBOutlet weak var textFrom: UITextFieldWithBorder!
    @IBOutlet weak var textPrice: UITextFieldWithBorder!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }

}
