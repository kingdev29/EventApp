//
//  FirstRowTableViewCell.swift
//  iOSEventApp
//
//  Created by Kiran Thapa on 1/12/16.
//  Copyright © 2016 Swiss Magic. All rights reserved.
//

import UIKit

class FirstRowTableViewCell: UITableViewCell {
    
    // MARK: Properties
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
