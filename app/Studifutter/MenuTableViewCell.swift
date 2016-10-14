//
//  MenuTableViewCell.swift
//  Studifutter
//
//  Created by Florian Heiber on 14.10.2016.
//  Copyright © 2016 rootof.net Heiber & Wiewel GbR. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    
    var meal: Meal?
    
    func configure(meal: Meal) {
        self.meal = meal
        
        nameLabel.text = meal.title
        
        let germanLocale = Locale(identifier: "de_DE")
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = germanLocale
        numberFormatter.numberStyle = .currency
        
        // TODO: Generate all the prices here and create a string
        
        // TODO: Concatenate types into a nice string
        
    }
    
    override func prepareForReuse() {
        meal = nil
    }
}
