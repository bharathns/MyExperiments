//
//  ViewController.swift
//  LayerAnimationsPart2
//
//  Created by Bharath Nadampalli on 27/08/17.
//  Copyright © 2017 com.samples. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var username: UITextField!
    
    let moveRight = CABasicAnimation(keyPath: "position.x")
    let fadeIn = CABasicAnimation(keyPath: "opacity")
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        // moveRight = CABasicAnimation(keyPath: "position.x")
        moveRight.toValue = view.bounds.size.width/2
        moveRight.fromValue = -view.bounds.size.width/2
        moveRight.duration = 5.0
        //heading.layer.add(moveRight, forKey: nil)
        
        moveRight.beginTime = CACurrentMediaTime() + 0.3
        moveRight.fillMode = kCAFillModeBoth
        moveRight.delegate = self
        moveRight.setValue(self.username.layer, forKey: "username")
        moveRight.isRemovedOnCompletion = true
        //self.username.layer.add
        self.username.layer.add(moveRight, forKey: "move")
        
        fadeIn.toValue = 1.0
        fadeIn.fromValue = 0.0
        fadeIn.duration = 4.5
        self.username.layer.add(fadeIn, forKey: "fadein")
        //self.username.layer.setValue("moveIn", forKey: "direction")
        //self.username.layer.add(anim: CAAnimation, forKey: <#T##String?#>)
        //username.layer.position.x = view.bounds.size.width/2
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController : CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation,
                          finished flag: Bool) {
        if flag, let layer : CALayer = anim.value(forKey: "username") as? CALayer {
            layer.removeAnimation(forKey: "move")
            print("animation did finish moveIn : \(layer.animationKeys())")
        }
    }
}
