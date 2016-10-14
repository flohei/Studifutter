//
//  DayTableViewCell.swift
//  Studifutter
//
//  Created by Florian Heiber on 14.10.2016.
//  Copyright © 2016 rootof.net Heiber & Wiewel GbR. All rights reserved.
//

import UIKit

class DayTableViewCell: UITableViewCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var menuLabel: UILabel!
    
    var day: Day?
    
    func configure(day: Day) {
        self.day = day
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd."
        
        guard let date = day.date else { return }
        let dateString = dateFormatter.string(from: date)
        dateLabel.text = dateString
        
        // TODO: Update the string here
        menuLabel.text = "Omnomnom"
    }
    
    override func prepareForReuse() {
        day = nil
    }
}
