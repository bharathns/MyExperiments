//
//  UIView+Extensions.swift
//  KeyFrameAnimationSample
//
//  Created by Bharath Nadampalli on 25/08/17.
//  Copyright © 2017 com.samples. All rights reserved.
//

import UIKit

enum Direction {
    case Horizontal
    case Vertical
}

extension UIView {
    func move(distance: CGFloat, direction : Direction, animated: Bool = false, duration: TimeInterval = 1, delay: TimeInterval, completion:((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: duration, delay: delay, options: [],
                       animations: {
                self.center.x += distance
        }, completion: completion)
    }
    
    
    
}

extension UIImageView {
    func crossDisolve (imageName: String, duration: TimeInterval, completion: ((Bool) -> Void)? = nil) {
        UIView.transition(with: self, duration: duration, options: .transitionCrossDissolve, animations: {
            self.image = UIImage(named: imageName)
        }, completion: completion)
    }
}
