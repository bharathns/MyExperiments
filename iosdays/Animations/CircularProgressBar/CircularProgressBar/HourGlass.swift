//
//  HourGlass.swift
//  CircularProgressBar
//
//  Created by Bharath Nadampalli on 04/09/17.
//  Copyright © 2017 com.samples. All rights reserved.
//

import UIKit
extension String {
    var UIColorFromHexCode: UIColor? {
        let hex = self.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        guard Scanner(string: hex).scanHexInt32(&int) else {
            return nil
        }
        let a, r, g, b: UInt32
        switch hex.characters.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            return nil
        }
        return UIColor(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}
class HourGlass: UIView {
    var shapeLayer: CAShapeLayer? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    func commonInit()  {
        self.initializeLayer()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.reloadAnimation(_:)))
        self.addGestureRecognizer(tapGesture)
    }
    
    func initializeLayer()  {
        self.shapeLayer = CAShapeLayer()
        
        _ = UIBezierPath(arcCenter: CGPoint(x: self.frame.size.width / 2.0, y: self.frame.size.height / 2.0), radius: (self.frame.size.width - 10)/2, startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)

        let clockPath = CGMutablePath()
        clockPath.move(to: CGPoint(x: 10, y: 0))

        clockPath.addLine(to: CGPoint(x: self.frame.width-10, y: 0))
        clockPath.addArc(center: CGPoint(x: self.frame.width-10, y: 10), radius: 10.0, startAngle: CGFloat(Double.pi * 3/2), endAngle: CGFloat(0), clockwise: false)
        let xStartPoint = self.frame.width
        clockPath.addCurve(to: CGPoint(x: (self.frame.width/2)+5, y: self.frame.height/2), control1: CGPoint(x: xStartPoint, y: (self.frame.height/2)  * 0.66), control2: CGPoint(x: (self.frame.width/2)+5, y: (frame.height/2) * 0.66))
        
        clockPath.addCurve(to: CGPoint(x: self.frame.width, y: self.frame.height-10), control1: CGPoint(x:(self.frame.width/2)+5, y: (self.frame.height/2) + ((self.frame.height/2) * 0.34)), control2:CGPoint(x: xStartPoint, y: ((frame.height-10) - ((self.frame.height-10) * 0.30))))
        //clockPath.move(to: CGPoint(x: self.frame.width, y: self.frame.height-10))
        //clockPath.addLine(to: CGPoint(x: self.frame.width, y: self.frame.height-10))
        clockPath.addArc(center: CGPoint(x: self.frame.width-10, y: self.frame.height-10), radius: 10.0, startAngle: CGFloat(0), endAngle: CGFloat(Double.pi/2), clockwise: false)
        clockPath.addLine(to: CGPoint(x: 10, y: self.frame.height))
        clockPath.addArc(center: CGPoint(x: 10, y: self.frame.height-10), radius: 10.0, startAngle: CGFloat(Double.pi/2), endAngle: CGFloat(Double.pi), clockwise: false)
        clockPath.addCurve(to: CGPoint(x: (self.frame.width/2)-5, y: self.frame.height/2), control1: CGPoint(x: 0, y: ((frame.height-10) - ((self.frame.height-10) * 0.30))), control2: CGPoint(x: (self.frame.width/2)-5, y: (self.frame.height/2) + ((self.frame.height/2) * 0.34)) )
        clockPath.addCurve(to: CGPoint(x: 0, y: 10), control1: CGPoint(x: (self.frame.width/2)-5, y: (frame.height/2) * 0.66), control2: CGPoint(x: 0, y: (self.frame.height/2) * 0.66))

        //clockPath.move(to: CGPoint(x: 0, y: 10))
        //clockPath.addLine(to: CGPoint(x: 0, y: 10))
        clockPath.addArc(center: CGPoint(x: 10, y: 10), radius: 10.0, startAngle: CGFloat(Double.pi), endAngle: CGFloat(Double.pi * (3/2)), clockwise: false)
       
//        let linePath = UIBezierPath()
//        linePath.move(to: CGPoint(x: 0, y: 10))
//        
//        // using ease in and ease out co-efficients to find the control points
//        
//        linePath.addCurve(to: CGPoint(x: (self.frame.width/2)-5, y: self.frame.height/2), controlPoint1: CGPoint(x: 0, y: (self.frame.height/2) * 0.66), controlPoint2: CGPoint(x: (self.frame.width/2)-5, y: (frame.height/2) * 0.66))
//        
//        linePath.addCurve(to: CGPoint(x: 0, y: self.frame.height-10), controlPoint1: CGPoint(x: (self.frame.width/2)-5, y: (self.frame.height/2) + ((self.frame.height/2) * 0.34)) , controlPoint2: CGPoint(x: 0, y: ((frame.height-10) - ((self.frame.height-10) * 0.30))))
//        
//        linePath.move(to: CGPoint(x: self.frame.width, y: 10))
//        //let xStartPoint = self.frame.width
//        linePath.addCurve(to: CGPoint(x: (self.frame.width/2)+5, y: self.frame.height/2), controlPoint1: CGPoint(x: xStartPoint, y: (self.frame.height/2)  * 0.66), controlPoint2: CGPoint(x: (self.frame.width/2)+5, y: (frame.height/2) * 0.66))
//        
//        linePath.addCurve(to: CGPoint(x: self.frame.width, y: self.frame.height-10), controlPoint1: CGPoint(x:(self.frame.width/2)+5, y: (self.frame.height/2) + ((self.frame.height/2) * 0.34)), controlPoint2: CGPoint(x: xStartPoint, y: ((frame.height-10) - ((self.frame.height-10) * 0.30))))
        
        //clockPath.addPath(linePath.cgPath)
        
        self.shapeLayer?.path = clockPath
       
        self.shapeLayer?.cornerRadius = 5.0

        self.shapeLayer?.fillColor =   UIColor.clear.cgColor
        
        shapeLayer?.strokeColor = "#00919A".UIColorFromHexCode?.cgColor
        
        shapeLayer?.lineWidth = 2.0
        //shapeLayer?.strokeEnd = 0.0
        let _ : Float  = Float((shapeLayer?.lineWidth)! * 2.0)
        //shapeLayer?.lineDashPattern = [1,8]// [0.8, NSNumber(value: flt)]
        shapeLayer?.lineCap = kCALineCapRound
        self.layer.addSublayer(shapeLayer!)
        self.shapeLayer?.layoutIfNeeded()
        self.animateCircle(duration: 2.0)
    }
    
    func animateCircle(duration: TimeInterval) {
        
        let animation = CABasicAnimation(keyPath: "layoutIfNeeded")
        animation.duration = duration
        animation.fromValue = 0
        animation.toValue = 1
        
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        shapeLayer?.strokeEnd = 1.0
        shapeLayer?.add(animation, forKey: "animateCircle")
    }
    
    func reloadAnimation(_ sender: UITapGestureRecognizer) {
        self.shapeLayer?.removeFromSuperlayer()
        self.layer.layoutIfNeeded()
        self.initializeLayer()
        self.animateCircle(duration: 2.0)
    }
}

