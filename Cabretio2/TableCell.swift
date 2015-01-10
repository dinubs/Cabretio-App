//
//  TableCell.swift
//  Cabretio2
//
//  Created by Gavin Dinubilo on 12/4/14.
//  Copyright (c) 2014 Gavin Dinubilo. All rights reserved.
//

import Foundation
import UIKit

class TableCell: UITableViewCell {
    
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var likes: UILabel!
    @IBOutlet weak var content: UILabel!
    
    func configure() {
        self.textLabel?.font
    }
    
}