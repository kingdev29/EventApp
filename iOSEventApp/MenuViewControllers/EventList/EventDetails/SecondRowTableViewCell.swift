//
//  SecondRowTableViewCell.swift
//  iOSEventApp
//
//  Created by Kiran Thapa on 1/12/16.
//  Copyright © 2016 Swiss Magic. All rights reserved.
//

import UIKit

class SecondRowTableViewCell: UITableViewCell {
    // MARK: Properties
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
