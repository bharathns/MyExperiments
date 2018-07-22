//
//  HMPlanCollectionViewCell.swift
//  SampleSlideMenu
//
//  Created by Bharath Nadampalli on 14/12/17.
//  Copyright © 2017 com.samples. All rights reserved.
//

import UIKit

class HMPlanCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var planImage: UIImageView!
    
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
