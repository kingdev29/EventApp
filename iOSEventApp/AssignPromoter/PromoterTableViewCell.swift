//
//  PromoterTableViewCell.swift
//  iOSEventApp
//
//  Created by sunil maharjan on 2/25/16.
//  Copyright © 2016 Swiss Magic. All rights reserved.
//

import UIKit

class PromoterTableViewCell: UITableViewCell {

   
    @IBOutlet weak var imgPersonal: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var imgSelection: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

