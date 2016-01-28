//
//  PositionViewController.swift
//  WiTrack
//
//  Created by Jamar on 10/29/15.
//  Copyright © 2015 Jamar. All rights reserved.
//

import UIKit

class PositionViewController: UIViewController, NSStreamDelegate {

    var userId : Int?
    var token : String?
    var points : [(x:Float, y:Float)]?
    var positions = [Position]()
    var currentPoint : (x: Float, y: Float, personId: Int)?
    var socket : SocketIOClient?
    
    var colorWheel : [UIColor] = [UIColor.purpleColor(), UIColor.redColor(), UIColor.grayColor(), UIColor.greenColor(), UIColor.blackColor(), UIColor.blueColor(), UIColor.brownColor(), UIColor.cyanColor(), UIColor.yellowColor(), UIColor.orangeColor(), UIColor.magentaColor(), UIColor.lightGrayColor(), UIColor.darkGrayColor()]
    
    @IBOutlet weak var canvas: DrawingCanvas!
    @IBOutlet weak var primary: UIButton!
    @IBOutlet weak var secondary: UIButton!
    let tapRecognizer = UITapGestureRecognizer()
    let longPressRec = UILongPressGestureRecognizer()
    
    /*let pinchRec = UIPinchGestureRecognizer()
    let swipeRec = UISwipeGestureRecognizer()
    let rotateRec = UIRotationGestureRecognizer()
    let panRec = UIPanGestureRecognizer()*/
    
    var recordingMode = 0
    var tracking = false
    var trackingId = -1
    var minX : Float = -4.0
    var maxX : Float = 4.0
    var minY : Float = 0.0
    var maxY : Float = 14.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        points = []
        
        // tapRecognizer.addTarget(self, action: "tappedView:")
        longPressRec.addTarget(self, action: "longPress:")
        // canvas.addGestureRecognizer(tapRecognizer)
        canvas.addGestureRecognizer(longPressRec)
        canvas.userInteractionEnabled = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tappedView(sender: UITapGestureRecognizer){
        let touchLocation = sender  .locationInView(tapRecognizer.view)
        let tapAlert = UIAlertController(title: "Tapped", message: "You just tapped the tap view", preferredStyle: UIAlertControllerStyle.Alert)
        tapAlert.addAction(UIAlertAction(title: "OK", style: .Destructive, handler: nil))
        self.presentViewController(tapAlert, animated: true, completion: nil)
    }
    
    func longPress(sender: UILongPressGestureRecognizer) {
        if sender.state.rawValue == 1 {
            if !tracking && positions.count > 0 {
                let touchLocation = sender.locationInView(longPressRec.view)
                trackingId = getClosestLocation(Float(touchLocation.x), y: Float(touchLocation.y), positions: positions)
                tracking = true
                let tapAlert = UIAlertController(title: "Mode Notification", message: "You are now tracking id \(trackingId). To turn off tracking, press and hold anywhere", preferredStyle: UIAlertControllerStyle.Alert)
                tapAlert.addAction(UIAlertAction(title: "OK", style: .Destructive, handler: nil))
                self.presentViewController(tapAlert, animated: true, completion: nil)
            } else if positions.count > 0 {
                tracking = false
                trackingId = -1
                let tapAlert = UIAlertController(title: "Mode Notification", message: "You have turned off tracking.", preferredStyle: UIAlertControllerStyle.Alert)
                tapAlert.addAction(UIAlertAction(title: "OK", style: .Destructive, handler: nil))
                self.presentViewController(tapAlert, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func StartStop(sender: UIButton) {
        print(primary.titleLabel!.text!)
        if (primary.titleLabel!.text! == "Start") {
            tracking = true
            //record( currentPoint!.x, y: currentPoint!.y, personId: currentPoint!.personId)
            primary.setTitle("Stop", forState: UIControlState.Normal)
            if (recordingMode == 0) {
                secondary.setTitle("Record", forState: UIControlState.Normal)
            } else {
                secondary.setTitle("Pause Recording", forState: UIControlState.Normal)
            }
        } else {
            tracking = false
            canvas.saveCurrentPath()
            primary.setTitle("Start", forState: UIControlState.Normal)
            secondary.setTitle((recordingMode == 0) ? "Corner Making" : "Continuous", forState: UIControlState.Normal)
        }
    }
    
    @IBAction func Secondary(sender: UIButton) {
        if (primary.titleLabel!.text! == "Start") {
            if (secondary.titleLabel!.text! == "Corner Marking") {
                secondary.setTitle("Continuous", forState: UIControlState.Normal)
                recordingMode = 1
            } else {
                secondary.setTitle("Corner Marking", forState: UIControlState.Normal)
                recordingMode = 0
            }
        } else {
            if (secondary.titleLabel!.text! == "Record") {
                tracking = true
                secondary.setTitle("Pause Recording", forState: UIControlState.Normal)
                /*let tapAlert = UIAlertController(title: "Tapped", message: "You just tapped the tap view", preferredStyle: UIAlertControllerStyle.Alert)
                tapAlert.addAction(UIAlertAction(title: "OK", style: .Destructive, handler: nil))
                self.presentViewController(tapAlert, animated: true, completion: nil)*/
            } else {
                tracking = false
                secondary.setTitle("Record", forState: UIControlState.Normal)
            }
        }
    }
    
    func record(x : Float, y : Float, personId : Int) {
        print("recording")
        if (tracking) {
            canvas.move((x: x, y: y, color: UIColor.redColor()), personId: personId)
            points!.append((x: x, y: y))
            currentPoint = (x: x, y: y, personId)
            if (recordingMode == 0) {
                tracking = false
                secondary.setTitle("Record", forState: UIControlState.Normal)
            }
        } else {
            canvas.moveSilently((x: x, y: y, color: UIColor.greenColor()), personId: personId)
            currentPoint = (x: x, y: y, personId)
        }
    }
    
    func record(personList : NSArray) {
        positions.removeAll()
        for k in 0...personList.count - 1 {
            let p = personList[k] as! NSMutableDictionary
            let pos = Position(x: (p["x"]! as! Float - minX) * Float(canvas.frame.size.width) / (maxX - minX), y: (p["y"]! as! Float - minY) * Float(canvas.frame.size.height) / (maxY - minY), z: p["z"]! as! Float, personId: p["personId"]! as! Int)
            positions.append(pos)
        }
        canvas.update(positions)
    }
    
    func record(personList : NSArray, personId : Int) -> Bool {
        positions.removeAll()
        for k in 0...personList.count - 1 {
            let p = personList[k] as! NSMutableDictionary
            let pId = p["personId"]! as! Int
            if pId == personId {
                let pos = Position(x: (p["x"]! as! Float - minX) * Float(canvas.frame.size.width) / (maxX - minX), y: (p["y"]! as! Float - minY) * Float(canvas.frame.size.height) / (maxY - minY), z: p["z"]! as! Float, personId: pId)
                positions.append(pos)
            }
        }
        canvas.update(positions)
        return true
    }
    
    func getClosestLocation(x: Float, y: Float, positions : [Position]) -> Int {
        var min : Float = Float(Int.max)
        var minId = positions.count
        for k in 0...positions.count - 1 {
            var distanceMetric = powf(x - positions[k].x!, 2) + powf(y - positions[k].y!, 2)
            if distanceMetric < min {
                minId = positions[k].personId!
                min = distanceMetric
            }
        }
        return minId
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
