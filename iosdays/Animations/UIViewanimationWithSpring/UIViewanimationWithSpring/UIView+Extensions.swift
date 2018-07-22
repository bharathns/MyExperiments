//
//  UIView+Extensions.swift
//  UIViewanimationWithSpring
//
//  Created by Bharath Nadampalli on 25/08/17.
//  Copyright © 2017 EMC. All rights reserved.
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
