//
//  DisplayOnlyViewController.swift
//  WiTrackApp
//
//  Created by Jamar on 11/30/15.
//  Copyright © 2015 Jamar. All rights reserved.
//

import UIKit

class DisplayOnlyViewController: UIViewController {

    var userId : Int?
    var token : String?
    var points : [(x:Float, y:Float)]?
    var positions : [Position]?
    var currentPoint : (x: Float, y: Float)?
    var currentPoints : [(x: Float, y: Float)] = []
    var socket : SocketIOClient?
    
    @IBOutlet weak var canvas: DrawingCanvas!
    
    var colorWheel : [UIColor] = [UIColor.redColor(), UIColor.purpleColor(), UIColor.grayColor(), UIColor.greenColor(), UIColor.blackColor(), UIColor.blueColor(), UIColor.brownColor(), UIColor.cyanColor(), UIColor.yellowColor(), UIColor.orangeColor(), UIColor.magentaColor(), UIColor.lightGrayColor(), UIColor.darkGrayColor()]
    
    var recordingMode = 0
    var tracking = false
    var minX : Float = -4.0
    var maxX : Float = 4.0
    var minY : Float = 0.0
    var maxY : Float = 14.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
