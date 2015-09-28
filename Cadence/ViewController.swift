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

    @IBOutlet var rpmDigits: [UIImageView]!
    @IBOutlet var countDigits: [UIImageView]!
    @IBOutlet var averageDigits: [UIImageView]!
    
    let locationManager = CLLocationManager()
    
    let digitImages: [UIImage]
    let emptyImage: UIImage
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        digitImages = (0...9).map({ i in return UIImage(named: "\(i)")! })
        emptyImage = UIImage(named: "empty")!
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        digitImages = (0...9).map({ i in return UIImage(named: "\(i)")! })
        emptyImage = UIImage(named: "empty")!
        super.init(coder: aDecoder)!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.headingFilter = kCLHeadingFilterNone
        locationManager.delegate = self
        locationManager.startUpdatingHeading()

        
        setRPM(0)
        countDigits.forEach { $0.image = emptyImage }
        averageDigits.forEach { $0.image = emptyImage }
    }
    
    func setRPM(rpm: Double) {
        rpmDigits.forEach { $0.image = emptyImage }
        if rpm >= 100 {
            rpmDigits[0].image = digitImages[Int((rpm / 100) % 10)]
        }
        if rpm >= 10 {
            rpmDigits[1].image = digitImages[Int((rpm / 10) % 10)]
        }
        rpmDigits[2].image = digitImages[Int((rpm / 1) % 10)]
        rpmDigits[3].image = digitImages[Int((rpm / 0.1) % 10)]
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

