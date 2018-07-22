//
//  PaddedLabel.swift
//  CommentControl
//
//  Created by Bharath Nadampalli on 03/09/17.
//  Copyright © 2017 com.samples. All rights reserved.
//

import UIKit

class PaddedLabel: UILabel {
    
    fileprivate let kPaddedLabelBorderWidth: CGFloat = 0.7
    
    fileprivate let kPaddedLabelCornerRadius: CGFloat = 4.0
    
    fileprivate let kPaddedLabelBorderColorHex = "#ADADAD"
    
    var showBorder = true
    
    var padding : CGFloat = 10.0{
        didSet {
            topPadding = padding
            bottomPadding = padding
            leftPadding = padding
            rightPadding = padding
        }
    }
    
    /*
     // Only override drawRect: if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func drawRect(rect: CGRect) {
     // Drawing code
     }
     */
    var topPadding = CGFloat(10.0), bottomPadding = CGFloat(10.0), leftPadding = CGFloat(10.0), rightPadding = CGFloat(10.0)
    
    override func drawText(in rect: CGRect) {
        self.layer.borderWidth = showBorder ? kPaddedLabelBorderWidth : 0
        self.layer.borderColor = kPaddedLabelBorderColorHex.UIColorFromHexCode?.withAlphaComponent(0.2).cgColor
        self.layer.cornerRadius = kPaddedLabelCornerRadius
        let padding: UIEdgeInsets = UIEdgeInsets(top: topPadding, left: leftPadding, bottom: bottomPadding, right: rightPadding)
        super.drawText(in: UIEdgeInsetsInsetRect(rect, padding))
    }
    
    override var intrinsicContentSize : CGSize {
        var intrinsicSuperViewContentSize = super.intrinsicContentSize
        intrinsicSuperViewContentSize.height += topPadding + bottomPadding
        intrinsicSuperViewContentSize.width += leftPadding + topPadding
        return intrinsicSuperViewContentSize
    }
    
    override var attributedText: NSAttributedString? {
        willSet {
            self.isHidden = (newValue?.length == 0)
        }
    }
    
    override var text: String? {
        willSet {
            self.isHidden = (newValue?.characters.count == 0)
        }
    }
}
