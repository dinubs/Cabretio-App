//
//  NavigationController.swift
//  Cabretio2
//
//  Created by Gavin Dinubilo on 12/4/14.
//  Copyright (c) 2014 Gavin Dinubilo. All rights reserved.
//

import Foundation
import UIKit

class NavigationController: UINavigationController, UIViewControllerTransitioningDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Status bar white font
        self.navigationBar.tintColor = UIColor(rgba: "#ffffff")
        self.navigationBar.barTintColor = UIColor(rgba: "#2196f3")//UIColor(rgba: "#4caf50")
    }
}