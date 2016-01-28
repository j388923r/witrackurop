//
//  HeightViewCanvas.swift
//  WiTrackApp
//
//  Created by Jamar Brooks on 1/11/16.
//  Copyright © 2016 Jamar. All rights reserved.
//

import UIKit

@IBDesignable

class HeightViewCanvas : UIView {
    
    var currentPositions : [Position]!
    
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        print("drawing heights")
        
        if currentPositions.count < 1 {
            let s = "No objects detected."
            // set the text color to dark gray
            let fieldColor: UIColor = UIColor.darkGrayColor()
            let fieldFont = UIFont(name: "Helvetica Neue", size: 18)
            // set the line spacing to 6
            var paraStyle = NSMutableParagraphStyle()
            paraStyle.lineSpacing = 6.0
            // set the Obliqueness to 0.1
            var skew = 0.1
            
            var attributes: NSDictionary = [
                NSForegroundColorAttributeName: fieldColor,
                NSParagraphStyleAttributeName: paraStyle,
                NSObliquenessAttributeName: skew,
                NSFontAttributeName: fieldFont!
            ]
            
            s.drawInRect(CGRectMake(frame.size.width / 4, frame.size.height / 4, frame.size.width * 3 / 10, frame.size.height * 3 / 10), withAttributes: attributes as! [String : AnyObject])
        }
    }
    
    func updatePositions(positions : [Position]) {
        currentPositions = positions
        setNeedsDisplay()
    }
    
    func drawHeightGraph(positions : [Position]) {
    
    }
}
