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

class ViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    var pageViewController: UIPageViewController!
    var userId : Int?
    var token : String?
    var device : Device!
    var socket = SocketIOClient(socketURL: "https://www.devemerald.com/")
    var currentPageIndex : Int = 0
    var swipeReady : Bool = false
    var movingLeft : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Do any additional setup after loading the view.
        
        self.pageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("MyPageViewController") as! UIPageViewController
        
        self.pageViewController.dataSource = self
        self.pageViewController.delegate = self
        
        socketConnect(token!)
        
        let initial0 = self.storyboard?.instantiateViewControllerWithIdentifier("DisplayOnlyViewController") as! DisplayOnlyViewController
        let initial1 = self.storyboard?.instantiateViewControllerWithIdentifier("PosViewController") as! PositionViewController
        
        initial0.socket = self.socket
        
        initial0.socket!.on("frames") {data, ack in
            print("data", data)
            if data.count > 0 {
                var positions = [Position]()
                let frame = data[0] as! NSMutableDictionary
                let personList = frame["people"] as! NSArray
                if personList.count > 0 {
                    /*let person = personList[0] as! NSMutableDictionary
                    let currentPosition = Position(x: person["x"]! as! Float, y: person["y"]! as! Float, z: person["z"]! as! Float, personId: person["personId"]! as! Int)
            
                    initial.canvas.moveSilently((x: (currentPosition.x! - initial.minX) * Float(initial.canvas.frame.size.width) / (initial.maxX - initial.minX), y: (currentPosition.y! - initial.minY) * Float(initial.canvas.frame.size.height) / (initial.maxY - initial.minY), color: initial.colorWheel[0]), personId: currentPosition.personId!)*/
            
                    for k in 0...personList.count - 1 {
                        let p = personList[k] as! NSMutableDictionary
                        let pos = Position(x: (p["x"]! as! Float - initial0.minX) * Float(initial0.canvas.frame.size.width) / (initial0.maxX - initial0.minX), y: (p["y"]! as! Float - initial0.minY) * Float(initial0.canvas.frame.size.height) / (initial0.maxY - initial0.minY), z: p["z"]! as! Float, personId: p["personId"]! as! Int)
                        positions.append(pos)
                    }
                    initial0.canvas.update(positions)
                }
            }
        }
        
        var viewControllers = [initial0]
        
        self.pageViewController.setViewControllers(viewControllers as [UIViewController]?, direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
        
        self.pageViewController.view.frame = CGRectMake(0, 65, self.view.frame.size.width, self.view.frame.size.height - 65)
        
        self.addChildViewController(self.pageViewController)
        self.view.addSubview(self.pageViewController.view)
        self.pageViewController.didMoveToParentViewController(self)
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        label.numberOfLines = 2
        label.text = device.setup_title + "\nDisplay View"
        label.textAlignment = NSTextAlignment.Center
        
        self.currentPageIndex = 0
        
        self.navigationItem.titleView = label
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool)
    {
        if (!completed)
        {
            return
        }
        self.currentPageIndex = self.pageViewController.viewControllers!.first!.view.tag
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController?
    {
        switch self.currentPageIndex {
            case 1:
                print("Display")
                break
            case 2:
                print("Position")
                break
            default:
                print("nil")
        }
        
        if viewController is PositionViewController {
            let next = self.storyboard?.instantiateViewControllerWithIdentifier("DisplayOnlyViewController") as! DisplayOnlyViewController

            next.socket = self.socket
            
            next.socket!.on("frames") {data, ack in
                print("Display data", data)
                if data.count > 0 {
                    var positions = [Position]()
                    let frame = data[0] as! NSMutableDictionary
                    let personList = frame["people"] as! NSArray
                    if personList.count > 0 {
                        /*let person = personList[0] as! NSMutableDictionary
                        let currentPosition = Position(x: person["x"]! as! Float, y: person["y"]! as! Float, z: person["z"]! as! Float, personId: person["personId"]! as! Int)
                        
                        next.canvas.moveSilently((x: (currentPosition.x! - next.minX) * Float(next.canvas.frame.size.width) / (next.maxX - next.minX), y: (currentPosition.y! - next.minY) * Float(next.canvas.frame.size.height) / (next.maxY - next.minY), color: next.colorWheel[0]), personId: currentPosition.personId!)*/
                        
                        for k in 0...personList.count - 1 {
                            let p = personList[k] as! NSMutableDictionary
                            let pos = Position(x: (p["x"]! as! Float - next.minX) * Float(next.canvas.frame.size.width) / (next.maxX - next.minX), y: (p["y"]! as! Float - next.minY) * Float(next.canvas.frame.size.height) / (next.maxY - next.minY), z: p["z"]! as! Float, personId: p["personId"]! as! Int)
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
        } else if viewController is ReplayController {
            let next = self.storyboard?.instantiateViewControllerWithIdentifier("HeightViewController") as! HeightViewController
            
            next.socket = self.socket
            
            next.socket!.on("frames") {data, ack in
                var positions = [Position]()
                let frame = data[0] as! NSMutableDictionary
                let personList = frame["people"] as! NSArray
                if personList.count > 0 {
                    
                    for k in 0...personList.count - 1 {
                        let p = personList[k] as! NSMutableDictionary
                        let pos = Position(x: p["x"]! as! Float, y: p["y"]! as! Float, z: p["z"]! as! Float, personId: p["personId"]! as! Int)
                        positions.append(pos)
                    }
                    
                    next.loadChart(positions)
                }
                next.loadChart([])
            }
            
            return next
        } else if viewController is HeightViewController {
            let next = self.storyboard?.instantiateViewControllerWithIdentifier("PosViewController") as! PositionViewController

            next.socket = self.socket
            
            next.socket!.on("frames") {data, ack in
                
                if data.count > 0 {
                    if (next.tracking) {
                        let frame = data[0] as! NSMutableDictionary
                        let personList = frame["people"] as! NSArray
                        if personList.count > 0 {
                            next.record(personList, personId: next.trackingId)
                        }
                    } else {
                        var positions = [Position]()
                        let frame = data[0] as! NSMutableDictionary
                        let personList = frame["people"] as! NSArray
                        if personList.count > 0 {
                            
                            next.record(personList)
                            /*for k in 0...personList.count - 1 {
                                let p = personList[k] as! NSMutableDictionary
                                let pos = Position(x: (p["x"]! as! Float - next.minX) * Float(next.canvas.frame.size.width) / (next.maxX - next.minX), y: (p["y"]! as! Float - next.minY) * Float(next.canvas.frame.size.height) / (next.maxY - next.minY), z: p["z"]! as! Float, personId: p["personId"]! as! Int)
                                positions.append(pos)
                            }
                            next.canvas.update(positions)*/
                        }
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
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController?
    {
        if viewController is PositionViewController {
            let next = self.storyboard?.instantiateViewControllerWithIdentifier("HeightViewController") as! HeightViewController
            
            next.socket = self.socket
            
            next.socket!.on("frames") {data, ack in
                var positions = [Position]()
                let frame = data[0] as! NSMutableDictionary
                let personList = frame["people"] as! NSArray
                if personList.count > 0 {
                    
                    for k in 0...personList.count - 1 {
                        let p = personList[k] as! NSMutableDictionary
                        let pos = Position(x: p["x"]! as! Float, y: p["y"]! as! Float, z: p["z"]! as! Float, personId: p["personId"]! as! Int)
                        positions.append(pos)
                    }
                    
                    next.loadChart(positions)
                }
                next.loadChart([])
            }
        
            return next
        } else if viewController is DisplayOnlyViewController {
            let next = self.storyboard?.instantiateViewControllerWithIdentifier("PosViewController") as! PositionViewController

            next.socket = self.socket
            
            next.socket!.on("frames") {data, ack in
                
                if data.count > 0 {
                    if (next.tracking) {
                        let frame = data[0] as! NSMutableDictionary
                        let personList = frame["people"] as! NSArray
                        if personList.count > 0 {
                            
                            next.record(personList, personId: next.trackingId)
                        }
                    } else {
                        let frame = data[0] as! NSMutableDictionary
                        let personList = frame["people"] as! NSArray
                        if personList.count > 0 {
                            
                            next.record(personList)
                            /*for k in 0...personList.count - 1 {
                                let p = personList[k] as! NSMutableDictionary
                                let pos = Position(x: (p["x"]! as! Float - next.minX) * Float(next.canvas.frame.size.width) / (next.maxX - next.minX), y: (p["y"]! as! Float - next.minY) * Float(next.canvas.frame.size.height) / (next.maxY - next.minY), z: p["z"]! as! Float, personId: p["personId"]! as! Int)
                                positions.append(pos)
                            }
                            next.canvas.update(positions)*/
                        }
                    }
                }
            }
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
            label.numberOfLines = 2
            label.text = device.setup_title + "\nCalibration View"
            label.textAlignment = NSTextAlignment.Center
            
            self.navigationItem.titleView = label
            
            return next
        } else if viewController is HeightViewController {
            let next = self.storyboard?.instantiateViewControllerWithIdentifier("ReplayViewController") as! ReplayController
            
            next.deviceId = device.id
            next.token = token
            next.userId = userId
            
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
            label.numberOfLines = 2
            label.text = device.setup_title + "\nReplay View"
            label.textAlignment = NSTextAlignment.Center
            
            self.navigationItem.titleView = label
            
            return next
        } else {
            return nil
        }
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 4
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    func socketConnect(token:String) {
        
        self.socket.on("connect") {data, ack in
            print("Connection")
            self.socket.emit("start", ["deviceId": self.device.id!, "token": token])
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

