//
//  SettingsViewController.swift
//  WiTrackApp
//
//  Created by Jamar Brooks on 1/23/16.
//  Copyright © 2016 Jamar. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {

    var alerts = [Setting]()
    var stats = [Setting]()
    var tracking = [Setting]()
    
    let sections = ["Alerts", "Statistics", "Tracking"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        loadSettings()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadSettings() {
        
        alerts.append(Setting(display: "Interrupt Setup", state: "Off"))
        alerts.append(Setting(display: "Interrupt Tracking", state: "On"))
        
        stats.append(Setting(display: "Chart Interaction", state: "Off"))
        
        tracking.append(Setting(display: "Large Multicoloring", state: "Off"))
        tracking.append(Setting(display: "3D Height View", state: "Off"))
        tracking.append(Setting(display: "External Visibility", state: "Off"))
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return something depending on section
        switch section {
            case 0:
                return alerts.count
            case 1:
                return stats.count
            case 2:
                return tracking.count
            default:
                return 0
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "SettingTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! SettingCell
        
        var setting : Setting!
        
        switch indexPath.section {
            case 0:
                setting = alerts[indexPath.row]
                break
            case 1:
                setting = stats[indexPath.row]
                break
            case 2:
                setting = tracking[indexPath.row]
                break
            default:
                setting = Setting(display: "", state: "")
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        cell.displayLabel.text = setting.display_title
        
        if setting.state == "On" {
            cell.options.selectedSegmentIndex = 0
        } else {
            cell.options.selectedSegmentIndex = 1
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // Get the row data for the selected row
        (tableView.cellForRowAtIndexPath(indexPath) as! SettingCell).toggle()
    }
}
