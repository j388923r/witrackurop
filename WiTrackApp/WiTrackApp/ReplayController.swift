    //
//  ReplayController.swift
//  WiTrackApp
//
//  Created by Jamar Brooks on 1/14/16.
//  Copyright © 2016 Jamar. All rights reserved.
//

import Alamofire
import UIKit

class ReplayController: UIViewController {
    
    var userId : Int!
    var token : String!
    var deviceId : Int? = 1
    var email : UITextField!
    var password : UITextField!
    var dateField : UITextField!
    
    var timeToolbar = UIToolbar()
    var timePicker = UIDatePicker()
    var nextTime : String? = "1449554883000"
    
    var frameSet : [[Frame]] = []
    var currentIndex : Int = 1
    var playCounter : Int = 0
    var minX : Float = -4.0, maxX : Float = 4.0, minY : Float = 0.0, maxY : Float = 14.0
    
    @IBOutlet weak var canvas: DrawingCanvas!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        canvas.setBlankCanvasMessage("No data available in time window.")
        
        let date = NSDate()
        let nowCalendar = NSCalendar.currentCalendar()
        let nowComponents = nowCalendar.components([.Day, .Month, .Year], fromDate: date)
        nowComponents.month -= 1
        
        timePicker.minimumDate = nowCalendar.dateFromComponents(nowComponents)
        timePicker.maximumDate = date
        
        timePicker.addTarget(self, action: "datePickerValueChanged:", forControlEvents: UIControlEvents.ValueChanged)
    }
    
    override func viewDidAppear(animated: Bool) {
        
        self.frameSet.append([])
        self.frameSet.append([])
        
        if let savedToken = loadCredentials() {
            self.token = savedToken.token
            self.userId = savedToken.userId
            
            selectStartDateTime()
        } else {
            let loginAlert = UIAlertController(title: "Login", message: "Please give your email and password", preferredStyle: UIAlertControllerStyle.Alert)
            let loginAction = UIAlertAction(title: "Login", style: .Default) { (action) in
                let parameters = [
                    "email": self.email.text!,
                    "password": self.password.text!
                ]
                
                Alamofire.request(.POST, "https://www.devemerald.com/api/v1/token/generate", parameters: parameters)
                    .responseJSON { [weak self] response in
                        let data = response.result.value! as! NSDictionary
                        if data["success"]! as! NSObject == 1 {
                            let subData = data["data"]! as! NSDictionary
                            self!.token = subData["token"] as! String
                            self!.userId = subData["user"] as! Int
                            
                            self!.saveCredentials()
                            
                            self!.getNextFrameSet(self!.nextTime!)
                        } else {
                            
                        }
                        
                        print("STOP")
                }
            }
            
            loginAlert.addAction(loginAction)
            
            loginAlert.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
                self.email = textField
                self.email.placeholder = "Email"
                self.email.secureTextEntry = false
            })
            
            loginAlert.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
                self.password = textField
                self.password.placeholder = "Password"
                self.password.secureTextEntry = true
            })
            
            self.presentViewController(loginAlert, animated: true, completion: {
                print("STOP")
            })
        }
    }
    
    func selectStartDateTime() {
        
        let timePickAlert = UIAlertController(title: "Motion Replay", message: "Please input the time you would like to start replaying from.", preferredStyle: UIAlertControllerStyle.Alert)
        let replayAction = UIAlertAction(title: "Replay", style: .Default, handler: { (action) in
            print(self.timePicker.date)
            self.getNextFrameSet(self.nextTime!)
        })
        
        timePickAlert.addAction(replayAction)
        
        timePickAlert.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
            self.dateField = textField
            
            let formatter = NSDateFormatter()
            formatter.dateStyle = NSDateFormatterStyle.MediumStyle
            formatter.timeStyle = NSDateFormatterStyle.ShortStyle
            self.dateField.text = formatter.stringFromDate(self.timePicker.date)
            
            self.dateField.secureTextEntry = false
            self.dateField.inputView = self.timePicker
        })
        
        self.presentViewController(timePickAlert, animated: true, completion: {
            print("STOP")
        })
    }
    
    func getNextFrameSet(start_time : String) {
        
        /*let parameters = [
            "device" : String(self.deviceId!),
            "time_start_ms" : start_time
        ]*/
        
        let parameters = [
            "device" :  1,
            "time_start_ms" : 1449554883000
        ]
        
        let headers = [
            "X-Token" : self.token!
        ]
        
        playCounter = 0
        
        Alamofire.request(.POST, "https://www.devemerald.com/api/v1/device/frames", parameters: parameters, headers: headers, encoding: .URL)
            .responseJSON { [weak self] response in
                if let val = response.result.value {
                    let data = val as! NSDictionary
                    if data["success"]! as! NSObject == 1 {
                        self!.frameSet[(self!.currentIndex + 1) % 2] = []
                        let frameData = data["data"]! as! NSDictionary
                        let frames = frameData["frames"]! as! [AnyObject]
                        if frames.count > 0 {
                            for i in 0 ... frames.count-1 {
                                var positions = [Position]()
                                let persons = frames[i]["people"]! as! [AnyObject]
                                if persons.count > 0 {
                                    for j in 0 ... persons.count-1 {
                                        positions.append(Position(x: (persons[j]["x"]! as! Float - self!.minX) * Float(self!.canvas.frame.size.width) / (self!.maxX - self!.minX), y: (persons[j]["y"]! as! Float - self!.minY) * Float(self!.canvas.frame.size.height) / (self!.maxY - self!.minY), z: persons[j]["z"]! as! Float, personId: persons[j]["personId"]! as! Int))
                                    }
                                    let frame = Frame(people: positions, time: frames[i]["time"] as! String)
                                    self!.frameSet[(self!.currentIndex + 1) % 2].append(frame)
                                } else {
                                    self!.canvas.setBlankCanvasMessage("")
                                }
                            }
                        } else {
                            self!.canvas.setBlankCanvasMessage("No data available in time window: X.")
                        }
                        let nextTime = frameData["timeEnd"]! as! NSNumber
                        self!.nextTime = String(nextTime)
                    }
                    print("STOP")
                    
                    self!.currentIndex = (self!.currentIndex + 1) % 2
                    
                    self!.playFrames()
                }
        }
    }
    
    func playFrames() {
        NSTimer.scheduledTimerWithTimeInterval(0.03, target: self, selector: "myPerformeCode:", userInfo: nil, repeats: true)
    }
    
    // MARK: - Selectors
    
    func myPerformeCode(timer : NSTimer) {
        
        if playCounter == self.frameSet[self.currentIndex].count {
            timer.invalidate()
            getNextFrameSet(self.nextTime!)
        }
        
        // here code to perform
        canvas.update(self.frameSet[self.currentIndex][playCounter++].people)
    }
    
    func datePickerValueChanged(picker : UIDatePicker) {
        let formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.MediumStyle
        formatter.timeStyle = NSDateFormatterStyle.ShortStyle
        dateField.text = formatter.stringFromDate(picker.date)
    }
    
    // MARK: - NSCoding
    
    func saveCredentials() {
        let signin = SignInInfo(token: token!, userId: userId!)
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(signin!, toFile: SignInInfo.ArchiveURL.path!)
        if !isSuccessfulSave {
            print("Failed to save credentials...")
        }
    }
    
    func loadCredentials() -> SignInInfo? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(SignInInfo.ArchiveURL.path!) as? SignInInfo
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
