//
//  CafeteriaDetailViewController.swift
//  Studifutter
//
//  Created by Florian Heiber on 14.10.2016.
//  Copyright © 2016 rootof.net Heiber & Wiewel GbR. All rights reserved.
//

import UIKit
import MapKit

class CafeteriaDetailViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var favoriteButton: FHStarButton!
    
    var cafeteria: Cafeteria?
    
    
}
