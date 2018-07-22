//
//  ViewController.swift
//  UIViewanimationWithSpring
//
//  Created by Bharath Nadampalli on 16/02/17.
//  Copyright © 2017 EMC. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var heading: UILabel!
    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var login: UIButton!
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .white)
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        login.layer.borderWidth = 1
        login.layer.borderColor = UIColor.gray.cgColor
        
        activityIndicator.frame = CGRect(x: -20.0, y: 6.0, width: 20.0, height: 20.0)
        activityIndicator.startAnimating()
        activityIndicator.alpha = 0.0
        login.addSubview(activityIndicator)
        
        view.alpha = 0.5
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initialState()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        UIView.animate(withDuration: 0.9, delay: 0, options: [],
//                       animations: {
//                        self.heading.center.x += self.view.bounds.width
//        },
//                       completion: nil
//        )

        self.heading.move(distance: self.view.bounds.width, direction: .Horizontal, duration: 0.9, delay: 0)
        
//        UIView.animate(withDuration: 0.9, delay: 0.4, options: [],
//                       animations: {
//                        self.userName.center.x += self.view.bounds.width
//        },
//                       completion: nil
//        )
        self.userName.move(distance: self.view.bounds.width, direction: .Horizontal, duration: 0.9, delay: 0.4)
        
        //UIView.animate(withDuration: 0.9, delay: 0.8, options: [.repeat, .autoreverse, .curveEaseIn],
        UIView.animate(withDuration: 0.9, delay: 0.8,
                       usingSpringWithDamping: 0.5, initialSpringVelocity: 0.0, options: [],
                       animations: {
                        self.password.center.x += self.view.bounds.width
        },
                       completion: nil
        )
        //self.password.move(distance: self.view.bounds.width, direction: .Horizontal, duration: 0.9, delay: 0.8)
        
        UIView.animate(withDuration: 0.9, delay: 1.0, options: [.curveEaseOut],
                       animations: {
                        self.view.alpha = 1.0
        },
                       completion: nil
        )
        
        UIView.animate(withDuration: 2.0, delay: 2.0,
                       usingSpringWithDamping: 0.1, initialSpringVelocity: 1.0 , options: [],
                       animations: {
                        self.login.center.y -= 30.0
                        self.login.alpha = 1.0
        }, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func initialState() {
        heading.center.x -= view.bounds.width
        userName.center.x -= view.bounds.width
        password.center.x -= view.bounds.width
        login.center.y += 30.0
        login.alpha = 0.0
    }

    @IBAction func loginBtnClk(_ sender: Any) {
        UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.0, options: [], animations: {
            self.login.bounds.size.width += 80.0
        }, completion: nil)
        
        UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.0, options: [], animations: {
            self.login.frame.origin.y += 60
            self.login.backgroundColor = UIColor(red: 0.85, green: 0.0, blue: 0.0, alpha: 1.0)
            self.login.setTitleColor(UIColor.white, for: .normal)
            
            self.activityIndicator.alpha = 1.0
            self.activityIndicator.center  = CGPoint(
                x: 40.0,
                y: self.login.frame.height/2
            )
        }, completion: nil)
    }
}

