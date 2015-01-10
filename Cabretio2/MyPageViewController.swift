//
//  MyPageViewController.swift
//  Cabretio2
//
//  Created by Gavin Dinubilo on 12/17/14.
//  Copyright (c) 2014 Gavin Dinubilo. All rights reserved.
//

import UIKit
import AlamoFire

class MyPageViewController: UIViewController {
    
    let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    
    override func viewDidLoad() {
        if (appDelegate.userEmail == "") {
            println("YES")
            self.performSegueWithIdentifier("goToLoginPage", sender: self)
        }
        
    }
    override func viewDidAppear(animated: Bool) {
        if (appDelegate.userEmail == "") {
            self.performSegueWithIdentifier("goToLoginPage", sender: self)
        }
    }
    
}
