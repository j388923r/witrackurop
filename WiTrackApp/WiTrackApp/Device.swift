//
//  Device.swift
//  WiTrackApp
//
//  Created by Jamar Brooks on 12/7/15.
//  Copyright © 2015 Jamar. All rights reserved.
//

import Foundation

class Device {
    var id: Int!
    var realtime_access: Int!
    var setup_id: Int!
    var setup_title: String!
    var title: String!
    
    init(id: Int, realtime_access: Int, setup_id: Int, setup_title: String, title: String){
        self.id = id
        self.realtime_access = realtime_access
        self.setup_id = setup_id
        self.setup_title = setup_title
        self.title = title
    }
}