//
//  LoginViewController.swift
//  WiTrackApp
//
//  Created by Jamar on 11/30/15.
//  Copyright © 2015 Jamar. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destinationController = segue.destinationViewController as! UINavigationController
        let internalViewController = destinationController.topViewController as! ViewController
        internalViewController.username = username.text
        internalViewController.password = password.text
    }


}
