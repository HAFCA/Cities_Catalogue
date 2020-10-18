//
//  File.swift
//  VilleControll
//
//  Created by hafca on 6/15/20.
//  Copyright © 2020 hafca. All rights reserved.
//

import Foundation
class Ville {
    var nom: String
    var image: String
    var note : String
    


init(nom: String, image: String,note: String = "") {
    self.nom = nom
    self.image = image
    self.note = note
}

convenience init() {
    self.init(nom: "", image: "")
}
}
