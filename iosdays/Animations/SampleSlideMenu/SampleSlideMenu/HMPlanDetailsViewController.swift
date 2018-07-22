//
//  HMPlanDetailsViewController.swift
//  SampleSlideMenu
//
//  Created by Bharath Nadampalli on 14/12/17.
//  Copyright © 2017 com.samples. All rights reserved.
//

import UIKit

class HMPlanDetailsViewController: UIViewController {

    @IBOutlet weak var planDetailImageView: UIImageView!
    var planType : PlanType = PlanType(val: 0)
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.planDetailImageView.image = UIImage(named: self.planType.detailPlanImageName)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setPlanIcon (planType : PlanType) {
        self.navigationController?.navigationBar.setTitleFont(HMFont.Bold.fontWithSize(20), color: "#2664AD".UIColorFromHexCode!)
        self.navigationController?.navigationBar.topItem?.title = planType.planName
        self.planType = planType

    }

    @IBAction func closeDetail(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
