//
//  ViewController.swift
//  LayerAnimations
//
//  Created by Bharath Nadampalli on 25/08/17.
//  Copyright © 2017 com.samples. All rights reserved.
//

import UIKit
@objc enum Direction : Int, RawRepresentable {
    case left = -1
    case right = 1
    
    func offSet() -> Double {
        return 15.0 * Double(self.rawValue)
    }
    
    public var rawValue: RawValue {
        switch self {
        case .left:
            return -1
        default:
            return 1
        }
    }
}

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


class ViewController: UIViewController {

    @IBOutlet weak var username: UITextField!
    
    @IBOutlet weak var animal: UIImageView!
    
    @IBOutlet weak var button: UIButton!
    var maskLayer : CAShapeLayer = CAShapeLayer()
    
    var shapeLayer : CAShapeLayer?
    @IBOutlet weak var swooshButton: UIButton!
    
    var swooshDirection : Direction = .left
    var swooshLayers : [CAShapeLayer]?
    var disable : Bool  = false
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        guard let path: UIBezierPath = UIBezierPath(arcCenter: CGPoint(x:  self.animal.frame.midX, y: self.animal.frame.midY), radius: 15, startAngle: 0.0, endAngle: CGFloat(2 * Double.pi), clockwise: true)  else {
            return
        }
        
        self.animateUserName()
        
        self.animal.layer.borderColor = UIColor.red.cgColor
        self.animal.layer.borderWidth = 1.0
        self.animal.layer.cornerRadius = 25.0
        self.animal.layer.masksToBounds = true
        self.animateCorners(layer: self.animal.layer, toRadius: 5.0)
        
        self.button.layer.borderWidth = 1.0
        self.button.layer.borderColor = UIColor.blue.cgColor
        self.button.layer.cornerRadius = 5.0
        self.button.layer.shadowColor = UIColor.black.cgColor
        self.button.layer.shadowRadius = 10.0
        self.button.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        self.button.layer.shadowOpacity = 1.0
        self.animateOpacity(layer: self.button.layer,from: 0.0, to: 1.0)
        
        
        let shapeLayer = CAShapeLayer()
        
        shapeLayer.frame = CGRect(x: self.view.frame.width/2, y: self.view.frame.height/2, width: 120.0, height: 120.0)
        shapeLayer.lineWidth = 1.5
        shapeLayer.fillColor = nil
        shapeLayer.strokeColor = "#007CBB".UIColorFromHexCode?.cgColor
        shapeLayer.path = UIBezierPath(rect: shapeLayer.bounds).cgPath
        
        let linePath = UIBezierPath()
        linePath.move(to: shapeLayer.bounds.origin)
        self.view.layer.addSublayer(shapeLayer)
        
        let pathAnimation = CABasicAnimation(keyPath: "path")
        pathAnimation.toValue = linePath
        pathAnimation.fromValue = UIBezierPath(rect: shapeLayer.bounds).cgPath
        pathAnimation.duration = 0.75
        pathAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        pathAnimation.autoreverses = true
        pathAnimation.repeatCount = .greatestFiniteMagnitude
        
        shapeLayer.add(pathAnimation, forKey: "pathAnimation")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
       
       
       
