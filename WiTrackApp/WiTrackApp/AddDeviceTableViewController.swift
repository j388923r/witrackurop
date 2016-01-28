//
//  AddDeviceTableViewController.swift
//  WiTrackApp
//
//  Created by Jamar Brooks on 1/27/16.
//  Copyright © 2016 Jamar. All rights reserved.
//

import UIKit

class AddDeviceTableViewController: UITableViewController {

    var userId : Int?
    var token : String?
    var devices : [Device]!
    var addedDevices = [Device]()
    var setupDevices = [Device]()
    var brandNewDevices = [Device]()
    var savedDevices : [WantedDevice]!
    var deviceToSetup : Device!
    var setupTimer : NSTimer?
    var setupAgreed : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        savedDevices = loadSavedDevices()
        loadDeviceTable()
    }
    
    func loadDeviceTable() {
        for i in 0..<devices.count {
            let device : Device = devices[i]
            var saved = false
            for j in 0..<savedDevices.count {
                if device.id != 2 && device.title == savedDevices[j].title && device.id == savedDevices[j].deviceId {
                    addedDevices.append(device)
                    saved = true
                    break
                }
            }
            if !saved {
                if device.id != 2 && device.setup_title != ""{
                    setupDevices.append(device)
                } else {
                    brandNewDevices.append(device)
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
            case 0:
                return "Saved Devices"
            case 1:
                return "Setup Devices"
            case 2:
                return "New or Moved Devices"
            default:
                return ""
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return something depending on section
        switch section {
            case 0:
                return max(addedDevices.count, 1)
            case 1:
                return max(setupDevices.count, 1)
            case 2:
                return max(brandNewDevices.count, 1)
            default:
                return 0
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "AddDeviceTableCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! AddDeviceCell
        
        cell.userInteractionEnabled = true
        
        // Configure the cell...
        var device : Device?
        
        switch indexPath.section {
            case 0:
                if addedDevices.count != 0 {
                    device = addedDevices[indexPath.row]
                    cell.tapAffordance.setTitle("Remove", forState: .Normal)
                } else {
                    cell.deviceLabel.text = "No saved devices."
                    cell.userInteractionEnabled = false
                    cell.tapAffordance.setTitle("", forState: .Normal)
                }
            case 1:
                if setupDevices.count != 0 {
                    device = setupDevices[indexPath.row]
                    cell.tapAffordance.setTitle("Save", forState: .Normal)
                } else {
                    cell.deviceLabel.text = "No setup devices not yet saved to this device."
                    cell.userInteractionEnabled = false
                    cell.tapAffordance.setTitle("", forState: .Normal)
                }
            case 2:
                if brandNewDevices.count != 0 {
                    device = brandNewDevices[indexPath.row]
                    cell.tapAffordance.setTitle("Setup", forState: .Normal)
                } else {
                    cell.deviceLabel.text = "No new devices to be setup."
                    cell.userInteractionEnabled = false
                    cell.tapAffordance.setTitle("", forState: .Normal)
                }
            default:
                break
        }
        
        cell.tapAffordance.userInteractionEnabled = false

        if (device != nil) {
            cell.deviceLabel.text = device!.title
        }
        
        return cell
    }
    
    @IBAction func logoutAction(sender: UIBarButtonItem) {
        let nextViewController : LogoutViewController = self.storyboard?.instantiateViewControllerWithIdentifier("LogoutViewController") as! LogoutViewController
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let clearLoginInfo = SignInInfo(token: "", userId: -1)
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(clearLoginInfo!, toFile: SignInInfo.ArchiveURL.path!)
        if isSuccessfulSave {
            appDelegate.window!.rootViewController = nextViewController
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // Get the row data for the selected row
        switch indexPath.section {
            case 0:
                let selectedDevice = addedDevices[indexPath.row]
                
                let removeAlert = UIAlertController(title: "Remove Device?", message: "Are you sure you would like to remove \(selectedDevice.title) from your shown devices?", preferredStyle: UIAlertControllerStyle.Alert)
                removeAlert.addAction(UIAlertAction(title: "Remove", style: .Destructive, handler: {(alert: UIAlertAction!) in
                    print("removed")
                    let removedDevice = self.addedDevices.removeAtIndex(indexPath.row)
                    self.setupDevices.append(removedDevice)
                    self.tableView.reloadData()
                }))
                removeAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: nil))
                self.presentViewController(removeAlert, animated: true, completion: nil)
            case 1:
                let selectedDevice = setupDevices[indexPath.row]
                let saveAlert = UIAlertController(title: "Save Device?", message: "Are you sure you would like to save \(selectedDevice.title) to your phone?", preferredStyle: UIAlertControllerStyle.Alert)
                saveAlert.addAction(UIAlertAction(title: "Save", style: .Default, handler: {(alert: UIAlertAction!) in
                    print("saved")
                    let savedDevice = self.setupDevices.removeAtIndex(indexPath.row)
                    self.addedDevices.append(savedDevice)
                    self.tableView.reloadData()
                }))
                saveAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: nil))
                self.presentViewController(saveAlert, animated: true, completion: nil)
            case 2:
                deviceToSetup = brandNewDevices[indexPath.row]
                let setupAlert = UIAlertController(title: "Setup Device?", message: "Are you sure you would like to setup Device \(deviceToSetup.title) now?", preferredStyle: UIAlertControllerStyle.Alert)
                setupAlert.addAction(UIAlertAction(title: "Setup", style: .Default, handler: {(alert: UIAlertAction!) in
                    self.setupAgreed = true
                }))
                setupAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: {(alert: UIAlertAction!) in
                    self.setupTimer?.invalidate()
                    self.setupTimer = nil
                }))
                
                self.presentViewController(setupAlert, animated: true, completion: nil)
                
                setupTimer = NSTimer.scheduledTimerWithTimeInterval(0.3, target: self, selector: "initiateSetup:", userInfo: nil, repeats: true)
            default:
                break
        }
    }
    
    func initiateSetup(timer : NSTimer) {
        if self.setupAgreed {
            timer.invalidate()
            self.performSegueWithIdentifier("setupDeviceSegue", sender: self)
        }
    }
    
    func saveDevices() {
        savedDevices = [WantedDevice]()
        for i in 0..<addedDevices.count {
            savedDevices.append(WantedDevice(title: addedDevices[i].title, deviceId: addedDevices[i].id)!)
        }
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(savedDevices, toFile: WantedDevice.ArchiveURL.path!)
        if !isSuccessfulSave {
            print("Failed to save credentials...")
        }
    }
    
    func loadSavedDevices() -> [WantedDevice]? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(WantedDevice.ArchiveURL.path!) as? [WantedDevice]
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "setupDeviceSegue" {
            if let next = segue.destinationViewController as? SetupController {
                let indexPath = tableView.indexPathForSelectedRow
                switch (indexPath?.section)! {
                case 2:
                    next.device = devices[(indexPath?.row)!]
                    break;
                default:
                    break;
                }
                next.token = token
                next.userId = userId
            }
        } else if segue.identifier == "saveDevicesSegue" || segue.identifier == "cancelAddSegue" {
            if segue.identifier == "saveDevicesSegue" {
                saveDevices()
            }
            if let nav = segue.destinationViewController as? UINavigationController {
                if let next = nav.topViewController as? DeviceSelectorViewController{
                    next.devices = devices
                    next.token = token
                    next.userId = userId
                }
            }
        }
    }

}
