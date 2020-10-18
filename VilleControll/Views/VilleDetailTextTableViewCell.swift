//
//  VilleDetailTextTableViewCell.swift
//  VilleControll
//
//  Created by hafca on 6/15/20.
//  Copyright © 2020 hafca. All rights reserved.
//

import UIKit

class VilleDetailTextCell: UITableViewCell {
    
    @IBOutlet var descriptionLabel: UILabel! {
        didSet {
            descriptionLabel.numberOfLines = 0
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}



