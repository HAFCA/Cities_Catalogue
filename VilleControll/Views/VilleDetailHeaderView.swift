//
//  VilleDetailHeaderView.swift
//  VilleControll
//
//  Created by hafca on 6/15/20.
//  Copyright © 2020 hafca. All rights reserved.
//

import UIKit

class VilleDetailHeaderView: UIView {
    
    @IBOutlet var headerImageView: UIImageView!
    
    @IBOutlet var nomLabel: UILabel! {
        didSet {
            nomLabel.numberOfLines = 0
        }
    }

    
    @IBOutlet var noteImageView: UIImageView!

  

}
