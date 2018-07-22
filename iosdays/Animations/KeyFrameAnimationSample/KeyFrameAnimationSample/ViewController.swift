//
//  ViewController.swift
//  KeyFrameAnimationSample
//
//  Created by Bharath Nadampalli on 25/08/17.
//  Copyright © 2017 com.samples. All rights reserved.
//

import UIKit

var backGroundToggle: Bool = true;
class ViewController: UIViewController {

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var car: UIImageView!
    @IBOutlet weak var globeview: UIImageView!

    var transform = CGAffineTransform.identity
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.driveCar(image: "bg_hello", animated: true)
        self.car.center.x -= 30
        print("\(self.globeview.image?.scale) :  \(self.globeview.image?.size)")
    }
    
   

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func driveCar(image: String, animated: Bool ) {
        
        self.backgroundImageView.crossDisolve(imageName: image, duration: 1.0)
        
        self.drive()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            backGroundToggle = backGroundToggle ? false : true
            self.car.image = UIImage(named: "icons8_F1_Car")
            self.driveCar(image: backGroundToggle ? "bg_hello" : "bg_geometry", animated: true)
        }

    }
    
    func drive() {
        
        UIView.animateKeyframes(withDuration: 1.0, delay: 0.0,
                                animations: {

                                    UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 0.25,
                                                       animations: {
                                        self.car.center.x += 120.0
                                    }
                                    )
        }, completion: {_ in
            self.reverse()
        })
    }
    
    func reverse() {
        UIView.animateKeyframes(withDuration: 1.0, delay: 0.0,
                                animations: {

                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.01,
                                   animations: {
                                    self.car.image = UIImage(cgImage: (self.car.image?.cgImage)!, scale: (self.car.image?.scale)!, orientation: .upMirrored)
                }
                )

                UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 0.25,
                                   animations: {
                                    self.car.center.x -= 120.0
                }
                )
        }, completion: nil)
    }
    
}

