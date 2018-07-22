//
//  ViewController.swift
//  LayersAndMasks
//
//  Created by Bharath Nadampalli on 05/09/17.
//  Copyright © 2017 com.samples. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var userProfileView: UserAvatarView!
    
    @IBOutlet weak var animateButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.didTapOnImageView(_:)))
        self.view.addGestureRecognizer(tapGesture)
        
        //self.userProfileView.layer.borderWidth = 1.0
        //self.userProfileView.layer.cornerRadius = 5.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func didTapOnImageView(_ sender: UITapGestureRecognizer) {
        self.userProfileView.setImage(imageName: "Kangana_tb.jpg")
    }

    @IBAction func startTheGame(_ sender: Any) {
        self.userProfileView.animateLayer()
        //self.animateButton.layer.setVa
        //self.animateButton.layer.backgroundColor = UIColor.brown.cgColor
//       UIView.animateKeyframes(withDuration: <#T##TimeInterval#>, delay: <#T##TimeInterval#>, options: UIViewKeyframeAnimationOptions, animations: <#T##() -> Void#>, completion: <#T##((Bool) -> Void)?##((Bool) -> Void)?##(Bool) -> Void#>)
    }

}

