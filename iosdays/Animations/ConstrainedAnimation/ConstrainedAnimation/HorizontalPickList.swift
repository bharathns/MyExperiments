//
//  HorizontalPickList.swift
//  ConstrainedAnimation
//
//  Created by Bharath Nadampalli on 02/09/17.
//  Copyright © 2017 com.samples. All rights reserved.
//

import UIKit

class HorizontalPickList: UIScrollView {

    var didSelectItem: ((_ index: Int)->())?
    
    let buttonWidth: CGFloat = 60.0
    let padding: CGFloat = 10.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(inView : UIView) {
        let rect = CGRect(x: inView.bounds.width, y: 120.0, width: inView.frame.width, height: 80.0)
        self.init(frame: rect)
        
        alpha = 0.0
        
        for i in 0 ..< 3 {
            print("image\(i)")
            let image = UIImage(named: "shoppingitem(\(i)).png")
            let imageView  = UIImageView(image: image)
            imageView.center = CGPoint(x: CGFloat(i) * buttonWidth + buttonWidth/2, y: buttonWidth/2)
            imageView.tag = i
            imageView.isUserInteractionEnabled = true
            addSubview(imageView)
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(HorizontalPickList.didTapImage(_:)))
            imageView.addGestureRecognizer(tap)
        }
        
        contentSize = CGSize(width: padding * buttonWidth, height:  buttonWidth + 2*padding)
    }
    
    func didTapImage(_ tap: UITapGestureRecognizer) {
        didSelectItem?(tap.view!.tag)
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        guard superview != nil else {
            return
        }
        
        UIView.animate(withDuration: 1.0, delay: 0.01, usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 10.0, options: .curveEaseIn,
                       animations: {
                        self.alpha = 1.0
                        self.center.x -= self.frame.size.width
        },
                       completion: nil
        )
    }
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    

}
