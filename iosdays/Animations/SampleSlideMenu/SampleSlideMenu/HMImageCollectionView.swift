//
//  HMImageCollectionView.swift
//  SampleSlideMenu
//
//  Created by Bharath Nadampalli on 13/12/17.
//  Copyright © 2017 com.samples. All rights reserved.
//

import UIKit


class HMImageCollectionView: UICollectionView {

    var imageIconList: [String]? = nil
    var textList : [String]? = nil
    var navigationItem : NavigationItem = NavigationItem(val: 0)
    var mainDelegate : SelectedNavigation? = nil
    func commonInit (navItem : NavigationItem) {
        self.dataSource = self
        self.delegate = self
        self.navigationItem = navItem
        let flowLayout: HMCollectionViewFlowLayout  = HMCollectionViewFlowLayout(grid: self, imageList: self.navigationItem.imageList!)
        flowLayout.extraSpace = navItem == NavigationItem.Services ? 70 : 0
        self.collectionViewLayout = flowLayout

        self.showsHorizontalScrollIndicator = false
        self.reloadData()
    }
    
    func getCellFrameAtIndexPath(_ indexPath: IndexPath)-> CGRect {
        
        var cellFrame = CGRect.zero
        let x  = (indexPath.row) == 0 ? 0 : indexPath.row * Int(self.navigationItem.collectionViewSize.width) + (indexPath.row * self.navigationItem.spacing)
        let y:Int  = 0
        cellFrame  = CGRect(x: x, y: y, width: Int(self.navigationItem.collectionViewSize.width), height: Int(self.navigationItem.collectionViewSize.height))
        return cellFrame
    }
}



extension HMImageCollectionView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let list = self.imageIconList else  {
            return 0
        }
        let count : Int = list.count
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if navigationItem == NavigationItem.Services {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.navigationItem.cellIdentifier, for: indexPath) as? HMServiceCollectionViewCell, let imageName = self.imageIconList?[indexPath.row], let heading  = self.textList?[indexPath.row] else {
                return UICollectionViewCell()
            }
            
            // Configure the cell
            cell.serviceHeading.text = heading
            cell.serviceHeading.numberOfLines = 0
            cell.serviceHeading.lineBreakMode = .byWordWrapping
            cell.serviceIcon.image = UIImage(named: imageName)
            cell.serviceHeading.font  = HMFont.Regular.fontWithSize(10)
            
            cell.layer.borderColor = "106DC7".UIColorFromHexCode?.cgColor
            cell.layer.borderWidth = 1.0
            cell.layer.cornerRadius = 10
            
            cell.layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
            cell.layer.shadowRadius = 1.0
            cell.layer.shadowOpacity = 0.5
            cell.layer.opacity = 0
//            cell.contentView.layer.cornerRadius = 10
//            cell.contentView.layer.borderWidth = 1.0
//
//            cell.contentView.layer.borderColor = "106DC7".UIColorFromHexCode?.cgColor
//            cell.contentView.layer.masksToBounds = true
//
//            cell.layer.shadowColor = "#EEEEEE".UIColorFromHexCode?.cgColor
//            cell.layer.shadowOffset = CGSize(width: 2.0, height: 3.0)
//            cell.layer.shadowRadius = 10.0
//            cell.layer.shadowOpacity = 1.0
//            cell.layer.masksToBounds = false
//            cell.layer.shadowPath = UIBezierPath(roundedRect:cell.bounds, cornerRadius:cell.contentView.layer.cornerRadius).cgPath
            return cell
        }else if navigationItem == NavigationItem.Plans  {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.navigationItem.cellIdentifier, for: indexPath) as? HMPlanCollectionViewCell, let imageName = self.imageIconList?[indexPath.row] else {
                return UICollectionViewCell()
            }
            cell.planImage.image =  UIImage(named: imageName)
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.navigationItem == .Services {
            if collectionView.cellForItem(at: indexPath) as? HMServiceCollectionViewCell != nil, let text : String  = self.textList?[indexPath.row] {
                self.mainDelegate?.selectService(name: text)
            }
        }else  {
            if collectionView.cellForItem(at: indexPath) as? HMPlanCollectionViewCell != nil {
                self.mainDelegate?.selectPlan(planType: PlanType(val: indexPath.row))
            }
        }
    }


     func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.2) {
             if self.navigationItem == .Services {
                if let cell = collectionView.cellForItem(at: indexPath) as? HMServiceCollectionViewCell {
                    cell.serviceIcon.transform = .init(scaleX: 0.95, y: 0.95)
                    cell.contentView.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
                }
             }else {
                if let cell = collectionView.cellForItem(at: indexPath) as? HMPlanCollectionViewCell {
                    cell.planImage.transform = .init(scaleX: 0.95, y: 0.95)
                }
            }
        }
    }
    
     func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.2) {
            if self.navigationItem == .Services {
                if let cell = collectionView.cellForItem(at: indexPath) as? HMServiceCollectionViewCell {
                    cell.serviceIcon.transform = .identity
                    cell.contentView.backgroundColor = .clear
                }
            }else {
                if let cell = collectionView.cellForItem(at: indexPath) as? HMPlanCollectionViewCell {
                    cell.planImage.transform = .identity
                    cell.contentView.backgroundColor = .clear
                }
            }
        }
    }
}
