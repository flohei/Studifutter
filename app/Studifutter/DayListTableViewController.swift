//
//  DayListViewController.swift
//  Studifutter
//
//  Created by Florian Heiber on 14.10.2016.
//  Copyright © 2016 rootof.net Heiber & Wiewel GbR. All rights reserved.
//

import UIKit

extension Date {
    var localizedMonthName: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        formatter.locale = Locale.current
        return formatter.string(from: self)
    }
}

class DayListTableViewController: UITableViewController {
    var cafeteria: Cafeteria?
    var sections: [String: [Day]] {
        
        guard let days = cafeteria?.days else { return [:] }
        
        var sectionsAssembly: [String: [Day]] = [:]
        
        for day in days {
            // Get the month string for day.date
            guard let date = day.date else { continue }
            let monthString = date.localizedMonthName
            
            // Try to get the array for that month
            var monthArray = sectionsAssembly[monthString]
            
            if monthArray != nil {
                // If there's one add this day to it.
                monthArray?.append(day)
            } else {
                // If there's none, go ahead, create a new entry in sectionsAssembly, and add the day
                sectionsAssembly[monthString] = [day]
            }
        }
        
        return sectionsAssembly
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowMenu" {
//            let destination = segue.destination as! MenuViewController
        }
    }
    
    // MARK: - UITableView
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let monthAtIndex = Array(sections.keys)[section]
        return sections[monthAtIndex]?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DayCellIdentifier") as! DayTableViewCell
        cell.configure(day: (cafeteria?.days?[indexPath.row])!)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let monthAtIndex = Array(sections.keys)[section]
        return monthAtIndex
    }
}
