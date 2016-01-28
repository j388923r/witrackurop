//
//  AddDeviceViewController.swift
//  WiTrackApp
//
//  Created by Jamar Brooks on 12/8/15.
//  Copyright © 2015 Jamar. All rights reserved.
//

import UIKit

class AddDeviceViewController: UIViewController {
    
    var chosenDevice : Device!
    var token : String!
    var userId : Int!
    
    var visibleDevices = [WantedDevice]()
    
    @IBOutlet weak var deviceName: UITextField!
    @IBOutlet weak var locationName: UITextField!
    @IBOutlet weak var realtimeAccess: UISegmentedControl!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configuration
        visibleDevices = loadDevices()!
        // print(visibleDevices[0].title)
    }
    
    func loadSampleDevices() {
        let device1 = WantedDevice(title: "Virtual Device", deviceId: 1)
        
        let device2 = WantedDevice(title: "Dina's Office (user03)", deviceId: 3)
        
        visibleDevices.append(device1!)
        visibleDevices.append(device2!)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.navigationItem.backBarButtonItem?.title = "Cancel"
    }
    
    func saveDevices() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(visibleDevices, toFile: WantedDevice.ArchiveURL.path!)
        if !isSuccessfulSave {
            print("Failed to save credentials...")
        }
    }
    
    func loadDevices() -> [WantedDevice]? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(WantedDevice.ArchiveURL.path!) as? [WantedDevice]
    }

    @IBAction func Cancel(sender: AnyObject) {
        // realtimeAccess.selectedSegmentIndex
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        saveDevices()
        if saveButton === sender {
            let next = segue.destinationViewController as! SetupController
            
            next.device = chosenDevice
            next.token = token
            next.userId = userId
        }
    }
}