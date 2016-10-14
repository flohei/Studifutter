//
//  CafeteriaTableViewCell.swift
//  Studifutter
//
//  Created by Florian Heiber on 14.10.2016.
//  Copyright © 2016 Florian Heiber. All rights reserved.
//

import UIKit

class CafeteriaTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    var cafeteria: Cafeteria? = nil
    
    func configure(cafeteria: Cafeteria) {
        self.cafeteria = cafeteria
        nameLabel.text = cafeteria.title
        addressLabel.text = cafeteria.address?.stringRepresentation
    }
    
    override func prepareForReuse() {
        cafeteria = nil
    }
}
