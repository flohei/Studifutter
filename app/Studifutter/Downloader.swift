//
//  Downloader.swift
//  Studifutter
//
//  Created by Florian Heiber on 23/09/2016.
//  Copyright © 2016 rootof.net Heiber & Wiewel GbR. All rights reserved.
//

import Foundation

class Downloader {
    func refreshData() {
        
    }
    
    private func downloadRestaurants() {
        _ = Connection.shared().readRestaurants()
    }
}
