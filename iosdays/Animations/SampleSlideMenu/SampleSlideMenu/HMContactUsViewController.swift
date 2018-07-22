//
//  HMContactUsViewController.swift
//  SampleSlideMenu
//
//  Created by Bharath Nadampalli on 13/12/17.
//  Copyright © 2017 com.samples. All rights reserved.
//

import UIKit

class HMContactUsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.setTitleFont(HMFont.Bold.fontWithSize(20), color: "#2664AD".UIColorFromHexCode!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func backHome(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
