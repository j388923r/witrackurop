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
    let pointWidth : Float  = 10.0
    var currentPoint : (x: Float, y:Float, color : UIColor) = (x: 0, y: 0, color: UIColor.blackColor())
    var currentPoints = [Int: [(x: Float, y:Float, color : UIColor)]]()
    var pathHistory : [(x:Float, y:Float)] = []
    var pathHistories = [Int: [(x:Float, y:Float)]]()
    var positionHistory : [(x:Float, y:Float)] = []
    var positionHistories = [Int: [(x:Float, y:Float)]]()
    
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // print(positionHistory)
        print("drawing")
        drawPath(pathHistory)
        drawTail(positionHistory)
        drawSpot(currentPoint)
    }
    
    func move(point : (x: Float, y:Float, color: UIColor), personId : Int) {
        // print("Moving")
        currentPoint = point
        if currentPoints.keys.contains(personId) {
            currentPoints[personId]!.append(point)
        } else {
            currentPoints[personId] = [point]
        }
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
    
    func moveSilently(point : (x: Float, y:Float, color: UIColor), personId : Int) {
        // print("Moving Silently")
        currentPoint = point
        positionHistory.append((x: point.x, y: point.y));
        setNeedsDisplay()
    }
    
    func drawSpot(point: (x: Float, y: Float, color: UIColor)){
        let rect = CGRect(x: CGFloat(point.x - pointWidth / 2), y: CGFloat(point.y - pointWidth / 2), width : CGFloat(pointWidth), height: CGFloat(pointWidth))
        
        let circle = UIBezierPath(ovalInRect: rect)
        point.color.setFill()
        circle.fill()
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
