//
//  AddDeviceViewController.swift
//  WiTrackApp
//
//  Created by Jamar Brooks on 12/8/15.
//  Copyright © 2015 Jamar. All rights reserved.
//

import UIKit

class AddDeviceViewController: UIViewController {
    
    @IBOutlet weak var deviceName: UITextField!
    @IBOutlet weak var locationName: UITextField!
    @IBOutlet weak var realtimeAccess: UISegmentedControl!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        // Configuration
        
    }

    @IBAction func Cancel(sender: AnyObject) {
        // realtimeAccess.selectedSegmentIndex
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if saveButton === sender {
            
        }
    }
}