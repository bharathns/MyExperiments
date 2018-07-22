//
//  HMLeftNavCellTableViewCell.swift
//  SampleSlideMenu
//
//  Created by Bharath Nadampalli on 13/12/17.
//  Copyright © 2017 com.samples. All rights reserved.
//

import UIKit

class HMLeftNavCellTableViewCell: UITableViewCell {
  
    @IBOutlet weak var leftImageView: UIImageView!
    @IBOutlet weak var leftLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.preservesSuperviewLayoutMargins = false
        self.separatorInset = UIEdgeInsets.zero
        self.layoutMargins = UIEdgeInsets.zero
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
