//
//  HistoryView.swift
//  Cadence
//
//  Created by Yung-Luen Lan on 9/29/15.
//  Copyright © 2015 yllan. All rights reserved.
//

import UIKit

class HistoryView : UIView {
    var cadence: Cadence? = nil
    
    override func drawRect(rect: CGRect) {
        let ctx = UIGraphicsGetCurrentContext()
        CGContextSaveGState(ctx)
        
        func yOf(value: Double) -> CGFloat {
            return CGFloat(1.0 - value / 200.0) * rect.size.height
        }
        
        // clear
        CGContextSetFillColorWithColor(ctx, UIColor.clearColor().CGColor)
        CGContextFillRect(ctx, rect)
        
        
        // stroke
        if let c = cadence {
            CGContextSaveGState(ctx)

            
            CGContextSetStrokeColorWithColor(ctx, UIColor(white: 0.0, alpha: 0.2).CGColor)
            CGContextSetLineWidth(ctx, 1)
            
//            CGContextBeginPath(ctx)
//            CGContextMoveToPoint(ctx, 0, yOf(c.minMagnitude))
//            CGContextAddLineToPoint(ctx, rect.size.width, yOf(c.minMagnitude))
//            CGContextMoveToPoint(ctx, 0, yOf(c.maxMagnitude))
//            CGContextAddLineToPoint(ctx, rect.size.width, yOf(c.maxMagnitude))
//            CGContextStrokePath(ctx)
            
            CGContextBeginPath(ctx)
            CGContextMoveToPoint(ctx, 0, yOf((c.maxMagnitude + c.minMagnitude) / 2))
            CGContextAddLineToPoint(ctx, rect.size.width, yOf((c.maxMagnitude + c.minMagnitude) / 2))
            CGContextStrokePath(ctx)
            
            CGContextSetStrokeColorWithColor(ctx, UIColor.blackColor().CGColor)
            CGContextSetLineWidth(ctx, 1)
            let length = min(c.history.count, c.sampleCount)
            let beginAt = (c.sampleCount - length) % c.history.count

            CGContextBeginPath(ctx)
            for i in 0 ..< length {
                let index = (beginAt + i) % c.history.count
                let value = c.history[index]
                let x = CGFloat(i) / CGFloat(c.history.count - 1) * rect.size.width
                let y = yOf(value)
                if i == 0 {
                    CGContextMoveToPoint(ctx, x, y)
                } else {
                    CGContextAddLineToPoint(ctx, x, y)
                }
            }
            CGContextStrokePath(ctx)
            CGContextRestoreGState(ctx)
        }
        
        CGContextRestoreGState(ctx)
    }
}
