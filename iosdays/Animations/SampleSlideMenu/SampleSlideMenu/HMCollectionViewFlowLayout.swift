//
//  HMCollectionViewFlowLayout.swift
//  SampleSlideMenu
//
//  Created by Bharath Nadampalli on 15/12/17.
//  Copyright © 2017 com.samples. All rights reserved.
//

import UIKit


class HMCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    var grid : HMImageCollectionView? = nil
    
    var imageList : [String] = [String]()
    
    typealias CellInformationType = [IndexPath: UICollectionViewLayoutAttributes]
    
    var layoutInformation = [String:CellInformationType]()
    
    var totalWidth:CGFloat = 0
    var extraSpace:CGFloat = 0
    override init() {
        super.init()
        setupLayout()
    }
    
    init(grid: HMImageCollectionView, imageList: [String]) {
        super.init()
        setupLayout()
        if case self = self {
            self.grid = grid
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLayout()
    }
    
    func setupLayout() {
        minimumInteritemSpacing = 1
        scrollDirection = .horizontal
    }
    
    override func prepare() {
        super.prepare()
        
        var cellInformation = CellInformationType()
        
        if let grid:UICollectionView = self.grid{
            let noOfSections:Int = grid.numberOfSections
            for sectionIndex in 0..<noOfSections {
                let noOfItems:Int = grid.numberOfItems(inSection: sectionIndex)
                if noOfItems > 0 {
                    for itemIndex in 0..<noOfItems {
                        cellInformation[IndexPath(item: itemIndex, section: sectionIndex)] = super.layoutAttributesForItem(at: IndexPath(item: itemIndex, section: sectionIndex))
                    }
                }
            }
        }
        
        layoutInformation["Properties"] = cellInformation
        
        
        if let grid:HMImageCollectionView = self.grid {
            let noOfSections:Int = grid.numberOfSections
            for sectionIndex in 0..<noOfSections {
                let noOfItems:Int = grid.numberOfItems(inSection: sectionIndex)
                if noOfItems > 0 {
                    for itemIndex in 0..<noOfItems {
                        let indexPath = IndexPath(item: itemIndex, section: sectionIndex)
                        if let attributes = cellInformation[indexPath] {
                            let frame = grid.getCellFrameAtIndexPath(indexPath)
                            totalWidth += frame.width
                            attributes.frame = frame
                        }
                    }
                }
            }
        }
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if let cellInfoAttribute = self.layoutInformation["Properties"]{
            return cellInfoAttribute[indexPath]
        }
        return nil
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var mutableAttributes =  [UICollectionViewLayoutAttributes]()
        
        for ( _, cellAttributes) in self.layoutInformation {
            for (_, indexAttributes) in cellAttributes {
                if rect.intersects(indexAttributes.frame) {
                    mutableAttributes.append(indexAttributes)
                }
            }
        }
        return mutableAttributes
    }
    
    override var collectionViewContentSize : CGSize {
        guard let grid = self.grid else {
            return CGSize.zero
        }
        return CGSize(width: totalWidth+extraSpace, height: grid.frame.height)
    }
}

