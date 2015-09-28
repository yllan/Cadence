//
//  ViewController.swift
//  Cadence
//
//  Created by Yung-Luen Lan on 9/19/15.
//  Copyright © 2015 yllan. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate, CadenceDelegate {

    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.headingFilter = kCLHeadingFilterNone
        locationManager.delegate = self
        locationManager.startUpdatingHeading()
    }
    
    deinit {
        locationManager.stopUpdatingHeading()
    }
    
    func updateCadenceRPM(rpm: Double, cadenceCount: Int, exact: Bool) {
        
    }
    
    func locationManager(manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        let magnitude = sqrt(newHeading.x * newHeading.x + newHeading.y * newHeading.y + newHeading.z * newHeading.z)
    }
    
    func tellServer() {
//        let url = NSURL(string: "http://192.168.1.104:9999/")
//        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
//            print(NSString(data: data!, encoding: NSUTF8StringEncoding))
//        }
//        task.resume()
    }
}

