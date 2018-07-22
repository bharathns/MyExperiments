//
//  ViewController.swift
//  ViewAnimationsPart1
//
//  Created by Bharath Nadampalli on 15/02/17.
//  Copyright © 2017 EMC. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var header: UILabel!
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        loginButton.layer.borderWidth = 1
        loginButton.layer.borderColor = UIColor.gray.cgColor
        view.alpha = 0.5
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initialPos()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        UIView.animate(withDuration: 0.9, delay: 0, options: [],
                       animations: {
                        self.header.center.x += self.view.bounds.width
        },
                       completion: nil
        )

        UIView.animate(withDuration: 0.9, delay: 0.4, options: [],
                       animations: {
                        self.userNameTextField.center.x += self.view.bounds.width
        },
                       completion: nil
        )

        UIView.animate(withDuration: 0.9, delay: 0.8, options: [.repeat, .autoreverse, .curveEaseIn],
                       animations: {
                        self.passwordTextField.center.x += self.view.bounds.width
        },
                       completion: nil
        )
        
        UIView.animate(withDuration: 0.9, delay: 1.0, options: [.curveEaseOut],
                       animations: {
                        self.view.alpha = 1.0
        },
                       completion: nil
        )
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func initialPos() {
        header.center.x -= view.bounds.width
        userNameTextField.center.x -= view.bounds.width
        passwordTextField.center.x -= view.bounds.width
    }
}
