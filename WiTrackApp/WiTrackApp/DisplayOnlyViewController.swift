//
//  DisplayOnlyViewController.swift
//  WiTrackApp
//
//  Created by Jamar on 11/30/15.
//  Copyright © 2015 Jamar. All rights reserved.
//

import UIKit

class DisplayOnlyViewController: UIViewController {

    
    var ipAddress : String?
    var points : [(x:Float, y:Float)]?
    var positions : [Position]?
    var currentPoint : (x: Float, y: Float)?
    var socket = SocketIOClient(socketURL: "http://ec2-52-91-83-213.compute-1.amazonaws.com")
    
    @IBOutlet weak var canvas: DrawingCanvas!
    
    var recordingMode = 0
    var tracking = false
    var minX : Float = -4.0
    var maxX : Float = 4.0
    var minY : Float = 0.0
    var maxY : Float = 14.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Display View"

        // Do any additional setup after loading the view.
        socketConnect("ipAddress!")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
            
            self.canvas.moveSilently((x: currentPosition.x!, y: currentPosition.y!))
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
