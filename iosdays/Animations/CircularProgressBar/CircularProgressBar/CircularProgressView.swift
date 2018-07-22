//
//  CircularProgressView.swift
//  CircularProgressBar
//
//  Created by Bharath Nadampalli on 04/09/17.
//  Copyright © 2017 com.samples. All rights reserved.
//

import UIKit

class CircularProgressView: UIView {
    var label : UILabel = UILabel()
    var circleLayer: CAShapeLayer? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    func commonInit() {
        self.label.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        self.label.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        self.label.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8)
        self.label.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.8)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.reloadAnimation(_:)))
        self.addGestureRecognizer(tapGesture)
        self.initializeLayer()
    }
    
    func initializeLayer()  {
        self.circleLayer = CAShapeLayer()

        let finalPath = UIBezierPath(arcCenter: CGPoint(x: self.frame.size.width / 2.0, y: self.frame.size.height / 2.0), radius: (self.frame.size.width - 10)/2, startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
        //finalPath.addQuadCurve(to: <#T##CGPoint#>, controlPoint: <#T##CGPoint#>)
        
        self.circleLayer?.path = finalPath.cgPath
        
        self.circleLayer?.fillColor = UIColor.clear.cgColor
        
        circleLayer?.strokeColor = UIColor.red.cgColor

        circleLayer?.lineWidth = 3.0
        circleLayer?.strokeEnd = 0.0
        let _ : Float  = Float((circleLayer?.lineWidth)! * 2.0)
        circleLayer?.lineDashPattern = [1,8]// [0.8, NSNumber(value: flt)]
        circleLayer?.lineCap = kCALineCapRound
        self.layer.addSublayer(circleLayer!)
        self.animateCircle(duration: 2.0)
        
    }
    
    func animateCircle(duration: TimeInterval) {
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = duration
        animation.fromValue = 0
        animation.toValue = 1
        
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        circleLayer?.strokeEnd = 1.0
        circleLayer?.add(animation, forKey: "animateCircle")
    }
    
    func reloadAnimation(_ sender: UITapGestureRecognizer) {
        self.circleLayer?.removeFromSuperlayer()
        self.layer.layoutIfNeeded()
        self.initializeLayer()
        self.animateCircle(duration: 2.0)
    }
}
