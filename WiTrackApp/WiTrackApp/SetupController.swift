//
//  SetupController.swift
//  WiTrackApp
//
//  Created by Jamar Brooks on 1/25/16.
//  Copyright © 2016 Jamar. All rights reserved.
//

import UIKit

class SetupController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    var pageViewController: UIPageViewController!
    
    var device : Device!
    
    var userId : Int?
    var token : String?
    var socket = SocketIOClient(socketURL: "https://www.devemerald.com/")
    
    var currentPageIndex : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.pageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("MyPageViewController") as! UIPageViewController
        
        self.pageViewController.dataSource = self
        self.pageViewController.delegate = self
        
        let initial0 = self.storyboard?.instantiateViewControllerWithIdentifier("CalibrationViewController") as! CalibrationViewController
        
        socketConnect(token!)
        
        initial0.socket = socket
        
        initial0.socket!.on("frames") {data, ack in
            print("data", data)
            if data.count > 0 {
                var positions = [Position]()
                let frame = data[0] as! NSMutableDictionary
                let personList = frame["people"] as! NSArray
                if personList.count > 0 {
                    if initial0.tracking && initial0.trackingId >= 0{
                        for k in 0...personList.count - 1 {
                            let p = personList[k] as! NSMutableDictionary
                            if (p["personId"]! as! Int) == initial0.trackingId {
                                let pos = Position(x: (p["x"]! as! Float - initial0.minX) * Float(initial0.canvas.frame.size.width) / (initial0.maxX - initial0.minX), y: (p["y"]! as! Float - initial0.minY) * Float(initial0.canvas.frame.size.height) / (initial0.maxY - initial0.minY), z: p["z"]! as! Float, personId: p["personId"]! as! Int)
                                positions.append(pos)
                            }
                            if (initial0.detectEvent()) {
                                initial0.canvas.setIndication(true)
                                initial0.nextStage()
                            }
                        }
                    } else {
                        for k in 0...personList.count - 1 {
                            let p = personList[k] as! NSMutableDictionary
                            let pos = Position(x: (p["x"]! as! Float - initial0.minX) * Float(initial0.canvas.frame.size.width) / (initial0.maxX - initial0.minX), y: (p["y"]! as! Float - initial0.minY) * Float(initial0.canvas.frame.size.height) / (initial0.maxY - initial0.minY), z: p["z"]! as! Float, personId: p["personId"]! as! Int)
                            positions.append(pos)
                        }
                    }
                    initial0.track(positions)
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
        label.text = "Introduction"
        label.textAlignment = NSTextAlignment.Center
        
        self.currentPageIndex = 0
        
        self.navigationItem.titleView = label
    }
    
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool)
    {
        if (!completed)
        {
            return
        }
        self.currentPageIndex = pageViewController.viewControllers!.first!.view.tag
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController?
    {
        if viewController is PerceptionViewController {
            let next = self.storyboard?.instantiateViewControllerWithIdentifier("CalibrationViewController") as! CalibrationViewController
            
            next.socket = socket
            
            next.socket!.on("frames") {data, ack in
                print("data", data)
                if data.count > 0 {
                    var positions = [Position]()
                    let frame = data[0] as! NSMutableDictionary
                    let personList = frame["people"] as! NSArray
                    if personList.count > 0 {
                        if next.tracking && next.trackingId >= 0{
                            for k in 0...personList.count - 1 {
                                let p = personList[k] as! NSMutableDictionary
                                if (p["personId"]! as! Int) == next.trackingId {
                                    let pos = Position(x: (p["x"]! as! Float - next.minX) * Float(next.canvas.frame.size.width) / (next.maxX - next.minX), y: (p["y"]! as! Float - next.minY) * Float(next.canvas.frame.size.height) / (next.maxY - next.minY), z: p["z"]! as! Float, personId: p["personId"]! as! Int)
                                    positions.append(pos)
                                }
                                if next.detectEvent() {
                                    next.canvas.setIndication(true)
                                    next.nextStage()
                                }
                            }
                        } else {
                            for k in 0...personList.count - 1 {
                                let p = personList[k] as! NSMutableDictionary
                                let pos = Position(x: (p["x"]! as! Float - next.minX) * Float(next.canvas.frame.size.width) / (next.maxX - next.minX), y: (p["y"]! as! Float - next.minY) * Float(next.canvas.frame.size.height) / (next.maxY - next.minY), z: p["z"]! as! Float, personId: p["personId"]! as! Int)
                                positions.append(pos)
                            }
                        }
                        next.track(positions)
                    }
                }
            }
            
            self.navigationItem.title = "Calibration"
            
            return next
        } else {
            return nil
        }
        
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController?
    {
        if viewController is CalibrationViewController {
            let next = self.storyboard?.instantiateViewControllerWithIdentifier("PerceptionViewController") as! PerceptionViewController
            next.socket = socket
            
            next.trackingId = (viewController as! CalibrationViewController).trackingId
            
            next.socket!.on("frames") {data, ack in
                print("data", data)
                if data.count > 0 {
                    var positions = [Position]()
                    let frame = data[0] as! NSMutableDictionary
                    let personList = frame["people"] as! NSArray
                    if personList.count > 0 {
                        if next.tracking && next.trackingId >= 0{
                            for k in 0...personList.count - 1 {
                                let p = personList[k] as! NSMutableDictionary
                                if (p["personId"]! as! Int) == next.trackingId {
                                    let pos = Position(x: (p["x"]! as! Float - next.minX) * Float(next.canvas.frame.size.width) / (next.maxX - next.minX), y: (p["y"]! as! Float - next.minY) * Float(next.canvas.frame.size.height) / (next.maxY - next.minY), z: p["z"]! as! Float, personId: p["personId"]! as! Int)
                                    positions.append(pos)
                                }
                            }
                        } else {
                            print("Error need to be tracking someone")
                        }
                        next.canvas.update(positions)
                    }
                }
            }
            
            self.navigationItem.title = "Perception"
            
            return next
        } else {
            return nil
        }
        
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 6
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    func loadCredentials() -> SignInInfo? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(SignInInfo.ArchiveURL.path!) as? SignInInfo
    }
    
    func socketConnect(token:String) {
        
        self.socket.on("connect") {data, ack in
            print("Connection")
            self.socket.emit("start", ["deviceId": self.device.id!, "token": token])
        }
        
        self.socket.connect()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
