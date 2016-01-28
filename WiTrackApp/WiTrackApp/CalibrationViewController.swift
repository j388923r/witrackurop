//
//  CalibrationViewController.swift
//  WiTrackApp
//
//  Created by Jamar Brooks on 1/25/16.
//  Copyright © 2016 Jamar. All rights reserved.
//

import UIKit

class CalibrationViewController: UIViewController {
    
    var stage : Int = 0
    var deviceId = 2
    var token : String!
    
    var socket : SocketIOClient!
    let longPressRec = UILongPressGestureRecognizer()
    
    var minX : Float = -4.0
    var maxX : Float = 4.0
    var minY : Float = 0.0
    var maxY : Float = 14.0
    
    var tracking = false
    var trackingId = -1
    
    var positions = [Position]()

    @IBOutlet weak var canvas: IndicatorCanvas!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        longPressRec.addTarget(self, action: "longPress:")
        canvas.addGestureRecognizer(longPressRec)
        canvas.userInteractionEnabled = true
    }
    
    override func viewDidAppear(animated: Bool) {
        let seconds = 1.2
        let delay = seconds * Double(NSEC_PER_SEC)  // nanoseconds per seconds
        let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        
        dispatch_after(dispatchTime, dispatch_get_main_queue(), {
            
            let firstActionAlert = UIAlertController(title: "First Action", message: "Hello! First, select select yourself by pressing and holding your dot. Then, move directly in front of the device and step 2 meters away.", preferredStyle: UIAlertControllerStyle.Alert)
            firstActionAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(firstActionAlert, animated: true, completion: nil)
            
        })
    }
    
    func longPress(sender: UILongPressGestureRecognizer) {
        if sender.state.rawValue == 1 {
            if !tracking && positions.count > 0 {
                let touchLocation = sender.locationInView(longPressRec.view)
                trackingId = getClosestLocation(Float(touchLocation.x), y: Float(touchLocation.y), positions: positions)
                tracking = true
                let tapAlert = UIAlertController(title: "Setup Tracking", message: "You are now tracking id \(trackingId). Please press OK and move toward the yellow dot.", preferredStyle: UIAlertControllerStyle.Alert) //To reset tracking, press and hold anywhere
                tapAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                self.presentViewController(tapAlert, animated: true, completion: nil)
            } else if positions.count > 0 {
                tracking = false
                trackingId = -1
                let tapAlert = UIAlertController(title: "Setup Tracking", message: "You have turned off tracking. Please select someone to track for device setup.", preferredStyle: UIAlertControllerStyle.Alert)
                tapAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                self.presentViewController(tapAlert, animated: true, completion: nil)
            }
        }
    }
    
    func getClosestLocation(x: Float, y: Float, positions : [Position]) -> Int {
        var min : Float = Float(Int.max)
        var minId = positions.count
        for k in 0...positions.count - 1 {
            let distanceMetric = powf(x - positions[k].x!, 2) + powf(y - positions[k].y!, 2)
            if distanceMetric < min {
                minId = positions[k].personId!
                min = distanceMetric
            }
        }
        return minId
    }
    
    func track(positions : [Position]) {
        self.positions = positions
        if tracking {
            switch stage {
                case 0, 2:
                    canvas.update([Position(x: (0.0 - minX) * Float(canvas.frame.size.width) / (maxX - minX), y: (2.0 - minY) * Float(canvas.frame.size.height) / (maxY - minY), z: 0.8, personId: 100693)] + positions, stage: stage)
                case 1:
                    let stageMarkers = [Position(x: (-1.0 - minX) * Float(canvas.frame.size.width) / (maxX - minX), y: (2.0 - minY) * Float(canvas.frame.size.height) / (maxY - minY), z: 0.8, personId: 100693)]
                    
                    canvas.update(stageMarkers + positions, stage: stage)
                default:
                    canvas.update(positions)
                    break
            }
        } else {
            canvas.update(positions)
        }
    }
    
    func detectEvent() -> Bool {
        switch self.stage {
            case 0, 2:
                if tracking && positions.count > 0 {
                    let ym = (positions[positions.count - 1].y! * (maxY - minY) / Float(canvas.frame.size.height) + minY)
                    let xm = (positions[positions.count - 1].x! * (maxX - minX) / Float(canvas.frame.size.width) + minX)
                    if ym > 1.8 && ym < 2.2 && xm < 0.2 && xm > -0.2 {
                        return true
                    }
                }
            case 1:
                if tracking && positions.count > 0 {
                    let ym = (positions[positions.count - 1].y! * (maxY - minY) / Float(canvas.frame.size.height) + minY)
                    let xm = (positions[positions.count - 1].x! * (maxX - minX) / Float(canvas.frame.size.width) + minX)
                    if ym > 1.8 && ym < 2.2 && xm < -0.8 && xm > -1.2 {
                        return true
                    }
                }
            default:
                return false
        }
        return false
    }
    
    func restartStages() {
        self.stage = 0
    }
    
    func previousStage() {
        self.stage = max(self.stage - 1, 0)
    }
    
    func nextStage() {
        switch stage {
            case 0:
                //X increases to the right
                let twoMeterAlert = UIAlertController(title: "Success", message: "The device has successfully detected that you are two meters away. Next, please press OK and then take 3 steps to your right.", preferredStyle: UIAlertControllerStyle.Alert)
                twoMeterAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: {(action : UIAlertAction) in
                        self.canvas.setIndication(false)
                    }))
                self.presentViewController(twoMeterAlert, animated: true, completion: nil)
                break
            case 1:
                //X decreases to the left
                let stepRightAlert = UIAlertController(title: "Success", message: "Thank you. Now, press OK and take 3 steps to your left.", preferredStyle: UIAlertControllerStyle.Alert)
                stepRightAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: {(action : UIAlertAction) in
                    self.canvas.setIndication(false)
                }))
                self.presentViewController(stepRightAlert, animated: true, completion: nil)
                break
            case 2:
                let stepLeftAlert = UIAlertController(title: "Success", message: "Thank you. We will now try to get a better picture of the environment around the device to make the system more accurate. Please go to the living room or den take a seat on a chair or couch.", preferredStyle: UIAlertControllerStyle.Alert)
                stepLeftAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: {(action : UIAlertAction) in
                    self.canvas.setIndication(false)
                }))
                self.presentViewController(stepLeftAlert, animated: true, completion: nil)
                break
            default:
                break
        }
        
        self.stage++
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
