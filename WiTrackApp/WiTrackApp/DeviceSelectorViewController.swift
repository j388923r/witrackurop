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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // self.title = "Device List"
        // loadSampleDevices()
    }

    func loadSampleDevices() {
        let device1 = Device(id: 1, realtime_access: 1, setup_id: 1, setup_title: "CSAIL Test Devices", title: "Virtual Device")
        
        let device2 = Device(id: 2, realtime_access: 1, setup_id: 1, setup_title: "CSAIL Test Devices", title: "Dina's Office (user02)")
        
        devices.append(device1)
        devices.append(device2)
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
        return devices.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "DeviceTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! DeviceCell
        
        // Configure the cell...
        let device = devices[indexPath.row]
        
        cell.nameLabel.text = device.title
        if device.realtime_access != 1 {
            cell.userInteractionEnabled = false;
            cell.textLabel!.enabled = false;
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
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "accessDeviceSegue" {
            if let destinationController = segue.destinationViewController as? ViewController {
                let tableView = self.view as! UITableView
                if let deviceIndex = tableView.indexPathForSelectedRow?.row {
                    destinationController.device = devices[deviceIndex]
                    destinationController.token = token
                }
            }
        }
    }


}
