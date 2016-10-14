//
//  MenuTableViewController.swift
//  Studifutter
//
//  Created by Florian Heiber on 14.10.2016.
//  Copyright © 2016 rootof.net Heiber & Wiewel GbR. All rights reserved.
//

import UIKit

class MenuTableViewController: UITableViewController {
    var day: Day?
    
    // MARK: - UITableView
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return day?.meals?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCellIdentifier") as! MenuTableViewCell
        
        guard let meal = day?.meals?[indexPath.row] else { return cell }
        cell.configure(meal: meal)
        return cell
    }
}