        CATransaction.commit()
//        let shapeLayer = CAShapeLayer()
//
//        shapeLayer.bounds = CGRect(x: 10.0, y: 10.0, width: 9.9, height: 2.0)
//        shapeLayer.lineWidth = 1.0
//        shapeLayer.fillColor = nil
//        shapeLayer.strokeColor = "#007CBB".UIColorFromHexCode?.cgColor
        
//        let linePath = UIBezierPath()
//        linePath.move(to: CGPoint(x:shapeLayer.frame.size.width,y:0))
//        linePath.addLine(to: CGPoint(x: 9.9, y: 0.0))
//
//        shapeLayer.path = linePath.cgPath
        //self.animateSwoosh(layer: shapeLayer, from: 0.0, to: 1.0)
    }

    func animateUserName() {
        
        //bezier timing function
        /*{"ease":".25,.1,.25,1","linear":"0,0,1,1","ease-in":".42,0,1,1","ease-out":"0,0,.58,1","ease-in-out":".42,0,.58,1"}
        */
        let timingFunction = CAMediaTimingFunction(controlPoints: 0.42,0.0,0.58,1.0)
        let caBasicAnimation: CABasicAnimation = CABasicAnimation(keyPath: "position.x")
        caBasicAnimation.fromValue = -self.view.bounds.size.width/2
        caBasicAnimation.toValue = self.view.bounds.size.width/2
        caBasicAnimation.duration = 1.0
        
        CATransaction.begin()
        CATransaction.setAnimationTimingFunction(timingFunction)
            self.username.layer.add(caBasicAnimation, forKey: "position")
        CATransaction.commit()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { 
            self.animateUserName()
        }
    }

    
    func animateCorners(layer: CALayer, toRadius: CGFloat) {
        let round = CABasicAnimation(keyPath: "cornerRadius")
        round.fromValue = layer.cornerRadius
        round.toValue = toRadius
        round.duration = 2.5
        layer.add(round, forKey: "cornerRadius")
        layer.cornerRadius = toRadius
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            layer.cornerRadius = 25.0
            self.animateCorners(layer: layer, toRadius: toRadius)
        }
    }
    
    func animateOpacity(layer: CALayer, from: CGFloat, to: CGFloat) {
        let opacity = CABasicAnimation(keyPath: "opacity")
        opacity.fromValue = from
        opacity.toValue = to
        opacity.duration = 1.5
        opacity.delegate = self
        layer.add(opacity, forKey: "opacity")
        layer.opacity = Float(to)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            self.animateOpacity(layer: layer,from: (from==1.0 ? 0.0 : 1.0) , to : (to == 1.0 ? 0.0 : 1.0))
        }
    }
    
    func animateSwoosh(layer: CAShapeLayer, from: CGFloat, to: CGFloat) {
        let linePath = UIBezierPath()
        linePath.move(to: CGPoint(x:layer.bounds.size.width,y:0))
        linePath.addLine(to: CGPoint(x: 100, y: 0.0))
        
        layer.path = linePath.cgPath
        self.swooshButton.layer.addSublayer(layer)
        
        let pathAnimation = CABasicAnimation(keyPath: "path")
        pathAnimation.toValue = linePath.cgPath
        pathAnimation.duration = 0.75
        pathAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        pathAnimation.autoreverses = true
        pathAnimation.repeatCount = .greatestFiniteMagnitude

        layer.add(pathAnimation, forKey: "pathAnimation")
        
//        let opacity = CABasicAnimation(keyPath: "opacity")
//        opacity.fromValue = from
//        opacity.toValue = to
//        opacity.duration = 1.5
//        opacity.delegate = self
//        layer.add(opacity, forKey: "opacity")
//        layer.opacity = Float(to)
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
//            self.animateOpacity(layer: layer,from: (from==1.0 ? 0.0 : 1.0) , to : (to == 1.0 ? 0.0 : 1.0))
//        }
    }
    
    @IBAction func swoosh(_ sender: Any) {
        self.swooshDirection = (self.swooshDirection == .left) ? .right : .left
        guard let button = sender as? UIButton else {
            return
        }
        
        self.shapeLayer?.removeFromSuperlayer()
        
        // create whatever path you want
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: button.bounds.width/2, y: button.bounds.height/2))
        path.addLine(to: CGPoint(x: (button.bounds.width/2) - 9.9, y: button.bounds.height/2))
        //path.addLine(to: CGPoint(x: 200, y: 240))
        
        // create shape layer for that path
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.fillColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0).cgColor
        shapeLayer.strokeColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1).cgColor
        shapeLayer.lineWidth = 1.2
        shapeLayer.path = path.cgPath
        
        // animate it
        
        //button.layer.addSublayer(shapeLayer)
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.duration = 1
        //shapeLayer.add(animation, forKey: "MyAnimation")
        self.swooshLayers = self.swooshLayers ?? self.swooshLines(view: button, direction: .left)
        self.swooshLayers?.forEach{ button.layer.addSublayer($0)}
        button.animateSwooshLines(layers: self.swooshLayers, durations: [1.25, 0.75, 1.0])

        // save shape layer
        self.shapeLayer = shapeLayer
        
    }
    
    @IBAction func changeDirection(_ sender: Any) {
        self.swooshDirection = self.swooshDirection == .left ? .right : .left
        guard let layers = self.swooshLayers else {
            return
        }
        self.swooshButton.changeSwooshLinePath(layers: layers , direction: self.swooshDirection)
        
    }
    
    @IBAction func changeColor(_ sender: Any) {
        guard let layers = self.swooshLayers else {
            return
        }
        disable  = disable ? false : true
        let color  = disable ? "#007CBB".UIColorFromHexCode?.cgColor : UIColor.lightGray.cgColor
        self.swooshButton.changeSwooshLineColor(layers: layers, color: color ?? UIColor.lightGray.cgColor )
    }
    
    func swooshLines(view: UIView, direction: Direction) -> [CAShapeLayer] {
        var swooshLayers = [CAShapeLayer]()
        var lengths = [6.9,9.9,4.3]
        var origins = [-3.0, 0.0, 3.0]
        for (index, length) in lengths.enumerated() {
            let path = UIBezierPath()
            path.move(to: CGPoint(x: Double(view.bounds.width/2) + direction.offSet(), y: Double(view.bounds.height/2) + origins[index]))
            path.addLine(to: CGPoint(x: Double(view.bounds.width/2) + direction.offSet() + (length * Double(direction.rawValue)), y:  Double(view.bounds.height/2) + origins[index]))
            
            let shapeLayer = CAShapeLayer()
            shapeLayer.fillColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0).cgColor
            shapeLayer.strokeColor = "#007CBB".UIColorFromHexCode?.cgColor
            shapeLayer.lineWidth = 1.2
            shapeLayer.path = path.cgPath
            
            swooshLayers.append(shapeLayer)
        }
        return swooshLayers
    }
    
    
    
    

}

