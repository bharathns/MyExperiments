//
//  HMServiceDetailsViewController.swift
//  SampleSlideMenu
//
//  Created by Bharath Nadampalli on 14/12/17.
//  Copyright © 2017 com.samples. All rights reserved.
//

import UIKit

class HMServiceDetailsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.setTitleFont(HMFont.Bold.fontWithSize(20), color: "#2664AD".UIColorFromHexCode!)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setNavTitle (text: String) {
        self.navigationController?.navigationBar.setTitleFont(HMFont.Bold.fontWithSize(20), color: "#2664AD".UIColorFromHexCode!)
        self.navigationController?.navigationBar.topItem?.title = text + "- Services"
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBOutlet weak var closeDetails: UIBarButtonItem!
    
    @IBAction func closeDetailsView(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}


extension HMServiceDetailsViewController {
    static func instance (_ delegate: SelectedNavigation) -> HMServiceDetailsViewController? {
        let utilityStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        let viewController = utilityStoryboard.instantiateViewController(withIdentifier: "ServicesDetailViewController") as? HMServiceDetailsViewController
        return viewController
    }
}
