//
//  LoadingViewController.swift
//  fbtracker
//
//  Created by Moshe Sivan on 17/03/2017.
//  Copyright © 2017 n72. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addLoadingAnimation()
        
        TrackerDbService.loadData() {
            DispatchQueue.main.async {
                let mainVC = self.storyboard?.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
                self.present(mainVC, animated: true, completion: nil)
            }
        }
    }
    
    func addLoadingAnimation() {
        let radius = CGFloat(15.0)
        
        // Create the circle layer
        let circle = CAShapeLayer()
        let center = CGPoint(x: self.view.frame.midX, y: self.view.frame.midY)
        let startAngle = -Double.pi / 2
        let endAngle = Double.pi * 2.5
        let clockwise: Bool = true
        
        // `clockwise` tells the circle whether to animate in a clockwise or anti clockwise direction
        circle.path = UIBezierPath(arcCenter: center, radius: radius, startAngle: CGFloat(startAngle), endAngle: CGFloat(endAngle), clockwise: clockwise).cgPath
        
        // Configure the circle
        circle.fillColor = UIColor.white.cgColor
        circle.strokeColor = UIColor(red: 0, green: 0.34, blue: 0.6, alpha: 1.0).cgColor
        circle.lineWidth = 4
        circle.strokeEnd = 0.0
        
        // Add the circle to the parent layer
        self.view.layer.addSublayer(circle)
        
        // Configure the animation
        let drawAnimation = CABasicAnimation(keyPath: "strokeEnd")
        drawAnimation.repeatCount = Float(CGFloat.greatestFiniteMagnitude)
        drawAnimation.fromValue = NSNumber(value: 0.0)
        drawAnimation.toValue = NSNumber(value: 1.0)
        drawAnimation.duration = 2.0
        drawAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        
        // Add the animation to the circle
        circle.add(drawAnimation, forKey: "drawCircleAnimation")
    }
}