extension ViewController : CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation,
                          finished flag: Bool) {
        anim.value(forKeyPath: "")
        print("animation did finish")
    }
}


@objc extension UIView {
    func animateSwooshLines(layers: [CAShapeLayer]?, durations: [Double]) {
        layers?.enumerated().forEach{
            self.layer.removeAnimation(forKey: "SwooshAnimation \($0)")
        }
        
        layers?.enumerated().forEach{
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.fromValue = 0
            animation.duration = durations[$0]
            $1.add(animation, forKey: "SwooshAnimation \($0)")
        }
    }
    
    func changeSwooshLineColor(layers: [CAShapeLayer], color: CGColor) {
        layers.forEach {
            $0.strokeColor = color
        }
    }
    
    func changeSwooshLinePath(layers: [CAShapeLayer], direction: Direction) {
        guard let layers : [CAShapeLayer] = layers else {
            return
        }
        var lengths = [6.9,9.9,4.3]
        var origins = [-3.0, 0.0, 3.0]
        for (index, layer) in layers.enumerated() {
            let path = UIBezierPath()
            path.move(to: CGPoint(x: Double(self.bounds.width/2) + direction.offSet(), y: Double(self.bounds.height/2) + origins[index]))
            path.addLine(to: CGPoint(x: Double(self.bounds.width/2) + direction.offSet() + (lengths[index] * Double(direction.rawValue)), y:  Double(self.bounds.height/2) + origins[index]))
            layer.path = path.cgPath
        }
        
        self.animateSwooshLines(layers: layers, durations: [1.25, 0.75, 1.0])
    }
}
