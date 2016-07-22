//
//  ArtistTableViewCell.swift
//  iOSEventApp
//
//  Created by sunil maharjan on 2/3/16.
//  Copyright © 2016 Swiss Magic. All rights reserved.
//

import UIKit

class ArtistTableViewCell: UITableViewCell {

    @IBOutlet weak var btnRemove: UIButton!
    @IBOutlet weak var textArtistName: UITextFieldWithBottomBorder!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
