//
//  ViewController.swift
//  SampleSlideMenu
//
//  Created by Bharath Nadampalli on 12/12/17.
//  Copyright © 2017 com.samples. All rights reserved.
//

import UIKit
let SlideMenuSegueIdentifier = "presentNav"
let ServiceDetailsSegueIdentifier = "ServiceDetailsSegue"
let PlanDetailsSegueIdentifier = "PlanDetailsSegue"

enum PlanType {
    case Blue
    case Silver
    case Gold
    case Platinum
    init(val: Int) {
        switch val {
        case 0:
            self = .Blue
        case 1:
            self = .Silver
        case 2:
            self = .Gold
        default:
            self = .Platinum
        }
    }
    
    var detailPlanImageName : String {
        switch self {
        case .Blue:
            return "blue-detail"
        case .Silver:
            return "silver-detail"
        case .Gold:
            return "gold-detail"
        default:
            return "platinum-detail"
        }
    }
    
    var planName : String {
        switch self {
        case .Blue:
            return "Blue - Plan"
        case .Silver:
            return "Silver - Plan"
        case .Gold:
            return "Gold - Plan"
        default:
            return "Platinum - Plan"
        }
    }
}

protocol SelectedNavigation {
    func selectedNavigation (navigationItem : NavigationItem )
    func selectService (name: String)
    func selectPlan(planType: PlanType)
}

class ViewController: UIViewController {
    var transitionDelegate : SlideMenuAnimator = SlideMenuAnimator()
    
    @IBOutlet weak var servicesCollectionView: HMImageCollectionView!
    
    @IBOutlet weak var plansCollectionView: HMImageCollectionView!
    @IBOutlet weak var servicesLabel: UILabel!
    @IBOutlet weak var plansLabel: UILabel!
    var selectedService : String = ""
    var selectedPlan : PlanType = PlanType(val:0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationController?.navigationBar.setTitleFont(HMFont.Bold.fontWithSize(20), color: "#2664AD".UIColorFromHexCode!)
        
        self.servicesCollectionView.register(UINib(nibName: "HMServiceCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: NavigationItem.Services.cellIdentifier)
        self.servicesCollectionView.mainDelegate = self
        self.servicesCollectionView.textList = NavigationItem.Services.textList
        self.servicesCollectionView.imageIconList = NavigationItem.Services.imageList
        self.servicesCollectionView.commonInit(navItem: NavigationItem.Services)
        
        self.plansCollectionView.register(UINib(nibName: "HMPlanCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: NavigationItem.Plans.cellIdentifier)
        self.plansCollectionView.mainDelegate = self
        self.plansCollectionView.textList = NavigationItem.Plans.textList
        self.plansCollectionView.imageIconList = NavigationItem.Plans.imageList
        self.plansCollectionView.commonInit(navItem: NavigationItem.Plans)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func pressedMenu(_ sender: Any) {
        performSegue(withIdentifier: "presentNav", sender: self)
    }
    
    @IBAction func pressLeftMenu(_ sender: Any) {
        performSegue(withIdentifier: "presentNav", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SlideMenuSegueIdentifier, let viewController: LeftNavigationViewController = segue.destination as? LeftNavigationViewController {
            viewController.transitioningDelegate = transitionDelegate
            viewController.mainViewController = self
            viewController.modalPresentationStyle = .custom
        } else if segue.identifier == ServiceDetailsSegueIdentifier, let viewController : HMServiceDetailsViewController = segue.destination.childViewControllers.first as? HMServiceDetailsViewController {
            viewController.setNavTitle(text: self.selectedService)
        } else if segue.identifier == PlanDetailsSegueIdentifier, let viewController : HMPlanDetailsViewController = segue.destination.childViewControllers.first as? HMPlanDetailsViewController {
            viewController.setPlanIcon(planType: self.selectedPlan)
        }
    }
}

extension  ViewController : SelectedNavigation {
    func selectedNavigation (navigationItem : NavigationItem ) {
        performSegue(withIdentifier: navigationItem.segueString, sender: self)
    }
    
    func selectService (name: String) {
        self.selectedService = name
        performSegue(withIdentifier: ServiceDetailsSegueIdentifier, sender: self)
    }
    
    func selectPlan(planType: PlanType) {
        self.selectedPlan = planType
        performSegue(withIdentifier: PlanDetailsSegueIdentifier, sender: self)
    }
}


