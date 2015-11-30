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
    var currentPoint : (x: Float, y:Float) = (x: 0, y: 0)
    var pathHistory : [(x:Float, y:Float)] = [(x:0, y:0), (x:10, y:10), (x:20, y:20), (x:20, y:30)]
    var positionHistory : [(x:Float, y:Float)] = []
    
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // print(positionHistory)
        drawPath(pathHistory)
        drawTail(positionHistory)
        drawSpot(currentPoint)
    }
    
    func move(point : (x: Float, y:Float)) {
        // print("Moving")
        currentPoint = point
        positionHistory.append(point)
        pathHistory.append(point)
        setNeedsDisplay()
    }
    
    func moveSilently(point : (x: Float, y:Float)) {
        // print("Moving Silently")
        currentPoint = point
        positionHistory.append(point);
        setNeedsDisplay()
    }
    
    func drawSpot(point: (x: Float, y: Float)){
        let rect = CGRect(x: CGFloat(point.x - pointWidth / 2), y: CGFloat(point.y - pointWidth / 2), width : CGFloat(pointWidth), height: CGFloat(pointWidth))
        
        let circle = UIBezierPath(ovalInRect: rect)
        UIColor.init(red: CGFloat(0.0), green: CGFloat(1.0), blue: CGFloat(0.0), alpha: CGFloat(1.0)).setFill()
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
            UIColor.init(red: CGFloat(0.0), green: CGFloat(1.0), blue: CGFloat(0.0), alpha: CGFloat(0.05 * (10.0 - Double(i)))).setFill()
            circle.fill()
        }
        
    }
    
    func drawPath(list: [(x:Float, y:Float)]){
        let path = UIBezierPath()
        path.lineWidth = pathWidth
        path.moveToPoint(CGPoint(x: CGFloat(list[0].x), y: CGFloat(list[0].y)))
        for index in 1...list.count-1 {
            path.addLineToPoint(CGPoint(x: CGFloat(list[index].x), y: CGFloat(list[index].y)))
        }
        UIColor.greenColor().setStroke()
        path.stroke()
    }

}
