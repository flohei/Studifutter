//
//  SFWidgetViewController.swift
//  Studifutter
//
//  Created by Florian Heiber on 06/06/14.
//  Copyright (c) 2014 rootof.net Heiber & Wiewel GbR. All rights reserved.
//

import UIKit
import NotificationCenter

class SFWidgetViewController: UIViewController, NCWidgetProviding {
    
    override func awakeFromNib()  {
        super.awakeFromNib()
        
        // this is important and needs to be set to the interfaces size
//        [self setPreferredContentSize:[[self view] contentSize]];
        
    }
    
    
    // NCWidgetProviding protocol functions
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
        
    }
}
