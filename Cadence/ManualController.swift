//
//  ManualController.swift
//  Cadence
//
//  Created by Yung-Luen Lan on 10/13/15.
//  Copyright © 2015 yllan. All rights reserved.
//

import Foundation
import UIKit

class ManualController: UIViewController, UIScrollViewDelegate {

    var scrollView: UIScrollView!
    var scrollFromBeign = false
    var scrollFromEnd = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.opaque = true
        self.view.backgroundColor = UIColor.clearColor()
        
        self.scrollView = UIScrollView(frame: self.view.bounds)
        self.scrollView.backgroundColor = UIColor.clearColor()
        self.scrollView.showsVerticalScrollIndicator = false
        self.scrollView.delegate = self
        self.view.addSubview(self.scrollView)
        
        let manualImage = UIImage.init(named: "Manual")
        let imageView = UIImageView(image: manualImage)
        imageView.backgroundColor = UIColor.whiteColor()
        self.scrollView.addSubview(imageView)
        imageView.frame = CGRectMake((self.scrollView.frame.size.width - (manualImage?.size.width)!) / 2, 0, (manualImage?.size.width)!, (manualImage?.size.height)!)
        
        self.scrollView.contentSize = CGSizeMake(max(self.scrollView.frame.size.width, (manualImage?.size.width)!), (manualImage?.size.height)!)
        
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        scrollFromBeign = (scrollView.contentOffset.y <= 0)
        scrollFromEnd = (scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height))
    }
    
    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let threshold: CGFloat = 2.0
        if (scrollFromBeign && velocity.y <= -threshold) {
            let v = scrollView.snapshotViewAfterScreenUpdates(false)
            scrollView.hidden = true
            self.view.addSubview(v)
            
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                v.frame = CGRectOffset(self.view.frame, 0, self.view.frame.size.height * 2)
                }, completion: { (finished) -> Void in
                    self.dismissViewControllerAnimated(false) {}
            })
        } else if (scrollFromEnd && velocity.y >= threshold) {
            let v = scrollView.snapshotViewAfterScreenUpdates(false)
            scrollView.hidden = true
            self.view.addSubview(v)

            UIView.animateWithDuration(0.5, animations: { () -> Void in
                v.frame = CGRectOffset(self.view.frame, 0, -self.view.frame.size.height * 2)
                }, completion: { (finished) -> Void in
                    self.dismissViewControllerAnimated(false) {}
            })
        }
    }
}