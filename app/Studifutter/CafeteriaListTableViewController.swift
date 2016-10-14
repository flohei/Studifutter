//
//  CafeteriaListTableViewController.swift
//  Studifutter
//
//  Created by Florian Heiber on 12.10.2016.
//  Copyright © 2016 Florian Heiber. All rights reserved.
//

import UIKit

/// Replaces the old `SFRestaurantViewController` and displays a list of all the restaurants we have.
class CafeteriaListTableViewController: UITableViewController {
    var cafeterias: [Cafeteria] = []
    var selectedCafeteria: Cafeteria?
    
    func reloadData() {
        cafeterias = DataManager.shared.getCafeterias()
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDayList" {
            let destination: DayListTableViewController = segue.destination as! DayListTableViewController
            destination.cafeteria = selectedCafeteria
            selectedCafeteria = nil
        }
    }
    
    // MARK: UITableView
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cafeterias.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CafeteriaCellIdentifier") as! CafeteriaTableViewCell
        cell.configure(cafeteria: cafeterias[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCafeteria = cafeterias[indexPath.row]
    }
}
