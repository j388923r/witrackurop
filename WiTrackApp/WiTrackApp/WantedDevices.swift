//
//  WantedDevices.swift
//  WiTrackApp
//
//  Created by Jamar Brooks on 1/20/16.
//  Copyright © 2016 Jamar. All rights reserved.
//

import UIKit

class WantedDevice : NSObject, NSCoding {
    var title : String!
    var deviceId : Int!
    
    init?(title : String, deviceId: Int){
        self.title = title
        self.deviceId = deviceId
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(title, forKey: "title")
        aCoder.encodeObject(deviceId, forKey: "deviceId")
    }
    
    required convenience init?(coder aDecoder : NSCoder) {
        let title = aDecoder.decodeObjectForKey("title") as! String
        let deviceId = aDecoder.decodeObjectForKey("deviceId") as! Int
        
        self.init(title: title, deviceId: deviceId)
    }
    
    // MARK: Archiving Paths
    
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("visibleDevices")
}
