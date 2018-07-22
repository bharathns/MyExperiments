//
//  ImageTransistionViewController.swift
//  UIViewRotationAnimation
//
//  Created by Bharath Nadampalli on 28/02/17.
//  Copyright © 2017 EMC. All rights reserved.
//

import UIKit

class ImageTransistionViewController: UIViewController,UIGestureRecognizerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    var toggle: Bool  = true
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let tapGesture:UITapGestureRecognizer = UITapGestureRecognizer(target:self, action: #selector(ImageTransistionViewController.handleTap)) as! UITapGestureRecognizer
        self.imageView.addGestureRecognizer(tapGesture)
        tapGesture.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
       
    }
    
    func handleTap(sender: UITapGestureRecognizer? = nil) {
        // handling code
        let imageName = toggle ? "bg-image2" : "bluebackgroundimage"
        if let image = UIImage(named: imageName){
            self.fade(imageView: self.imageView, image: image)
            toggle = toggle ? false : true
        }
    }
    
    func fade(imageView: UIImageView, image: UIImage){
        
       
        UIView.transition(with: imageView, duration: 1.0, options: [.transitionCrossDissolve], animations: {
            imageView.image = image
        }, completion: nil)

    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
