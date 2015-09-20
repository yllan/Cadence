//
//  ViewController.swift
//  Cadence
//
//  Created by Yung-Luen Lan on 9/19/15.
//  Copyright © 2015 yllan. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var magnitudeLabel: UILabel!

    let locationManager = CLLocationManager()
    let maxSamples = 1000
    var samples: [Double] = []
    var measureMode = false
    var backgroundMagnitude = 0.0
    var nearZone = false
    var prevMagnitude = 0.0
    var reachedTop = false
    
    @IBOutlet weak var cadenceLabel: UILabel!
    @IBOutlet weak var averageLabel: UILabel!

    var previousCadenceDate: NSDate? = nil
    var beginCadenceDate: NSDate? = nil
    var cadenceCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.headingFilter = kCLHeadingFilterNone
        locationManager.delegate = self
        locationManager.startUpdatingHeading()
    }

    deinit {
        locationManager.stopUpdatingHeading()
    }
    
    @IBAction func startMeasure(sender: UIButton) {
        measureMode = true
        var sum = 0.0
        for m in samples { sum += m }
        backgroundMagnitude = sum / Double(samples.count)
        sender.hidden = true
    }
    
    func locationManager(manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        let magnitude = sqrt(newHeading.x * newHeading.x + newHeading.y * newHeading.y + newHeading.z * newHeading.z)
        magnitudeLabel.text = NSString(format: "%.2lf", magnitude) as String
        
        
        if measureMode {
            let threshold = backgroundMagnitude * 1.8
            
            if nearZone && magnitude < threshold {
                nearZone = false
                if !reachedTop {
                    cadenceOnce()
                }
            } else if !nearZone && magnitude >= threshold {
                nearZone = true
                reachedTop = false
                prevMagnitude = magnitude
            }
            
            if nearZone && !reachedTop && magnitude < prevMagnitude {
                reachedTop = true
                cadenceOnce()
            }
            
        } else {
            if samples.count >= maxSamples {
                samples.removeFirst()
            }
            samples.append(magnitude)
        }
    }
    
    func cadenceOnce() {
        let now = NSDate()

        if cadenceCount > 0 {
            updateCurrentCadence(now.timeIntervalSinceDate(previousCadenceDate!))
        } else { // first step
            beginCadenceDate = now
        }
        previousCadenceDate = now
        cadenceCount++;
        updateAverageCadence(now.timeIntervalSinceDate(beginCadenceDate!) / Double(cadenceCount))
    }
    
    func rpm(duration: Double) -> Double {
        return 60.0 / duration
    }
    
    func updateCurrentCadence(duration: NSTimeInterval) {
        cadenceLabel.text = NSString(format: "%.1lf", rpm(duration)) as String
    }

    func updateAverageCadence(duration: NSTimeInterval) {
        averageLabel.text = NSString(format: "%.1lf", rpm(duration)) as String

    }

}

