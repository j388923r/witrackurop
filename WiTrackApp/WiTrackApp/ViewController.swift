//
//  ViewController.swift
//  WiTrackApp
//
//  Created by Jamar on 11/28/15.
//  Copyright © 2015 Jamar. All rights reserved.
//

import Alamofire
import UIKit
import AVFoundation

class ViewController: UIViewController, UIPageViewControllerDataSource {

    var pageViewController: UIPageViewController!
    var userId : Int?
    var token : String?
    var device : Device!
    var socket = SocketIOClient(socketURL: "https://www.devemerald.com/")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Do any additional setup after loading the view.
        
        self.pageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("MyPageViewController") as! UIPageViewController
        
        self.pageViewController.dataSource = self
        
        socketConnect(token!)
        
        var initial = self.storyboard?.instantiateViewControllerWithIdentifier("DisplayOnlyViewController") as! DisplayOnlyViewController // self.storyboard?.instantiateViewControllerWithIdentifier("PosViewController")
        
        initial.socket = self.socket
        
        initial.socket!.on("frames") {data, ack in
            print("data", data)
            if data.count > 0 {
                var positions = [Position]()
                let frame = data[0] as! NSMutableDictionary
                let personList = frame["people"] as! NSArray
                if personList.count > 0 {
                    let person = personList[0] as! NSMutableDictionary
                    let currentPosition = Position(x: person["x"]! as! Float, y: person["y"]! as! Float, z: person["z"]! as! Float, personId: person["person_id"]! as! Int)
            
                    initial.canvas.moveSilently((x: (currentPosition.x! - initial.minX) * Float(initial.canvas.frame.size.width) / (initial.maxX - initial.minX), y: (currentPosition.y! - initial.minY) * Float(initial.canvas.frame.size.height) / (initial.maxY - initial.minY), color: initial.colorWheel[0]), personId: currentPosition.personId!)
            
                    for k in 0...personList.count - 1 {
                        let p = personList[k] as! NSMutableDictionary
                        let pos = Position(x: (p["x"]! as! Float - initial.minX) * Float(initial.canvas.frame.size.width) / (initial.maxX - initial.minX), y: (p["y"]! as! Float - initial.minY) * Float(initial.canvas.frame.size.height) / (initial.maxY - initial.minY), z: p["z"]! as! Float, personId: p["person_id"]! as! Int)
                        positions.append(pos)
                    }
                initial.canvas.update(positions)
                }
            }
        }
        
        var viewControllers = [initial]
        
