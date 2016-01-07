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
    var ipAddress : String?
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
    
    func onFrames(data : Array<AnyObject>) {
        print("data", data)
        if data.count > 0 {
            var positions = [Position]()
            let frame = data[0] as! NSMutableDictionary
            let personList = frame["people"] as! NSArray
            if personList.count > 0 {
                let person = personList[0] as! NSMutableDictionary
                let currentPosition = Position(x: person["x"]! as! Float, y: person["y"]! as! Float, z: person["z"]! as! Float, personId: person["person_id"]! as! Int)
                
                canvas.moveSilently((x: (currentPosition.x! - minX) * Float(canvas.frame.size.width) / (maxX - minX), y: (currentPosition.y! - minY) * Float(canvas.frame.size.height) / (maxY - minY), color: colorWheel[0]), personId: currentPosition.personId!)
                
                for k in 0...personList.count - 1 {
                    let p = personList[k] as! NSMutableDictionary
                    let pos = Position(x: p["x"]! as! Float, y: p["y"]! as! Float, z: p["z"]! as! Float, personId: p["person_id"]! as! Int)
                    positions.append(pos)
                }
            }
            canvas.update(positions)
        }
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
