//
//  Frame.swift
//  WiTrackApp
//
//  Created by Jamar Brooks on 1/15/16.
//  Copyright © 2016 Jamar. All rights reserved.
//

import Foundation

class Frame {
    var people = [Position]()
    var timeStamp : String?
    
    init(people: [Position], time : String){
        self.people = people
        self.timeStamp = time
    }
}