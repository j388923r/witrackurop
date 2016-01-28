//
//  SetupDeviceSegue.swift
//  WiTrackApp
//
//  Created by Jamar Brooks on 1/27/16.
//  Copyright © 2016 Jamar. All rights reserved.
//

import UIKit

class SetupDeviceSegue: UIStoryboardSegue {
    
    override func perform() {
        // Assign the source and destination views to local variables.
        let firstVC = self.sourceViewController as! AddDeviceTableViewController
        let secondVC = self.destinationViewController as! SetupController
        
        secondVC.userId = firstVC.userId!
        secondVC.token = firstVC.token!
        secondVC.device = firstVC.deviceToSetup
        
        // Get the screen width and height.
        let screenWidth = UIScreen.mainScreen().bounds.size.width
        let screenHeight = UIScreen.mainScreen().bounds.size.height
        
        // Specify the initial position of the destination view.
        secondVC.view.frame = CGRectMake(0.0, screenHeight, screenWidth, screenHeight)
        
        // Access the app's key window and insert the destination view above the current (source) one.
        let window = UIApplication.sharedApplication().keyWindow
        window?.insertSubview(secondVC.view, aboveSubview: firstVC.view)
        
        // Animate the transition.
        UIView.animateWithDuration(0.4, animations: { () -> Void in
            firstVC.view.frame = CGRectOffset(firstVC.view.frame, 0.0, -screenHeight)
            secondVC.view.frame = CGRectOffset(secondVC.view.frame, 0.0, -screenHeight)
            
            }) { (Finished) -> Void in
                self.sourceViewController.presentViewController(self.destinationViewController as UIViewController,
                    animated: false,
                    completion: nil)
        }
    }
}
