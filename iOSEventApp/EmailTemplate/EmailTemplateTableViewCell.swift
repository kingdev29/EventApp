//
//  EmailTemplateTableViewCell.swift
//  iOSEventApp
//
//  Created by sunil maharjan on 3/3/16.
//  Copyright © 2016 Swiss Magic. All rights reserved.
//

import UIKit

class EmailTemplateTableViewCell: UITableViewCell {

    @IBOutlet weak var leftImage: UIImageView!
    @IBOutlet weak var lblTemplateName: UILabel!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var separator: UIImageView!
    @IBOutlet weak var lblDescription: UILabel!
    
    @IBAction func btnEditTemplate(sender: UIButton) {
        print("clicked edit")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
