//
//  ViewController.swift
//  WiTrackApp
//
//  Created by Jamar on 11/28/15.
//  Copyright © 2015 Jamar. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPageViewControllerDataSource {

    var pageViewController: UIPageViewController!
    var username : String?
    var password : String?
    var socket = SocketIOClient(socketURL: "http://ec2-52-91-83-213.compute-1.amazonaws.com")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Do any additional setup after loading the view.
        socketConnect("ipAddress!")
        
        self.pageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("MyPageViewController") as! UIPageViewController
        
        self.pageViewController.dataSource = self
        
        var initial = self.storyboard?.instantiateViewControllerWithIdentifier("DisplayOnlyViewController") as! DisplayOnlyViewController // self.storyboard?.instantiateViewControllerWithIdentifier("PosViewController")
        
        initial.username = username
        initial.password = password
        initial.socket = self.socket
        
        initial.socket!.on("positions") {data, ack in
            // print(data.count)
            let personList = data[0]
            let person = personList[0]! as! NSMutableDictionary
            /* print(person.allKeys)
            print(person["y"]! as! Float)
            print(person["deviceId"]! as! Int)
            print(person["timestamp"]! as! String) */
            let currentPosition = Position(x: person["x"]! as! Float, y: person["y"]! as! Float, z: person["z"]! as! Float, timestamp: person["timestamp"]! as! String, deviceId: person["deviceId"]! as! Int, personId: person["personId"]! as! Int)
            
            initial.canvas.moveSilently((x: (currentPosition.x! - initial.minX) * Float(initial.canvas.frame.size.width) / (initial.maxX - initial.minX), y: (currentPosition.y! - initial.minY) * Float(initial.canvas.frame.size.height) / (initial.maxY - initial.minY), color: initial.colorWheel[0]), personId: currentPosition.personId!)
        }
        
        var viewControllers = [initial]
        
        self.pageViewController.setViewControllers(viewControllers as [UIViewController]?, direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
        
        self.pageViewController.view.frame = CGRectMake(0, 65, self.view.frame.size.width, self.view.frame.size.height - 65)
        
        self.addChildViewController(self.pageViewController)
        self.view.addSubview(self.pageViewController.view)
        self.pageViewController.didMoveToParentViewController(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController?
    {
        if viewController is PositionViewController {
            let next = self.storyboard?.instantiateViewControllerWithIdentifier("DisplayOnlyViewController") as! DisplayOnlyViewController
            next.username = username
            next.password = password
            next.socket = self.socket
            
            next.socket!.on("positions") {data, ack in
                // print(data.count)
                let personList = data[0]
                let person = personList[0]! as! NSMutableDictionary
                /* print(person.allKeys)
                print(person["y"]! as! Float)
                print(person["deviceId"]! as! Int)
                print(person["timestamp"]! as! String) */
                let currentPosition = Position(x: person["x"]! as! Float, y: person["y"]! as! Float, z: person["z"]! as! Float, timestamp: person["timestamp"]! as! String, deviceId: person["deviceId"]! as! Int, personId: person["personId"]! as! Int)
                
                print("displaying")
                next.canvas.moveSilently((x: (currentPosition.x! - next.minX) * Float(next.canvas.frame.size.width) / (next.maxX - next.minX), y: (currentPosition.y! - next.minY) * Float(next.canvas.frame.size.height) / (next.maxY - next.minY), color: next.colorWheel[0]), personId: currentPosition.personId!)
            }
            
            self.title = "Display View"
            
            return next
        } else if viewController is DisplayOnlyViewController {
            return nil
        } else {
            let next = self.storyboard?.instantiateViewControllerWithIdentifier("PosViewController") as! PositionViewController
            next.username = username
            next.password = password
            next.socket = self.socket
            
            next.socket!.on("positions") {data, ack in
                print(data.count)
                let personList = data[0]
                let person = personList[0]! as! NSMutableDictionary
                print(person.allKeys)
                print(person["y"]! as! Float)
                print(person["deviceId"]! as! Int)
                print(person["timestamp"]! as! String)
                let currentPosition = Position(x: person["x"]! as! Float, y: person["y"]! as! Float, z: person["z"]! as! Float, timestamp: person["timestamp"]! as! String, deviceId: person["deviceId"]! as! Int, personId: person["personId"]! as! Int)
                next.record((currentPosition.x! - next.minX) * Float(next.canvas.frame.size.width) / (next.maxX - next.minX), y: (currentPosition.y! - next.minY) * Float(next.canvas.frame.size.height) / (next.maxY - next.minY), personId: currentPosition.personId!)
            }
            
            self.title = "Calibration View"
            
            return next
        }
        
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController?
    {
        if viewController is PositionViewController {
            let nextViewController = self.storyboard?.instantiateViewControllerWithIdentifier("HeightViewController")
            return nextViewController
        } else if viewController is DisplayOnlyViewController {
            let next = self.storyboard?.instantiateViewControllerWithIdentifier("PosViewController") as! PositionViewController
            next.username = username
            next.password = password
            next.socket = self.socket
            
            next.socket!.on("positions") {data, ack in
                print(data.count)
                let personList = data[0]
                let person = personList[0]! as! NSMutableDictionary
                print(person.allKeys)
                print(person["y"]! as! Float)
                print(person["deviceId"]! as! Int)
                print(person["timestamp"]! as! String)
                let currentPosition = Position(x: person["x"]! as! Float, y: person["y"]! as! Float, z: person["z"]! as! Float, timestamp: person["timestamp"]! as! String, deviceId: person["deviceId"]! as! Int, personId: person["personId"]! as! Int)
                next.record((currentPosition.x! - next.minX) * Float(next.canvas.frame.size.width) / (next.maxX - next.minX), y: (currentPosition.y! - next.minY) * Float(next.canvas.frame.size.height) / (next.maxY - next.minY), personId: currentPosition.personId!)
            }
            
            self.title = "Calibration View"
            
            return next
        } else {
            return nil
        }
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 3
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    func socketConnect(token:NSString) {
        
        self.socket.on("connect") {data, ack in
            print("socket connected")
        }
        
        self.socket.emit("login", username!, password!)
        
        self.socket.on("boundary") {[weak self] data, ack in
            print(data);
            // let bounds = data[0];
        }
        
        self.socket.connect()
    }

    @IBAction func LogoutButtonTap(sender: AnyObject) {
        let nextViewController : LogoutViewController = self.storyboard?.instantiateViewControllerWithIdentifier("LogoutViewController") as! LogoutViewController
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        appDelegate.window!.rootViewController = nextViewController
    }
    
    
}

