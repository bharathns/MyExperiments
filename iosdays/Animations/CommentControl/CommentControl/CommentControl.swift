//
//  CommentControl.swift
//  CommentControl
//
//  Created by Bharath Nadampalli on 02/09/17.
//  Copyright © 2017 com.samples. All rights reserved.
//

import UIKit

extension NSLayoutConstraint {
    func constraintWithMultiplier(_ multiplier: CGFloat) -> NSLayoutConstraint {
        
        return NSLayoutConstraint(item: self.firstItem, attribute: self.firstAttribute, relatedBy: self.relation, toItem: self.secondItem, attribute: self.secondAttribute, multiplier: multiplier, constant: self.constant)
    }
}

class CommentControl: UIView {

    var centerYConstraint : NSLayoutConstraint? =  nil
    var centerXConstraint : NSLayoutConstraint? = nil
    var widthConstraint : NSLayoutConstraint? = nil
    var heightConstraint: NSLayoutConstraint? = nil
    
    var labelWidthConstraint:    NSLayoutConstraint? = nil
    var labelHeightConstraint:   NSLayoutConstraint? = nil

    
    var label : PaddedLabel? = nil
    var button: UIButton? = nil

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }
    
    convenience init() {
        let rect = CGRect.zero
        self.init(frame: rect)
        self.layer.backgroundColor = UIColor(white: 0.0, alpha: 0.3).cgColor
 
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        guard superview != nil else {
            return
        }
    }
    
    func expand (text: String) {
        
        guard let size: CGSize  = self.getLabelSize(text), var height : CGFloat = size.height else {
            return
        }
        height  = height + (height*0.33)
        
        self.widthConstraint?.constant = (self.superview?.frame.size.width)! * 0.75
        self.labelWidthConstraint?.constant = (self.widthConstraint?.constant)! * 0.75
        self.labelHeightConstraint?.constant = height * 0.75
        self.heightConstraint?.constant = (height ) + 50.0
        self.button?.isHidden = false
        
        UIView.animate(withDuration: 0.8, delay: 0.0, usingSpringWithDamping: 0.4,
                       initialSpringVelocity: 0.0,
                       animations: {
                        
                        self.layoutIfNeeded()
                        self.updateText(text: text)
                        
        },
                       completion: nil
        )
    }
    
    func shrink() {
        self.button?.isHidden = true
        self.widthConstraint?.constant = (self.superview?.frame.size.width)! * 0.0
        self.heightConstraint?.constant = ((self.superview?.frame.size.height)! * 0.0 ) + 25
        print("\((self.widthConstraint?.constant)!) : \((self.heightConstraint?.constant)!)")
        self.labelWidthConstraint?.constant = (self.widthConstraint?.constant)! * 0.0
        self.labelHeightConstraint?.constant = (self.heightConstraint?.constant)! * 0.0
        
        UIView.animate(withDuration: 0.8, delay: 0.0, usingSpringWithDamping: 0.4,
                       initialSpringVelocity: 0.0,
                       animations: {
                        
                        self.layoutIfNeeded()
                        
                        
        },
                       completion: nil
        )
    }
    
    func setUpConstraints () {
        
        guard let superView = self.superview else {
            return
        }
        
        self.label = PaddedLabel()
        self.label?.backgroundColor = UIColor.white
        self.button = UIButton()
        self.button?.setTitle("X", for: .normal)
        self.button?.setTitleColor(UIColor.blue, for: .normal)
        self.addSubview(self.label!)
        self.addSubview(self.button!)
        
        self.layer.masksToBounds = true
        self.translatesAutoresizingMaskIntoConstraints = false
        self.label?.translatesAutoresizingMaskIntoConstraints = false
        self.button?.translatesAutoresizingMaskIntoConstraints = false
        
        self.label?.layer.masksToBounds = true
        self.label?.layer.cornerRadius = 5
        self.label?.layer.borderColor = UIColor.gray.cgColor
        self.label?.layer.borderWidth = 1.0
        self.label?.numberOfLines = 0
        self.label?.lineBreakMode = .byWordWrapping
        
        self.label?.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        self.label?.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        labelWidthConstraint = self.label?.widthAnchor.constraint(equalToConstant: self.frame.size.width * 0.05)
        labelHeightConstraint = self.label?.heightAnchor.constraint(equalToConstant: self.frame.size.height * 0.05)
        
        
        
        self.button?.centerXAnchor.constraint(equalTo: (self.centerXAnchor)).isActive = true
        self.button?.topAnchor.constraint(equalTo: (self.bottomAnchor), constant: -25).isActive = true
        self.button?.widthAnchor.constraint(equalToConstant: 20.0).isActive = true
        self.button?.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
       
        centerXConstraint = self.centerXAnchor.constraint(equalTo: superView.centerXAnchor)
        centerYConstraint = self.centerYAnchor.constraint(equalTo: superView.centerYAnchor)
        widthConstraint = self.widthAnchor.constraint(equalToConstant: ((superview?.frame.size.width)! * 0.05))
        heightConstraint =  self.heightAnchor.constraint(equalToConstant: ((superview?.frame.size.height)! * 0.05))
         print("\((self.widthConstraint?.constant)!) : \((self.heightConstraint?.constant)!)")
        NSLayoutConstraint.activate([centerXConstraint!, self.centerYConstraint!, self.widthConstraint!, self.heightConstraint!, self.labelHeightConstraint!, self.labelWidthConstraint!])
        let tap = UITapGestureRecognizer(target: self, action: #selector(CommentControl.didTapButton(_:)))
        self.button?.addGestureRecognizer(tap)

    }
    
    func updateText (text: String) {
        self.label?.text = text
    }
    
    func didTapButton(_ tap: UITapGestureRecognizer) {
        self.shrink()
    }
    
    func prototypeLabel(_ stringValue: String) -> UILabel {
        
        let label  = UILabel()
        label.numberOfLines = 0
        label.text =  stringValue
        return label
    }
    

    func getLabelSize(_ property: String) -> CGSize {
        let frameWidth = (self.superview?.frame.size.width)! * 0.75
        let value : String = property
        let label  = self.prototypeLabel(value)
        let cellRect = label.textRect(forBounds: CGRect(x: 0,y: 0,width: frameWidth,height: CGFloat.greatestFiniteMagnitude), limitedToNumberOfLines: 0)
        
        return CGSize(width: cellRect.width, height: cellRect.height + 10)
        
    }
}
