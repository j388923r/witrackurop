//
//  SignInInfo.swift
//  WiTrackApp
//
//  Created by Jamar Brooks on 12/4/15.
//  Copyright © 2015 Jamar. All rights reserved.
//

import UIKit

class SignInInfo: NSObject, NSCoding {
    var token : String!
    var userId : Int!
    
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("signin")
    
    init?(token : String, userId: Int){
        self.token = token
        self.userId = userId
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(token, forKey: "token")
        aCoder.encodeObject(userId, forKey: "userId")
    }
    
    required convenience init?(coder aDecoder : NSCoder) {
        let token = aDecoder.decodeObjectForKey("token") as! String
        let userId = aDecoder.decodeObjectForKey("userId") as! Int
        
        self.init(token: token, userId: userId)
    }
}
