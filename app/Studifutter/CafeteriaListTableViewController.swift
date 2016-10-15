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
    var cafeterias: [Cafeteria] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    func loadData() {
        DataManager.shared.getCafeterias { cafeterias in
            self.cafeterias = cafeterias
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDayList" {
            let destination: DayListTableViewController = segue.destination as! DayListTableViewController
            let selectedIndexPath = tableView.indexPathForSelectedRow
            let cafeteria: Cafeteria = cafeterias[selectedIndexPath!.row]
            destination.cafeteria = cafeteria
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
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}
