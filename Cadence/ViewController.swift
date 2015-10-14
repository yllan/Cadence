//
//  ViewController.swift
//  Cadence
//
//  Created by Yung-Luen Lan on 9/19/15.
//  Copyright © 2015 yllan. All rights reserved.
//

import UIKit
import CoreLocation

infix operator ** { }
func ** (radix: Int, power: Int) -> Int {
    assert(power >= 0, "\(power) should be non-negative")
    var result = 1
    for _ in 0 ..< power {
        result *= radix
    }
    return result
}

class ViewController: UIViewController, CLLocationManagerDelegate, CadenceDelegate {

    @IBOutlet var rpmDigits: [UIImageView]!
    @IBOutlet var countDigits: [UIImageView]!
    @IBOutlet var averageDigits: [UIImageView]!
    @IBOutlet weak var historyView: HistoryView!
    
    let locationManager = CLLocationManager()
    var cadence: Cadence! = Cadence()
    
    let digitImages: [UIImage]
    let emptyImage: UIImage
    
    var begin = false
    
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

        cadence.delegate = self
        
        showRPM(0)
        countDigits.forEach { $0.image = emptyImage }
        averageDigits.forEach { $0.image = emptyImage }
    }
    
    func showRPM(rpm: Double) {
        displayDigit(Int(rpm * 10), digitViews: rpmDigits, leastDigit: 2)
    }
    
    func showCount(total: Int) {
        displayDigit(total, digitViews: countDigits)
    }

    func showAverage(average: Double) {
        displayDigit(Int(average), digitViews: averageDigits)
    }
    
    func displayDigit(digit: Int, digitViews: [UIImageView], leastDigit: Int = 1) {
        var threshold = 10 ** (digitViews.count - 1)
        
        digitViews.forEach {
            if digit >= threshold || threshold < (10 ** leastDigit)  {
                $0.image = digitImages[(digit / threshold) % 10]
            } else {
                $0.image = emptyImage
            }
            threshold /= 10
        }
    }
    
    deinit {
        locationManager.stopUpdatingHeading()
    }
    
    @IBAction func togglePedal(sender: UIButton) {
        sender.setTitle(begin ? NSLocalizedString("Start Pedaling!", comment: "") : NSLocalizedString("Stop Pedaling!", comment: ""), forState: UIControlState.Normal)
        begin = !begin
        if begin {
            UIApplication.sharedApplication().idleTimerDisabled = true
            cadence.clear()
            cadence.beginMeasure()
            locationManager.startUpdatingHeading()
        } else {
            UIApplication.sharedApplication().idleTimerDisabled = false
            locationManager.stopUpdatingHeading()
            cadence.stopMeasure()
        }
    }
    
    func updateCadenceRPM(rpm: Double, cadenceCount: Int, exact: Bool) {
        showRPM(rpm)
        showCount(cadenceCount)
    }
    
    func updateAverageRPM(average: Double) {
        showAverage(average)
    }
    
    func locationManager(manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        let magnitude = sqrt(newHeading.x * newHeading.x + newHeading.y * newHeading.y + newHeading.z * newHeading.z)
        cadence.updateMagnitue(magnitude)
        historyView.cadence = cadence
        historyView.setNeedsDisplay()
    }
    
    @IBAction func showManual(sender: AnyObject) {
        let manualController = ManualController()
        let v = self.view.snapshotViewAfterScreenUpdates(false)
        manualController.view.insertSubview(v, belowSubview: manualController.scrollView)
        self.presentViewController(manualController, animated: true) {
            
        }
    }
    
    func tellServer() {
//        let url = NSURL(string: "http://192.168.1.104:9999/")
//        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
//            print(NSString(data: data!, encoding: NSUTF8StringEncoding))
//        }
//        task.resume()
    }
}

