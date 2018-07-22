//
//  SlideMenuPresentationAnimator.swift
//  SampleSlideMenu
//
//  Created by Bharath Nadampalli on 12/12/17.
//  Copyright © 2017 com.samples. All rights reserved.
//

import UIKit

class SlideMenuAnimator: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate {
    var snapshot : UIView!
    var isPresenting: Bool = true
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.6
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if isPresenting{
            presentNavigation(transitionContext: transitionContext)
        }else{
            dismissNavigation(transitionContext: transitionContext)
        }
    }
    
    func presentNavigation(transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView
        let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
        let fromView = fromViewController!.view
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        let toView = toViewController!.view
        
        let size = toView?.frame.size
        var offSetTransform = CGAffineTransform(translationX: (size?.width)! - 150, y: 0)
       
        offSetTransform =  offSetTransform.scaledBy(x: 0.8, y: 0.9)//CGAffineTransform.init(scaleX: 0.6, y: 0.6) //CGAffineTransformScale(offSetTransform, 0.6, 0.6)
        
        snapshot = fromView?.snapshotView(afterScreenUpdates: true)
        snapshot.isUserInteractionEnabled = false
        //snapshot.layer.cornerRadius = 2
        container.addSubview(toView!)
        container.addSubview(snapshot!)
        
        let duration = self.transitionDuration(using: transitionContext)
        
        UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.8, options: UIViewAnimationOptions(rawValue: 0), animations: {
            
            self.snapshot.transform = offSetTransform
            
        }, completion: { finished in
            
            transitionContext.completeTransition(true)
        })
    }
    
    func dismissNavigation(transitionContext: UIViewControllerContextTransitioning) {
        
        _ = transitionContext.containerView
        let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
        _ = fromViewController!.view
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        _ = toViewController!.view
        
        let duration = self.transitionDuration(using: transitionContext)
        
        UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8, options:  UIViewAnimationOptions(rawValue: 0), animations: {
            
            self.snapshot.transform = CGAffineTransform.identity
            
        }, completion: { finished in
            transitionContext.completeTransition(true)
            self.snapshot.removeFromSuperview()
        })
    }
    
    // MARK: UIViewControllerTransitioningDelegate implemenation
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.isPresenting = true
        return self
    }
    
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.isPresenting = false
        return self
    }
}
