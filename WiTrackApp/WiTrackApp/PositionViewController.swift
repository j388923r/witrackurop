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
    var ipAddress : String?
    var points : [(x:Float, y:Float)]?
    var positions : [Position]?
    var currentPoint : (x: Float, y: Float, personId: Int)?
    var socket : SocketIOClient?
    
    var colorWheel : [UIColor] = [UIColor.purpleColor(), UIColor.redColor(), UIColor.grayColor(), UIColor.greenColor(), UIColor.blackColor(), UIColor.blueColor(), UIColor.brownColor(), UIColor.cyanColor(), UIColor.yellowColor(), UIColor.orangeColor(), UIColor.magentaColor(), UIColor.lightGrayColor(), UIColor.darkGrayColor()]
    
    @IBOutlet weak var canvas: DrawingCanvas!
    @IBOutlet weak var primary: UIButton!
    @IBOutlet weak var secondary: UIButton!
    let tapRecognizer = UITapGestureRecognizer()
    
    /*let pinchRec = UIPinchGestureRecognizer()
    let swipeRec = UISwipeGestureRecognizer()
    let longPressRec = UILongPressGestureRecognizer()
    let rotateRec = UIRotationGestureRecognizer()
    let panRec = UIPanGestureRecognizer()*/
    
    var recordingMode = 0
    var tracking = false
    var minX : Float = -4.0
    var maxX : Float = 4.0
    var minY : Float = 0.0
    var maxY : Float = 14.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        points = []
        
        tapRecognizer.addTarget(self, action: "tappedView")
        canvas.addGestureRecognizer(tapRecognizer)
        canvas.userInteractionEnabled = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tappedView(){
        let touchLocation = tapRecognizer.locationInView(tapRecognizer.view?.window)
        let tapAlert = UIAlertController(title: "Tapped", message: "You just tapped the tap view", preferredStyle: UIAlertControllerStyle.Alert)
        tapAlert.addAction(UIAlertAction(title: "OK", style: .Destructive, handler: nil))
        self.presentViewController(tapAlert, animated: true, completion: nil)
    }
    
    @IBAction func StartStop(sender: UIButton) {
        print(primary.titleLabel!.text!)
        if (primary.titleLabel!.text! == "Start") {
            tracking = true
            record( currentPoint!.x, y: currentPoint!.y, personId: currentPoint!.personId)
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
            if (secondary.titleLabel!.text! == "Corner Making") {
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
                record( currentPoint!.x, y: currentPoint!.y, personId: currentPoint!.personId)
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
    
    var inputStream : NSInputStream?
    var outputStream : NSOutputStream?
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
