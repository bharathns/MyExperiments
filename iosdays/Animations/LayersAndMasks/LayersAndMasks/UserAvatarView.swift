//
//  UserAvatarView.swift
//  LayersAndMasks
//
//  Created by Bharath Nadampalli on 05/09/17.
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

@IBDesignable
class UserAvatarView: UIView {
    //var imageView : UIImageView? = nil
    let lineWidth: CGFloat = 2.0
    let animationDuration = 1.0
    
    var imageLayer: CALayer = CALayer()
    var maskLayer: CAShapeLayer = CAShapeLayer()
    var circleBorderLayer: CAShapeLayer = CAShapeLayer()
    
    @IBInspectable
    var image: UIImage? = nil {
        didSet {
            imageLayer.contents = image?.cgImage
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override func didMoveToWindow() {
        print("didMoveToWindow")
        layer.addSublayer(imageLayer)
        self.imageLayer.mask = maskLayer
        layer.addSublayer(circleBorderLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        print("layoutSubviews")
        guard image != nil, let imageSize = self.image?.size else {
            return
        }
        
        imageLayer.frame = CGRect(
            x: 0,
            y: 0,
            width: imageSize.width,
            height: imageSize.height)
        print("\(bounds) : \(self.image?.size)")
        //create circular mask
        maskLayer.path = UIBezierPath(ovalIn: bounds).cgPath
        maskLayer.position = CGPoint(x: 0.0, y: 0.0)
        
        //create a circular border
        circleBorderLayer.path = maskLayer.path
        circleBorderLayer.fillColor = UIColor.clear.cgColor
        circleBorderLayer.lineWidth = lineWidth
        circleBorderLayer.strokeColor =  "#00919A".UIColorFromHexCode?.cgColor
        
    }
    
    func commonInit () {

    }
    
    func setImage(imageName: String) {
        
    }
    
    func animateLayer() {
        
        guard let frame: CGRect = self.superview?.frame else {
            return
        }
        
        print("\(frame) : \(self.frame)")
        CATransaction.begin()
        CATransaction.setCompletionBlock({
           print("Reached the Other end")
            
           self.layer.position.x = frame.width-(self.frame.width/2)
           self.bounce()
        })
        
        let keyAn = CAKeyframeAnimation(keyPath: "position.x")
        keyAn.duration = 2.0
        //keyAn.repeatCount = 10
        //keyAn.values = [0, 10, -10, 10, -5, 5, -5, 0 ]
        //keyAn.keyTimes = [0, 0.125, 0.25, 0.375, 0.5, 0.625, 0.75, 0.875, 1]

        //keyAn.keyTimes =  [0.0, 0.25, 0.5, 0.75, 1.0]
        
        //keyAn.values = [self.frame.origin.x + frame.origin.x, frame.origin.x+(frame.size.width)/4, frame.origin.x+(frame.size.width)/2, frame.origin.x + (frame.size.width * 3/4), frame.width-(self.frame.width/2)]

        keyAn.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        keyAn.keyTimes =  [0.0,1.0]
        keyAn.values = [self.frame.origin.x + frame.origin.x, frame.width-(self.frame.width/2)]
        print("\(keyAn.values)")
        self.layer.add(keyAn, forKey: "move")
        
        CATransaction.commit()
        
    }
    
    func bounce() {
        guard let frame: CGRect = self.superview?.frame else {
            return
        }
        let morphedFrame = CGRect(x: frame.width-(self.frame.width/2),
                   y: bounds.origin.y,
                   width: bounds.size.width-10, height: bounds.size.height)
        
        let morphAnimation = CABasicAnimation(keyPath: "frame")
        morphAnimation.duration = animationDuration
        morphAnimation.toValue = morphedFrame //UIBezierPath(ovalIn: morphedFrame).cgPath
        
        morphAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        
        self.circleBorderLayer.add(morphAnimation, forKey: nil)
        self.maskLayer.add(morphAnimation, forKey: nil)
    }

}
