//
//  ViewController.swift
//  UIViewAnimationWithTransition
//
//  Created by Bharath Nadampalli on 17/02/17.
//  Copyright © 2017 EMC. All rights reserved.
//

import UIKit

enum loginState : String {
    case Connect = "Connecting...."
    case Authorize = "Authorizing...."
    case SendCred =  "Sending credentials...."
    case Failed = "Failed...."
    

}

extension loginState {
    init?(fromRawValue:Int) {
        switch fromRawValue {
        case 0: self = .Connect
        case 1: self = .Authorize
        case 2: self  = .SendCred
        case 3: self  = .Failed
        default: return nil
        }
    }
}

class ViewController: UIViewController {
    @IBOutlet weak var heading: UILabel!
    @IBOutlet weak var usernameButton: UITextField!
    @IBOutlet weak var passwordButton: UITextField!
    @IBOutlet weak var loginButton: UIButton!


    @IBOutlet weak var cloud1: UIImageView!
    @IBOutlet weak var cloud2: UIImageView!
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .white)
    let status = UIView()
    let label = UILabel()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        loginButton.layer.borderWidth = 1
        loginButton.layer.borderColor = UIColor.gray.cgColor
        
        activityIndicator.frame = CGRect(x: -20.0, y: 6.0, width: 20.0, height: 20.0)
        activityIndicator.startAnimating()
        activityIndicator.alpha = 0.0
        loginButton.addSubview(activityIndicator)
        view.addSubview(status)
        status.frame = loginButton.frame
        
        status.isHidden = true
        label.frame = CGRect(x: 0.0, y: 0.0, width: status.frame.size.width, height: status.frame.size.height)
        label.font = UIFont(name: "HelveticaNeue", size: 18.0)
        label.textColor = UIColor(red: 0.89, green: 0.38, blue: 0.0, alpha: 1.0)
        label.textAlignment = .center
        status.addSubview(label)
        status.layer.backgroundColor = UIColor.red.cgColor
        view.alpha = 0.5
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initialState()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.9, delay: 0, options: [],
                       animations: {
                        self.heading.center.x += self.view.bounds.width
        },
                       completion: nil
        )
        
        UIView.animate(withDuration: 0.9, delay: 0.4, options: [],
                       animations: {
                        self.usernameButton.center.x += self.view.bounds.width
        },
                       completion: nil
        )
        
        //UIView.animate(withDuration: 0.9, delay: 0.8, options: [.repeat, .autoreverse, .curveEaseIn],
        UIView.animate(withDuration: 0.9, delay: 0.8,
                       usingSpringWithDamping: 0.5, initialSpringVelocity: 0.0, options: [],
                       animations: {
                        self.passwordButton.center.x += self.view.bounds.width
        },
                       completion: nil
        )
        
        UIView.animate(withDuration: 0.9, delay: 1.0, options: [.curveEaseOut],
                       animations: {
                        self.view.alpha = 1.0
        },
                       completion: nil
        )
        
        UIView.animate(withDuration: 3.0, delay: 2.0,
                       usingSpringWithDamping: 0.1, initialSpringVelocity: 1.0, options: [],
                       animations: {
                        self.loginButton.center.y -= 30.0
                        self.loginButton.alpha = 1.0
        }, completion: nil)
        animateCloud(cloud: cloud1)
        animateCloud(cloud: cloud2)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
//    .transitionFlipFromLeft
//    .transitionFlipFromRight
//    .transitionCurlUp
//    .transitionCurlDown
//    .transitionCrossDissolve
//    .transitionFlipFromTop
//    .transitionFlipFromBottom
    func initialState() {
        heading.center.x -= view.bounds.width
        usernameButton.center.x -= view.bounds.width
        passwordButton.center.x -= view.bounds.width
        loginButton.center.y += 30.0
        loginButton.alpha = 0.0
    }

    func showMessage(i : Int) {
        UIView.transition(with: status, duration: 1.0, options: [.curveEaseOut,.transitionCurlDown], animations: {
            self.status.isHidden  =  false
            self.status.layer.borderColor = UIColor.red.cgColor
            self.status.layer.borderWidth = 1.0
            self.label.text = loginState(fromRawValue: i)?.rawValue
           
            self.label.textColor = UIColor.white
        }, completion: {_ in
            if i < 0 {
                self.removeMessage(next: i)
            }else {
                
                UIView.transition(with: self.status, duration: 1.0, options: [.curveEaseOut,.transitionCurlUp], animations: {
                    self.status.isHidden  =  true
                    self.status.layer.borderColor = UIColor.red.cgColor
                    self.status.layer.borderWidth = 1.0
                    //self.label.text = "Hello World!"
                })
            }
        })
    }
    
    func removeMessage(next: Int) {

        UIView.transition(with: status, duration: 1.0, options: [.curveEaseOut,.transitionCurlUp], animations: {
            self.status.isHidden  =  true
            self.status.layer.borderColor = UIColor.red.cgColor
            self.status.layer.borderWidth = 1.0
            //self.label.text = "Hello World!"
        }, completion: {_ in
            self.showMessage(i: next+1)
        })
    }
    
    @IBAction func loginClicked(_ sender: Any) {
        UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.0, options: [], animations: {
            self.loginButton.bounds.size.width += 80.0
        }, completion: nil)
        
        UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.0, options: [], animations: {
            self.loginButton.frame.origin.y += 60
            self.loginButton.backgroundColor = UIColor(red: 0.85, green: 0.0, blue: 0.0, alpha: 1.0)
            self.loginButton.setTitleColor(UIColor.white, for: .normal)
            
            self.activityIndicator.alpha = 1.0
            self.activityIndicator.center  = CGPoint(
                x: 40.0,
                y: self.loginButton.frame.height/2
            )
        }, completion: {_ in
            self.showMessage(i: 0)
        })
    }
    
    func animateCloud(cloud: UIImageView) {
        let cloudSpeed = 100.0 / view.frame.size.width
        let duration = (view.frame.size.width - cloud.frame.origin.x) * cloudSpeed
        UIView.animate(withDuration: TimeInterval(duration), delay: 0.0, options: .curveLinear,
                       animations: {
                        cloud.frame.origin.x = self.view.frame.size.width
        },completion: {_ in
                        cloud.frame.origin.x = -cloud.frame.size.width
                        
                        self.animateCloud(cloud: cloud)
          })
    }
}
