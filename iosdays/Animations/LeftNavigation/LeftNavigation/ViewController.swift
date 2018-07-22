//
//  ViewController.swift
//  LeftNavigation
//
//  Created by Bharath Nadampalli on 11/12/17.
//  Copyright © 2017 com.samples. All rights reserved.
//

import UIKit

private let SlideMenuSegueIdentifier = "SlideMenuSegue"
class ViewController: UIViewController, UIViewControllerTransitioningDelegate {
    var interactiveTransition : SlideMenuTransition?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == SlideMenuSegueIdentifier, let navController = segue.source.navigationController as? UINavigationController{
            
            interactiveTransition = SlideMenuTransition()
            
            navController.modalPresentationStyle = .custom
            navController.transitioningDelegate = interactiveTransition
        }
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let slideMenuTransition : SlideMenuTransition = SlideMenuTransition()
        guard let height = self.navigationController?.navigationBar.bounds.height else {
            return nil
        }
       
        return slideMenuTransition
    }
}

