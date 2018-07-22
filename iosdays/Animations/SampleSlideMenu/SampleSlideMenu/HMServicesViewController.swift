//
//  HMServicesViewController.swift
//  SampleSlideMenu
//
//  Created by Bharath Nadampalli on 13/12/17.
//  Copyright © 2017 com.samples. All rights reserved.
//

import UIKit

class HMServicesViewController: UIViewController {
    @IBOutlet weak var collectionView: HMServicesCollectionView!
    var selectedPlan : PlanType = PlanType(val: 0)
    var selectedService : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.setTitleFont(HMFont.Bold.fontWithSize(20), color: "#2664AD".UIColorFromHexCode!)
        
        self.collectionView.register(UINib(nibName: "HMServiceCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: NavigationItem.Services.cellIdentifier)
        self.collectionView.mainDelegate = self
        self.collectionView.textList = NavigationItem.Services.textList
        self.collectionView.imageIconList = NavigationItem.Services.imageList
        self.collectionView.commonInit(navItem: NavigationItem.Services)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FromVCServiceDetailsSegue", let viewController : HMServiceDetailsViewController = segue.destination.childViewControllers.first as? HMServiceDetailsViewController {
            viewController.setNavTitle(text: self.selectedService)
        }
    }

}

extension HMServicesViewController : SelectedNavigation {
    func selectedNavigation (navigationItem : NavigationItem ) {
        performSegue(withIdentifier: navigationItem.segueString, sender: self)
    }
    
    func selectService (name: String) {
        self.selectedService = name
        performSegue(withIdentifier: "FromVCServiceDetailsSegue", sender: self)
    }
    
    func selectPlan(planType: PlanType) {
        self.selectedPlan = planType
        performSegue(withIdentifier: PlanDetailsSegueIdentifier, sender: self)
    }
}
