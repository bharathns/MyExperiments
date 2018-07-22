//
//  ViewController.swift
//  CommentControl
//
//  Created by Bharath Nadampalli on 02/09/17.
//  Copyright © 2017 com.samples. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var items: [Int] = []
    var commentControl : CommentControl? = nil
    lazy var setCommentControl: OnceClosure = Once.execute { [weak self] in
        
        self?.commentControl = CommentControl()
        guard let commentControl : CommentControl = self?.commentControl else {
            return
        }
        self?.view.addSubview(commentControl)
        self?.commentControl?.setUpConstraints()
        self?.view.layoutIfNeeded()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.tableFooterView = UIView()
        for i in 0 ..< 10 {
            self.items.append(i)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func ShowComment(numberOfLines: Int) {
        setCommentControl?()
        var text: String = ""
        for _ in 0 ..< numberOfLines {
            text.append("helloworld!\n")
        }
        print("\(text) : \(index)")
        self.commentControl?.expand(text: text)
    }
}

extension ViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as UITableViewCell
        cell.accessoryType = .none
        cell.textLabel?.text = "Item no \(indexPath.row)"
        return cell
    }
}

extension ViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        ShowComment(numberOfLines: indexPath.row)
    }
}

