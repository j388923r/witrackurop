//
//  Position.swift
//  WiTrack
//
//  Created by Jamar on 11/13/15.
//  Copyright © 2015 Jamar. All rights reserved.
//

import Foundation

class Position {
    var x : Float?
    var y : Float?
    var z : Float?
    var timestamp : String?
    var deviceId : Int?
    var personId : Int?
    
    init(x : Float, y: Float, z: Float, timestamp : String, deviceId : Int, personId : Int){
        self.x = x
        self.y = y
        self.z = z
        self.timestamp = timestamp
        self.deviceId = deviceId
        self.personId = personId
    }
}