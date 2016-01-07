//
//  ConnectObject.swift
//  WiTrackApp
//
//  Created by Jamar Brooks on 12/9/15.
//  Copyright © 2015 Jamar. All rights reserved.
//

import Foundation

class UserObject {
    var userId : Int!
    var token : String!
    
    init( token : String, userId : Int) {
        self.userId = userId;
        self.token = token;
    }
}