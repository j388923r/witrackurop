//
//  DrawingCanvas.swift
//  WiTrack
//
//  Created by Jamar on 10/30/15.
//  Copyright © 2015 Jamar. All rights reserved.
//

import UIKit

@IBDesignable

class DrawingCanvas: UIView {
    
    // Only override drawRect: if you perform custom drawing.
    let pathWidth : CGFloat = 1.0
    let pointWidth : Float  = 40.0
    var currentPoint : (x: Float, y:Float, color : UIColor) = (x: 0, y: 0, color: UIColor.blackColor())
    var currentPoints = [Int: (x: Float, y:Float, color : UIColor)]()
    var pathHistory : [(x:Float, y:Float)] = []
    var pathHistories = [Int: [(x:Float, y:Float)]]()
    var positionHistory : [(x:Float, y:Float)] = []
    var positionHistories = [Int: [(x:Float, y:Float)]]()
    
    var colorWheel : [UIColor] = [UIColor.redColor(), UIColor.purpleColor(), UIColor.grayColor(), UIColor.greenColor(), UIColor.blackColor(), UIColor.blueColor(), UIColor.brownColor(), UIColor.cyanColor(), UIColor.yellowColor(), UIColor.orangeColor(), UIColor.magentaColor(), UIColor.lightGrayColor(), UIColor.darkGrayColor()]
    
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // print(positionHistory)
        print("drawing")
        //drawPath(pathHistory)
        //drawTail(positionHistory)
        //drawSpot(currentPoint)
        drawSpots(currentPoints)
        if currentPoints.count < 1 {
            let s = "No objects detected."
            
            // set the text color to dark gray
            let fieldColor: UIColor = UIColor.darkGrayColor()
            
            // set the font to Helvetica Neue 18
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
    
    func move(point : (x: Float, y:Float, color: UIColor), personId : Int) {
        // print("Moving")
        currentPoint = point
        currentPoints[personId] = point
        /*if currentPoints.keys.contains(personId) {
            currentPoints[personId]!.append(point)
        } else {
            currentPoints[personId] = [point]
        }*/
        positionHistory.append((x: point.x, y: point.y))
        if positionHistories.keys.contains(personId) {
            positionHistories[personId]!.append((x: point.x, y: point.y))
        } else {
            positionHistories[personId] = [(x: point.x, y: point.y)]
        }
        pathHistory.append((x: point.x, y: point.y))
        if pathHistories.keys.contains(personId) {
            pathHistories[personId]!.append((x: point.x, y: point.y))
        } else {
            pathHistories[personId] = [(x: point.x, y: point.y)]
        }
        setNeedsDisplay()
    }
    
    func update(positions : [Position]) {
        updateSilently(positions)
        setNeedsDisplay()
    }
    
    func moveSilently(point : (x: Float, y:Float, color: UIColor), personId : Int) {
        // print("Moving Silently")
        currentPoint = point
        positionHistory.append((x: point.x, y: point.y));
        setNeedsDisplay()
    }
    
    func updateSilently(positions : [Position]) {
        currentPoints = [Int: (x: Float, y:Float, color : UIColor)]()
        for i in 0...positions.count - 1 {
            let position = positions[i]
            currentPoints[position.personId!] = ((x: position.x!, y: position.y!, color: colorWheel[position.personId!]))
            /*if var cp = currentPoints[position.personId!] {
                cp.append((x: position.x!, y: position.y!, color: colorWheel[position.personId!]))
            } else {
                currentPoints[position.personId!] = [((x: position.x!, y: position.y!, color: colorWheel[position.personId!]))]
            }*/
        }
        setNeedsDisplay()
    }
    
    func saveCurrentPath() {
        pathHistories[0] = pathHistory
        pathHistory = []
    }
    
    func clearPath() {
        pathHistory = []
    }
    
    func drawSpot(point: (x: Float, y: Float, color: UIColor)){
        let rect = CGRect(x: CGFloat(point.x - pointWidth / 2), y: CGFloat(point.y - pointWidth / 2), width : CGFloat(pointWidth), height: CGFloat(pointWidth))
        
        let circle = UIBezierPath(ovalInRect: rect)
        point.color.setFill()
        circle.fill()
    }
    
    func drawSpots(points : [Int: (x: Float, y:Float, color : UIColor)]) {
        let keys = Array(points.keys)
        if keys.count > 0 {
            for i in 0...keys.count-1{
                drawSpot(points[keys[i]]!)
            }
        }
    }
    
    func drawTail(pointList : [(x:Float, y:Float)] ) {
        for i in 1...9 {
            if(pointList.count - 1 < i * 10){
                break
            }
            let point = pointList[pointList.count - i * 10 - 1]
            let rect = CGRect(x: CGFloat(point.x - pointWidth / 2), y: CGFloat(point.y - pointWidth / 2), width : CGFloat(pointWidth), height: CGFloat(pointWidth))
            let circle = UIBezierPath(ovalInRect: rect)
            var red : CGFloat = 0
            var green : CGFloat = 0
            var blue : CGFloat = 0
            currentPoint.color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
            UIColor.init(colorLiteralRed: Float(red), green: Float(green), blue: Float(blue), alpha: 0.5 - 0.05 * Float(i)).setFill()
            circle.fill()
        }
        
    }
    
    func drawPath(list: [(x:Float, y:Float)]){
        if (list.count > 1) {
            let path = UIBezierPath()
            path.lineWidth = pathWidth
            path.moveToPoint(CGPoint(x: CGFloat(list[0].x), y: CGFloat(list[0].y)))
            for index in 1...list.count-1 {
                path.addLineToPoint(CGPoint(x: CGFloat(list[index].x), y: CGFloat(list[index].y)))
            }
            currentPoint.color.setStroke()
            path.stroke()
        }
    }

}
