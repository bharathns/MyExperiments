//
//  ViewController.swift
//  ConstrainedAnimation
//
//  Created by Bharath Nadampalli on 02/09/17.
//  Copyright © 2017 com.samples. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var menuHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var horizontalPickList: HorizontalPickList? = nil
    var items : [Int] = []
    var isMenuExpanded: Bool = false {
        willSet {
            self.menuHeightConstraint.constant  = newValue ? 200.0 : 60.0
            self.titleLabel.text = newValue ? "Select Item" : "Shopping List"
            if newValue {
                self.horizontalPickList = HorizontalPickList(inView: self.view)
                self.horizontalPickList?.didSelectItem = {index in
                    print("add \(index)")
                    self.items.append(index)
                    self.tableView.reloadData()
                }
                self.titleLabel.superview?.addSubview(self.horizontalPickList!)
            }else {
                self.horizontalPickList?.removeFromSuperview()
                self.horizontalPickList = nil
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView?.rowHeight = 54.0

        self.tableView.tableFooterView = UIView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func selectItem(_ sender: Any) {
        self.isMenuExpanded = !self.isMenuExpanded
        UIView.animate(withDuration: 1.0, delay: 0.0,
                       usingSpringWithDamping: 0.4, initialSpringVelocity: 10.0,
                       options: .curveEaseIn,
                       animations: {
                        self.view.layoutIfNeeded()
        },
                       completion: nil
        )
    }

    func showItem(index: Int) {
        let imageView = UIImageView(image: UIImage(named: "shoppingitem(\(index)).png"))
        imageView.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.2)
        imageView.layer.cornerRadius = 5.0
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        let conX = imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        let conBottom = imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: imageView.frame.height)
        
        let conWidth = imageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.33, constant: -50.0)
        let conHeight = imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
        
        NSLayoutConstraint.activate([conX, conBottom, conWidth, conHeight])
        view.layoutIfNeeded()
        self.view.isUserInteractionEnabled = false
        
        UIView.animate(withDuration: 0.8, delay: 0.0, usingSpringWithDamping: 0.4,
                       initialSpringVelocity: 0.0,
                       animations: {
                        conBottom.constant = -imageView.frame.size.height/2
                        conWidth.constant = 0.0
                        self.view.layoutIfNeeded()
        },
                       completion: nil
        )
        
        UIView.animate(withDuration: 0.8, delay: 1.0, usingSpringWithDamping: 0.4,
                       initialSpringVelocity: 0.0,
                       animations: {
                        conBottom.constant = imageView.frame.size.height
                        conWidth.constant = -50.0
                        self.view.layoutIfNeeded()
        },
                       completion: {_ in
                        imageView.removeFromSuperview()
                        self.view.isUserInteractionEnabled = true
        }
        )
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
   
    
    // MARK: Table View methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as UITableViewCell
        cell.accessoryType = .none
        cell.textLabel?.text = "Item no \(indexPath.row)"
        cell.imageView?.image = UIImage(named: "shoppingitem(\(items[indexPath.row])).png")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        showItem(index: items[indexPath.row])
    }
    
}
