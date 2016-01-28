//
//  Setting.swift
//  WiTrackApp
//
//  Created by Jamar Brooks on 1/23/16.
//  Copyright © 2016 Jamar. All rights reserved.
//

import Foundation

class Setting: NSObject, NSCoding {
    let display_title : String!
    var state : String!
    
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("settings")
    
    init(display : String, state : String) {
        self.display_title = display
        self.state = state
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(display_title, forKey: "display_title")
        aCoder.encodeObject(state, forKey: "state")
    }
    
    required convenience init?(coder aDecoder : NSCoder) {
        let display = aDecoder.decodeObjectForKey("display_title") as! String
        let state = aDecoder.decodeObjectForKey("state") as! String
        
        self.init(display: display, state: state)
    }
}