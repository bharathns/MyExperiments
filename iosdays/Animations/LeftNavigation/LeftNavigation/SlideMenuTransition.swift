 //
 //  SlideMenuTransition.swift
 //  LeftNavigation
 //
 //  Created by Bharath Nadampalli on 12/12/17.
 //  Copyright © 2017 com.samples. All rights reserved.
 //
 
 import UIKit
 
 
 class SlideMenuTransition: UIPercentDrivenInteractiveTransition {
 
     fileprivate var presenting: Bool = true
    
     var presentingHeaderSnapshotView: UIView?
 
 }
 
 extension SlideMenuTransition: UIViewControllerTransitioningDelegate {
 
     func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
         self.presenting = true
         return self
     }
    
     func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
         self.presenting = false
         return self
     }
    
     func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return self
     }
    
     func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return self
     }
 
 }
 
 extension SlideMenuTransition: UIViewControllerAnimatedTransitioning {
 
     func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
     }
    
     func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
         if presenting {
            presentViewController(transitionContext)
         }
         else {
            dismissViewController(transitionContext)
         }
     }
 
     fileprivate func presentViewController(_ transitionContext: UIViewControllerContextTransitioning) {
        guard let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to),
            let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) else {
                return
        }
        let containerView = transitionContext.containerView
        let duration = transitionDuration(using: transitionContext)
        
        containerView.backgroundColor = UIColor(white: 0.0, alpha: 0.0)
        containerView.addSubview(toViewController.view)
        
        var startFrame = UIScreen.main.bounds
        startFrame.origin.y = UIScreen.main.bounds.size.height
        toViewController.view.frame = startFrame
        
        var headerFrame = CGRect.zero
        if let headerSnapshotView = presentingHeaderSnapshotView {
            headerFrame = headerSnapshotView.frame
            headerFrame.origin.y = startFrame.origin.y - headerFrame.size.height
            headerSnapshotView.frame = headerFrame
            containerView.addSubview(headerSnapshotView)
            
            headerFrame.origin.y = UIScreen.main.bounds.origin.y - headerFrame.size.height
        }
        
        fromViewController.beginAppearanceTransition(false, animated: true)
        UIView.animate(withDuration: duration, delay: 0.0, options: UIViewAnimationOptions.beginFromCurrentState, animations: { [weak self] in
            containerView.backgroundColor = UIColor(white: 0.0, alpha: 0.8)
            toViewController.view.frame = UIScreen.main.bounds
            self?.presentingHeaderSnapshotView?.frame = headerFrame
            }, completion:  { finished in
                fromViewController.endAppearanceTransition()
                transitionContext.completeTransition(transitionContext.transitionWasCancelled == false)
        })
     }
 
     fileprivate func dismissViewController(_ transitionContext: UIViewControllerContextTransitioning) {
        guard let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to),
            let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) else {
                return
        }
        let containerView = transitionContext.containerView
        let duration = transitionDuration(using: transitionContext)
        toViewController.view.frame = UIScreen.main.bounds
        toViewController.beginAppearanceTransition(true, animated: true)
        UIView.animate(withDuration: duration, delay: 0.0, options: UIViewAnimationOptions.beginFromCurrentState, animations: {
            containerView.backgroundColor = UIColor(white: 0.0, alpha: 0.0)
            
            var frame = UIScreen.main.bounds
            frame.origin.y = frame.height
            fromViewController.view.frame = frame
            
        }, completion: { finished in
            toViewController.endAppearanceTransition()
            transitionContext.completeTransition(transitionContext.transitionWasCancelled == false)
        })
    }
 
 }

 
