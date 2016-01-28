//
//  SettingCell.swift
//  WiTrackApp
//
//  Created by Jamar Brooks on 1/23/16.
//  Copyright © 2016 Jamar. All rights reserved.
//

import UIKit

class SettingCell: UITableViewCell {

    @IBOutlet weak var displayLabel: UILabel!
    @IBOutlet weak var options: UISegmentedControl!
    
    func toggle() {
        options.selectedSegmentIndex = (options.selectedSegmentIndex + 1) % 2
    }
}
