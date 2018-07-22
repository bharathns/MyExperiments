//
//  ViewController.swift
//  LayerAnimations
//
//  Created by Bharath Nadampalli on 25/08/17.
//  Copyright © 2017 com.samples. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var username: UITextField!
    
    @IBOutlet weak var animal: UIImageView!
    
    @IBOutlet weak var button: UIButton!
    var maskLayer : CAShapeLayer = CAShapeLayer()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
       
       
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
    
    
    
}

extension ViewController : CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation,
                          finished flag: Bool) {
        anim.value(forKeyPath: "")
        print("animation did finish")
    }
}


