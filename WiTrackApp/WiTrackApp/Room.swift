//
//  Room.swift
//  WiTrackApp
//
//  Created by Jamar Brooks on 1/28/16.
//  Copyright © 2016 Jamar. All rights reserved.
//

import Foundation

class Room {
    var corners : [(x: Int, y: Int, z: Int)]?
    let name : String!
    
    init(name: String) {
        self.name = name
    }
    
    func addCorner(point: (x: Int, y: Int, z: Int)) {
        corners!.append(point)
    }
}