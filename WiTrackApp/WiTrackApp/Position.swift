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
    var personId : Int?
    
    init(x : Float, y: Float, z: Float, personId : Int){
        self.x = x
        self.y = y
        self.z = z
        self.personId = personId
    }
}