//
//  Cadence.swift
//  Cadence
//
//  Created by Yung-Luen Lan on 9/28/15.
//  Copyright © 2015 yllan. All rights reserved.
//

import Foundation

protocol CadenceDelegate {
    func updateCadenceRPM(rpm: Double, cadenceCount: Int, exact: Bool)
}

class Cadence {
    // baseline
    var minMagnitude = 0.0
    var maxMagnitude = 120.0

    var totalCount = 0
    var beginDate: NSDate? = nil
    var previousDate: NSDate? = nil
    var previousTopDate: NSDate? = nil
    var previousMagnitude = 0.0
    
    var delegate: CadenceDelegate? = nil
    
    var reachedTop = false
    
    /* calibrate */
    func beginCalibrate() {
        minMagnitude = Double.infinity
        maxMagnitude = -Double.infinity
    }
    
    func calibrate(magnitude: Double) {
        minMagnitude = min(minMagnitude, magnitude)
        maxMagnitude = max(maxMagnitude, magnitude)
    }
 
    /* measure */
    func beginMeasure() {
        totalCount = 0
        beginDate = NSDate()
        previousMagnitude = 0
        previousTopDate = nil
    }
    
    func updateMagnitue(magnitude: Double) {
        let now = NSDate()
        
        // prediction, use interpolation
        if let previousDate = previousDate {
            let minM = min(previousMagnitude, magnitude, minMagnitude)
            let maxM = max(previousMagnitude, magnitude, maxMagnitude)
            let threshold = (minM + maxM) / 2
            
            let thetaA = asin((previousMagnitude - threshold) / threshold)
            let thetaB = asin((magnitude - threshold) / threshold)
            
            // delta theta over the whole circle
            let deltaThetaOver2Pi = abs(thetaA - thetaB) / (M_PI * 2)
            
            let predictDuration = now.timeIntervalSinceDate(previousDate) / deltaThetaOver2Pi
            if let delegate = delegate {
                delegate.updateCadenceRPM(rpm(predictDuration), cadenceCount: totalCount, exact: false)
            }
        }
        
        func insideNeighborZone(m: Double) -> Bool {
            return m >= (maxMagnitude - minMagnitude) / 2;
        }
        
        let prevInsideZone = insideNeighborZone(previousMagnitude)
        let nowInsideZone = insideNeighborZone(magnitude)

        if !prevInsideZone && nowInsideZone { // enter zone
            reachedTop = false
        } else if prevInsideZone && !nowInsideZone && !reachedTop { // leave zone
            cadenceOnce(now)
        } else if nowInsideZone && !reachedTop && previousMagnitude > magnitude { // in the zone, reaching top
            reachedTop = true
            cadenceOnce(now)
        }
        
        previousDate = now
        previousMagnitude = magnitude
    }
    
    func rpm(duration: Double) -> Double {
        return 60.0 / duration
    }
    
    func cadenceOnce(now: NSDate) {
        if let previousTopDate = previousTopDate {
            if let delegate = delegate {
                delegate.updateCadenceRPM(rpm(now.timeIntervalSinceDate(previousTopDate)), cadenceCount: totalCount + 1, exact: true)
            }
        }
        
        previousTopDate = now
        totalCount++
    }
}