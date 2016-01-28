//
//  LoginViewController.swift
//  WiTrackApp
//
//  Created by Jamar on 11/30/15.
//  Copyright © 2015 Jamar. All rights reserved.
//

import Alamofire
import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    var token: String!
    var userId: Int!
    var devices = [Device]()
    
    @IBOutlet weak var errorLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if let savedToken = loadCredentials() {
            self.token = savedToken.token
            self.userId = savedToken.userId
            if self.token != "" {
                getDevices(savedToken.token)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func showSecondViewController(sender: UIButton) {
        let parameters = [
            "email": username.text!,
            "password": password.text!
        ]
        
        Alamofire.request(.POST, "https://www.devemerald.com/api/v1/token/generate", parameters: parameters)
            .responseJSON { [weak self] response in
                if let val = response.result.value {
                    let data = val as! NSDictionary
                    if data["success"]! as! NSObject == 1 {
                        self!.errorLabel.text = ""
                        self!.token = data["data"]!["token"] as! String
                        self!.userId = data["data"]!["user"] as! Int
                        
                        self!.saveCredentials()
                        
                        self!.getDevices(self!.token)
                    } else {
                        self!.errorLabel.text = "Username and/or password incorrect.\nPlease try again."
                    }
                    print("STOP")
                } else {
                    self!.errorLabel.text = "Unable to get devices for this user. Server may be unavailable."
                }
        }
    }

    func getDevices(token: String) {
        let header = [
            "X-Token": token
        ]
        
        Alamofire.request(.POST, "https://www.devemerald.com/api/v1/user/devices", headers: header)
            .responseJSON { [weak self] response in
                if let val = response.result.value {
                    let data = val as! NSDictionary
                    print(data)
                    if data["success"]! as! NSObject == 1 {
                        let devices = data["data"]! as! [AnyObject]
                        for i in 0...devices.count - 1 {
                            let device = devices[i]
                            
                            let id = device["id"] as! Int
                            let realtime_access = device["realtimeAccess"] as! Int
                            let setup_id = device["setupId"] as! Int
                            let setup_title = device["setupTitle"] as! String
                            let title = device["title"] as! String
                            
                            let newDevice = Device(id: id, realtime_access: realtime_access, setup_id: setup_id, setup_title: setup_title, title: title)
                            
                            self!.devices.append(newDevice)
                        }
                        
                        self?.performSegueWithIdentifier("loginSegue", sender: self)
                    } else {
                        self!.errorLabel.text = "Username and/or password incorrect."
                    }
                } else {
                    self!.errorLabel.text = "Unable to get devices for this user. Server may be unavailable."
                }
        }
    }
    
    // MARK: - NSCoding
    
    func saveCredentials() {
        let signin = SignInInfo(token: token, userId: userId)
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(signin!, toFile: SignInInfo.ArchiveURL.path!)
        if !isSuccessfulSave {
            print("Failed to save credentials...")
        }
    }
    
    func loadCredentials() -> SignInInfo? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(SignInInfo.ArchiveURL.path!) as? SignInInfo
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    /*override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let parameters = [
            "email": username.text!,
            "password": password.text!
        ]
        Alamofire.request(.POST, "https://www.devemerald.com/api/v1/token/generate", parameters: parameters)
            .responseJSON { [weak self] response in
                let data = response.result.value! as! NSDictionary
                if data["success"]! as! NSObject == 1 {
                    let token = data["data"]!["token"]
                    let userId = data["data"]!["user"]
                    
                    let destinationController = segue.destinationViewController as! UINavigationController
                    let internalViewController = destinationController.topViewController as! ViewController
                    internalViewController.username = self!.username.text
                    internalViewController.password = self!.password.text
                    internalViewController.userId = userId as! Int
                    internalViewController.token = token as! String
                    
                    self?.performSegueWithIdentifier("loginSegue", sender: self!)
                }
                // print(data[0]!.user)
                print("STOP")
        }
    }*/

    

}
