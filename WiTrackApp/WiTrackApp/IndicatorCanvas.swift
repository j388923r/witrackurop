//
//  IndicatorCanvas.swift
//  WiTrackApp
//
//  Created by Jamar Brooks on 1/23/16.
//  Copyright © 2016 Jamar. All rights reserved.
//

import UIKit

@IBDesignable

class IndicatorCanvas: UIView {
    
    var mode = IndicationMode.Background
    var stage : Int = -1
    let pathWidth : CGFloat = 1.0
    let pointWidth : Float  = 40.0
    var currentPoints = [Int: (x: Float, y:Float, color : UIColor)]()
    var positionHistories = [Int: [(x:Float, y:Float)]]()
    var indicating = false
    var indicationStrength : CGFloat = 0.2
    
    var colorWheel : [UIColor] = [UIColor.purpleColor(), UIColor.grayColor(), UIColor.blueColor(), UIColor.brownColor(), UIColor.cyanColor(), UIColor.blackColor(), UIColor.lightGrayColor(), UIColor.darkGrayColor()]
    
    var emptyCanvasMessage : String = "You are currently undetected. Please walk to the front of the device and then back away."
    
    var minX : Float = -4.0
    var maxX : Float = 4.0
    var minY : Float = 0.0
    var maxY : Float = 14.0
    
    override func drawRect(rect: CGRect) {
        
        switch mode {
            case .Background:
                if !indicating {
                    UIColor.redColor().colorWithAlphaComponent(indicationStrength).setFill()
                    UIBezierPath(rect: rect).fill()
                } else {
                    UIColor.greenColor().colorWithAlphaComponent(indicationStrength).setFill()
                    UIBezierPath(rect: rect).fill()
                }
                break
            default:
                if !indicating {
                    UIColor.redColor().colorWithAlphaComponent(indicationStrength).setFill()
                    UIBezierPath(rect: rect).fill()
                } else {
                    UIColor.greenColor().colorWithAlphaComponent(indicationStrength).setFill()
                    UIBezierPath(rect: rect).fill()
                }
        }
        
        switch stage {
            case 0...2:
                if let spot = currentPoints[100693] {
                    drawSpot(spot)
                }
            default:
                break
        }
        
        drawSpots(currentPoints)
        
        if currentPoints.count < 1 {
            
            // set the text color to dark gray
            let fieldColor: UIColor = UIColor.darkGrayColor()
            
            // set the font to Helvetica Neue 18
            let fieldFont = UIFont(name: "Helvetica Neue", size: 18)
            
            // set the line spacing to 6
            let paraStyle = NSMutableParagraphStyle()
            paraStyle.lineSpacing = 6.0
            
            // set the Obliqueness to 0.1
            let skew = 0.1
            
            let attributes: NSDictionary = [
                NSForegroundColorAttributeName: fieldColor,
                NSParagraphStyleAttributeName: paraStyle,
                NSObliquenessAttributeName: skew,
                NSFontAttributeName: fieldFont!
            ]
            
            emptyCanvasMessage.drawInRect(CGRectMake(frame.size.width / 4, frame.size.height / 4, frame.size.width * 5 / 10, frame.size.height * 5 / 10), withAttributes: attributes as? [String : AnyObject])
        }
    }
    
    func drawSpot(point: (x: Float, y: Float, color: UIColor)){
        let rect = CGRect(x: CGFloat(point.x - pointWidth / 2), y: CGFloat(point.y - pointWidth / 2), width : CGFloat(pointWidth), height: CGFloat(pointWidth))
        
        let circle = UIBezierPath(ovalInRect: rect)
        point.color.setFill()
        circle.fill()
    }
    
    func drawSpot(point: (x: Float, y: Float, color: UIColor), alpha: CGFloat){
        let rect = CGRect(x: CGFloat(point.x - pointWidth / 2), y: CGFloat(point.y - pointWidth / 2), width : CGFloat(pointWidth), height: CGFloat(pointWidth))
        
        let circle = UIBezierPath(ovalInRect: rect)
        point.color.colorWithAlphaComponent(alpha).setFill()
        circle.fill()
    }
    
    func update(positions : [Position]) {
        updateSilently(positions)
        setNeedsDisplay()
    }
    
    func update(positions : [Position], stage : Int) {
        updateSilently(positions)
        self.stage = stage
        setNeedsDisplay()
    }
    
    func updateSilently(positions : [Position]) {
        if positions.count > 0 {
            currentPoints = [Int: (x: Float, y:Float, color : UIColor)]()
            for i in 0...positions.count - 1 {
                let position = positions[i]
                currentPoints[position.personId!] = ((x: position.x!, y: position.y!, color: colorWheel[position.personId! % colorWheel.count]))
            }
        }
        setNeedsDisplay()
    }
    
    func drawSpots(points : [Int: (x: Float, y:Float, color : UIColor)]) {
        let keys = Array(points.keys)
        if keys.count > 0 {
            switch stage {
                case 0...1:
                    for i in 1..<keys.count {
                        drawSpot(points[keys[i]]!)
                    }
                default:
                    for i in 0..<keys.count {
                        drawSpot(points[keys[i]]!)
                    }
            }
        }
    }
    
    func setIndication(indicate : Bool) {
        indicating = indicate
    }
    
    enum IndicationMode {
        case Background
        case Room
        case Position
    }

}
