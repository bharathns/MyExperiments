//
//  CustomTableViewCell.swift
//  mvvm1
//
//  Created by Bharath Nadampalli on 31/07/17.
//  Copyright © 2017 com.samples. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func fillCell(driver: DataType){
        if let driver : Driver = driver as? Driver {
            self.label?.text  = String(driver.name+" , ")?.appending(driver.familyName)
        }
    }
}
