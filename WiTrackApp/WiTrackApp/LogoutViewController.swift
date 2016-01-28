//
//  LogoutViewController.swift
//  WiTrackApp
//
//  Created by Jamar on 11/29/15.
//  Copyright © 2015 Jamar. All rights reserved.
//

import UIKit

class LogoutViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let seconds = 1.0
        let delay = seconds * Double(NSEC_PER_SEC)  // nanoseconds per seconds
        let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        
        dispatch_after(dispatchTime, dispatch_get_main_queue(), {
            
            // here code perfomed with delay
            let nextViewController : LoginViewController = self.storyboard?.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
            
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.window!.rootViewController = nextViewController
            
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
