//
//  LabelListTableViewCell.swift
//  iOSEventApp
//
//  Created by Kiran Thapa on 3/21/16.
//  Copyright © 2016 Swiss Magic. All rights reserved.
//

import UIKit

class LabelListTableViewCell: UITableViewCell {
    // MARK: Properties
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func loadCell(labelName: String, count: String) {
        self.nameLabel.text = labelName
        self.countLabel.text = count
    }

}
