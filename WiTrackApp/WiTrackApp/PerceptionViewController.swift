//
//  PerceptionViewController.swift
//  WiTrackApp
//
//  Created by Jamar Brooks on 1/26/16.
//  Copyright © 2016 Jamar. All rights reserved.
//

import UIKit

class PerceptionViewController: UIViewController {

    var stage : Int = 0
    var deviceId = 2
    var token : String!
    
    var socket : SocketIOClient!
    
    var minX : Float = -4.0
    var maxX : Float = 4.0
    var minY : Float = 0.0
    var maxY : Float = 14.0
    
    var tracking = true
    var trackingId = -1
    
    var positions = [Position]()
    
    @IBOutlet weak var canvas: IndicatorCanvas!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
