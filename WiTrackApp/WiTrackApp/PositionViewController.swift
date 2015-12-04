//
//  PositionViewController.swift
//  WiTrack
//
//  Created by Jamar on 10/29/15.
//  Copyright © 2015 Jamar. All rights reserved.
//

import UIKit

class PositionViewController: UIViewController, NSStreamDelegate {

    var username : String?
    var password : String?
    var ipAddress : String?
    var points : [(x:Float, y:Float)]?
    var positions : [Position]?
    var currentPoint : (x: Float, y: Float)?
    var socket = SocketIOClient(socketURL: "http://ec2-52-91-83-213.compute-1.amazonaws.com")
    
    @IBOutlet weak var canvas: DrawingCanvas!
    @IBOutlet weak var primary: UIButton!
    @IBOutlet weak var secondary: UIButton!
    
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
        
        self.title = "Calibration View"
        
        socketConnect("ipAddress!")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func StartStop(sender: UIButton) {
        print(primary.titleLabel!.text!)
        if (primary.titleLabel!.text! == "Start") {
            tracking = true
            record( currentPoint!.x, y: currentPoint!.y)
            primary.setTitle("Stop", forState: UIControlState.Normal)
            if (recordingMode == 0) {
                secondary.setTitle("Record", forState: UIControlState.Normal)
            } else {
                secondary.setTitle("Pause Recording", forState: UIControlState.Normal)
            }
        } else {
            tracking = false
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
                record( currentPoint!.x, y: currentPoint!.y)
            } else {
                tracking = false
                secondary.setTitle("Record", forState: UIControlState.Normal)
            }
        }
    }
    
    func record(x : Float, y : Float) {
        if (tracking) {
            canvas.move((x: x, y: y))
            points!.append((x: x, y: y))
            currentPoint = (x: x, y: y)
            if (recordingMode == 0) {
                tracking = false
                secondary.setTitle("Record", forState: UIControlState.Normal)
            }
        } else {
            canvas.moveSilently((x: x, y: y))
            currentPoint = (x: x, y: y)
        }
        
    }
    
    var inputStream : NSInputStream?
    var outputStream : NSOutputStream?
    
    func socketConnect(token:NSString) {
        
        self.socket.on("connect") {data, ack in
            print("socket connected")
        }
        
        self.socket.on("positions") {data, ack in
            print(data.count)
            let personList = data[0]
            let person = personList[0]! as! NSMutableDictionary
            print(person.allKeys)
            print(person["y"]! as! Float)
            print(person["deviceId"]! as! Int)
            print(person["timestamp"]! as! String)
            let currentPosition = Position(x: person["x"]! as! Float, y: person["y"]! as! Float, z: person["z"]! as! Float, timestamp: person["timestamp"]! as! String, deviceId: person["deviceId"]! as! Int, personId: person["personId"]! as! Int)
            self.record((currentPosition.x! - self.minX) * 300 / (self.maxX - self.minX), y: (currentPosition.y! - self.minY) * 600 / (self.maxY - self.minY))
        }
        
        self.socket.on("boundary") {[weak self] data, ack in
            print(data);
            // let bounds = data[0];
        }
        
        self.socket.connect()
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
