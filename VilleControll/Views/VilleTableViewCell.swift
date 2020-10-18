//
//  VilleTableViewCell.swift
//  VilleControll
//
//  Created by hafca on 6/15/20.
//  Copyright © 2020 hafca. All rights reserved.
//

import UIKit

class VilleTableViewCell: UITableViewCell {
    
    @IBOutlet var labelNom: UILabel!
    
    
    
    @IBOutlet var imageViewPhoto: UIImageView! {
        didSet {
            imageViewPhoto.layer.cornerRadius = imageViewPhoto.bounds.width / 2
            imageViewPhoto.clipsToBounds = true
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
