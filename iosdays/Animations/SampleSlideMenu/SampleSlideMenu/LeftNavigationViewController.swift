//
//  LeftNavigationViewController.swift
//  SampleSlideMenu
//
//  Created by Bharath Nadampalli on 12/12/17.
//  Copyright © 2017 com.samples. All rights reserved.
//

import UIKit

let kLeftNavIdentifier = "LeftNavCell"
private let kLeftNavTableViewCellHeight: CGFloat = 40

enum NavigationItem {
    case Services
    case Plans
    case ContactUs
    init(val: Int) {
        switch val {
        case 0:
            self = .Services
        case 1:
            self = .Plans
        default:
            self = .ContactUs
        }
    }
    
    var segueString: String {
        switch self {
        case .Services:
            return "ServicesSegue"
        case .Plans:
             return "PlansSegue"
        default:
            return "ContactUsSegue"
        }
    }
    
    var collectionViewSize: CGSize {
        switch self {
        case .Services:
            return CGSize(width: 150, height: 150)
        case .Plans:
            return CGSize(width: 75, height: 75)
        default:
            return CGSize(width: 1, height: 1)
        }
    }
    
    var spacing: Int {
        switch self {
        case .Services:
            return 5
        case .Plans:
            return 10
        default:
            return 1
        }
    }
    
    var imageList: [String]? {
        switch self {
        case .Services:
            return ["appliancerepair", "architectural", "cleaning", "electrical", "interior", "mason", "mes", "painting", "pestcontrol", "plumbing", "property-mgnt","property-service", "purifier", "sofa", "watertank"]
        case .Plans:
            return ["plan-blue", "plan-silver", "plan-gold", "plan-platinum"]
        default:
            return nil
        }
    }
    
    var textList: [String]? {
        switch self {
        case .Services:
            return ["Appliance Repair", "Architectural Design Consultation", "HouseCleaning", "Electrical Work", "Interior Design Consultation", "Civil & Interior", "MEP Design Consultation", "Painting", "Pest Control", "Plumbing Work", "Property Management","Property Services", "RO & Purifiers", "Furniture Maintenance", "Water Tank Cleaning"]
        case .Plans:
            return ["Blue", "Silver", "Gold", "Platinum"]
        default:
            return nil
        }
    }
    
    var cellIdentifier: String {
        switch self {
        case .Services:
            return "ServicesCellIdentifer"
        case .Plans:
            return "PlansCellIdentifer"
        default:
            return ""
        }
    }
}

class LeftNavigationViewController: UIViewController {

    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var emailId: UILabel!
    
    @IBOutlet weak var profileImageView: UIImageView!
    let leftNavText: [String] = ["Services", "Plans", "Contact Us"]
    let leftNavIcons: [String] = ["services", "subscription", "contactus"]
    
    @IBOutlet weak var tableView: UITableView!
    
    var mainViewController : SelectedNavigation? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.accessibilityIdentifier = kLeftNavIdentifier
        self.userName.font = HMFont.BoldItalic.fontWithSize(12)
        self.userName.textColor = UIColor.white
        self.userName.text = "Mahesh Katti"
        
        self.emailId.font = HMFont.Light.fontWithSize(10)
        self.emailId.textColor = UIColor.white
        self.emailId.text = "maheshk@gmail.com"
        
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2
        self.profileImageView.clipsToBounds = true
        self.profileImageView.layer.borderWidth = 3.0
        self.profileImageView.layer.borderColor = UIColor.white.cgColor
        
        let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(onLeftNavTap))
        doubleTapRecognizer.numberOfTapsRequired = 1
        doubleTapRecognizer.delegate = self
        self.view.addGestureRecognizer(doubleTapRecognizer)
        
        // Register the table view cell class and its reuse id
        //self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: kLeftNavIdentifier)
        
        // This view controller itself will provide the delegate methods and row data for the table view.
        tableView.delegate = self
        tableView.dataSource = self
        
        self.tableView.backgroundColor = "#2664AD".UIColorFromHexCode
        self.tableView.tableFooterView = UIView()
        self.tableView.estimatedRowHeight = kLeftNavTableViewCellHeight
        
        self.tableView.separatorStyle = .none
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc func onLeftNavTap(sender: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
}

extension LeftNavigationViewController : UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view?.accessibilityIdentifier != kLeftNavIdentifier {
            return false
        }
        return true
    }
}

extension LeftNavigationViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
        guard let navItem : NavigationItem  = NavigationItem(val : indexPath.row) else {
            return
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
             self.mainViewController?.selectedNavigation(navigationItem: navItem)
        }
        dismiss(animated: true, completion: nil)
        //performSegue(withIdentifier: navItem.segueString, sender: self.mainViewController)
    }
}

extension LeftNavigationViewController : UITableViewDataSource {
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.leftNavText.count
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // create a new cell if needed or reuse an old one
        guard  let cell = self.tableView.dequeueReusableCell(withIdentifier: kLeftNavIdentifier) as? HMLeftNavCellTableViewCell else {
            return UITableViewCell()
        }

        // set the text from the data model
        cell.leftLabel.text = leftNavText[indexPath.row]
        cell.leftImageView.image = UIImage(named: leftNavIcons[indexPath.row])
        cell.leftImageView.tintColor = UIColor.white
        cell.selectionStyle = .none;
        cell.backgroundColor = "#2664AD".UIColorFromHexCode

        return cell
    }
}

