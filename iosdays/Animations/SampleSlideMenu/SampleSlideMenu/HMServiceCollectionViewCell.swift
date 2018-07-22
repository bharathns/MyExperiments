//
//  HMServiceCollectionViewCell.swift
//  SampleSlideMenu
//
//  Created by Bharath Nadampalli on 14/12/17.
//  Copyright © 2017 com.samples. All rights reserved.
//

import UIKit

class HMServiceCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var serviceIcon: UIImageView!
    @IBOutlet weak var serviceHeading: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.autoresizingMask = .flexibleWidth
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
