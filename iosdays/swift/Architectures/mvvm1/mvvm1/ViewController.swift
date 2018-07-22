//
//  ViewController.swift
//  mvvm1
//
//  Created by Bharath Nadampalli on 30/07/17.
//  Copyright © 2017 com.samples. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var dataSource : DriverDataSource?  = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.dataSource = DriverDataSource(tv: self.tableView)
        self.tableView.dataSource = self.dataSource
        self.tableView.tableFooterView = UIView()
        self.navigationItem.leftBarButtonItem =  UIBarButtonItem(title: "Refresh", style: .plain, target: self, action: #selector(refresh))
    }

    override func viewWillAppear(_ animated: Bool) {
        self.dataSource?.loadNextPage(pagingType: .initial)
    }

    func refresh() {
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