        self.pageViewController.setViewControllers(viewControllers as [UIViewController]?, direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
        
        self.pageViewController.view.frame = CGRectMake(0, 65, self.view.frame.size.width, self.view.frame.size.height - 65)
        
        self.addChildViewController(self.pageViewController)
        self.view.addSubview(self.pageViewController.view)
        self.pageViewController.didMoveToParentViewController(self)
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        label.numberOfLines = 2
        label.text = device.setup_title + "\nDisplay View"
        label.textAlignment = NSTextAlignment.Center
        
        self.navigationItem.titleView = label
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController?
    {
        if viewController is PositionViewController {
            let next = self.storyboard?.instantiateViewControllerWithIdentifier("DisplayOnlyViewController") as! DisplayOnlyViewController

            next.socket = self.socket
            
            next.socket!.on("frames") {data, ack in
                print("data", data)
                if data.count > 0 {
                    var positions = [Position]()
                    let frame = data[0] as! NSMutableDictionary
                    let personList = frame["people"] as! NSArray
                    if personList.count > 0 {
                        let person = personList[0] as! NSMutableDictionary
                        let currentPosition = Position(x: person["x"]! as! Float, y: person["y"]! as! Float, z: person["z"]! as! Float, personId: person["person_id"]! as! Int)
                        
                        next.canvas.moveSilently((x: (currentPosition.x! - next.minX) * Float(next.canvas.frame.size.width) / (next.maxX - next.minX), y: (currentPosition.y! - next.minY) * Float(next.canvas.frame.size.height) / (next.maxY - next.minY), color: next.colorWheel[0]), personId: currentPosition.personId!)
                        
                        for k in 0...personList.count - 1 {
                            let p = personList[k] as! NSMutableDictionary
                            let pos = Position(x: (p["x"]! as! Float - next.minX) * Float(next.canvas.frame.size.width) / (next.maxX - next.minX), y: (p["y"]! as! Float - next.minY) * Float(next.canvas.frame.size.height) / (next.maxY - next.minY), z: p["z"]! as! Float, personId: p["person_id"]! as! Int)
                            positions.append(pos)
                        }
                        next.canvas.update(positions)
                    }
                }
            }
            
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
            label.numberOfLines = 2
            label.text = device.setup_title + "\nDisplay View"
            label.textAlignment = NSTextAlignment.Center
            
            self.navigationItem.titleView = label
            
            return next
        } else if viewController is DisplayOnlyViewController {
            return nil
        } else {
            let next = self.storyboard?.instantiateViewControllerWithIdentifier("PosViewController") as! PositionViewController

            next.socket = self.socket
            
            next.socket!.on("frames") {data, ack in
                
                if data.count > 0 {
                    let frame = data[0] as! NSMutableDictionary
                    let personList = frame["people"] as! NSArray
                    if personList.count > 0 {
                        let person = personList[0] as! NSMutableDictionary
                        let currentPosition = Position(x: person["x"]! as! Float, y: person["y"]! as! Float, z: person["z"]! as! Float, personId: person["person_id"]! as! Int)
                
                        next.record((currentPosition.x! - next.minX) * Float(next.canvas.frame.size.width) / (next.maxX - next.minX), y: (currentPosition.y! - next.minY) * Float(next.canvas.frame.size.height) / (next.maxY - next.minY), personId: currentPosition.personId!)
                    }
                }
            }
            
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
            label.numberOfLines = 2
            label.text = device.setup_title + "\nCalibration View"
            label.textAlignment = NSTextAlignment.Center
            
            self.navigationItem.titleView = label
            
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

            next.socket = self.socket
            
            next.socket!.on("frames") {data, ack in
                
                if data.count > 0 {
                    let frame = data[0] as! NSMutableDictionary
                    let personList = frame["people"] as! NSArray
                    if personList.count > 0 {
                        let person = personList[0] as! NSMutableDictionary
                        let currentPosition = Position(x: person["x"]! as! Float, y: person["y"]! as! Float, z: person["z"]! as! Float, personId: person["person_id"]! as! Int)
                
                        next.record((currentPosition.x! - next.minX) * Float(next.canvas.frame.size.width) / (next.maxX - next.minX), y: (currentPosition.y! - next.minY) * Float(next.canvas.frame.size.height) / (next.maxY - next.minY), personId: currentPosition.personId!)
                    }
                }
            }
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
            label.numberOfLines = 2
            label.text = device.setup_title + "\nCalibration View"
            label.textAlignment = NSTextAlignment.Center
            
            self.navigationItem.titleView = label
            
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
    
    func socketConnect(token:String) {
        
        self.socket.on("connect") {data, ack in
            print("Connection")
            self.socket.emit("start", ["deviceId": self.device.id!, "token": token])
            //self.socket.emit("start", ConnectObject(deviceId: self.device.id!, token: token))
        }
        
        self.socket.on("boundary") {[weak self] data, ack in
            print(data);
            // let bounds = data[0];
        }
        
        self.socket.connect()
    }

    @IBAction func LogoutButtonTap(sender: AnyObject) {
        self.socket.close()
        
        let nextViewController : LogoutViewController = self.storyboard?.instantiateViewControllerWithIdentifier("LogoutViewController") as! LogoutViewController
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let clearLoginInfo = SignInInfo(token: "", userId: -1)
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(clearLoginInfo!, toFile: SignInInfo.ArchiveURL.path!)
        if isSuccessfulSave {
            appDelegate.window!.rootViewController = nextViewController
        }
    }
    
    
}

