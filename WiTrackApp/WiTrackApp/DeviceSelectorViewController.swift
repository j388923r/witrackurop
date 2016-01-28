//
//  DeviceSelectorViewController.swift
//  WiTrackApp
//
//  Created by Jamar Brooks on 12/4/15.
//  Copyright © 2015 Jamar. All rights reserved.
//

import UIKit
import Alamofire

class DeviceSelectorViewController: UITableViewController {

    var userId : Int?
    var token : String?
    var devices : [Device]!
    var displayDevices = [Device]()
    var savedDevices : [WantedDevice]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        savedDevices = loadSavedDevices()
        loadDeviceTable()
    }
    
    func loadDeviceTable() {
        for j in 0..<savedDevices!.count {
            for i in 0..<devices.count {
                let device : Device = devices[i]
                if device.title == savedDevices![j].title && device.id == savedDevices![j].deviceId {
                    displayDevices.append(device)
                    break
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return something depending on section
        return displayDevices.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "DeviceTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! DeviceCell
        
        // Configure the cell...
        let device = displayDevices[indexPath.row]
        
        cell.nameLabel.text = device.title
        if device.realtime_access != 1 {
            cell.userInteractionEnabled = false;
            cell.textLabel!.enabled = false;
        }
        
        return cell
    }
    
    func loadSavedDevices() -> [WantedDevice]? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(WantedDevice.ArchiveURL.path!) as? [WantedDevice]
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
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "accessDeviceSegue" {
            if let destinationController = segue.destinationViewController as? ViewController {
                let tableView = self.view as! UITableView
                if let deviceIndex = tableView.indexPathForSelectedRow?.row {
                    destinationController.device = displayDevices[deviceIndex]
                    destinationController.token = token
                }
            }
        } else if segue.identifier == "addDeviceSegue" {
            if let destinationController = segue.destinationViewController as? AddDeviceTableViewController {
                // destinationController.navigationItem.backBarButtonItem?.title = "Cancel"
                destinationController.devices = devices
                destinationController.token = token!
                destinationController.userId = userId!
            }
        }
    }


}
