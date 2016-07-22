//
//  GenreTableViewCell.swift
//  iOSEventApp
//
//  Created by sunil maharjan on 1/19/16.
//  Copyright © 2016 Swiss Magic. All rights reserved.
//

import UIKit

class GenreTableViewCell: UITableViewCell {

    // MARK: - Properties
    @IBOutlet weak var btnCheckBox: UIButtonWithBorder!
    @IBOutlet weak var lblGenreType: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
