//
//  HMFont.swift
//  SampleSlideMenu
//
//  Created by Bharath Nadampalli on 12/12/17.
//  Copyright © 2017 com.samples. All rights reserved.
//

import UIKit

import UIKit

enum HMFont: String {
    case Bold = "ChalkboardSE-Bold"
    case BoldItalic = "OpenSans-BoldItalic"
    case ExtraBold = "OpenSans-Extrabold"
    case ExtraBoldItalic = "OpenSans-ExtraboldItalic"
    case Italic = "OpenSans-Italic"
    case Light = "OpenSans-Light"
    case LightItalic = "OpenSansLight-Italic"
    case Regular = "ChalkboardSE-Regular"
    case Semibold = "OpenSans-Semibold"
    case SemiboldItalic = "OpenSans-SemiboldItalic"
    
    func fontWithSize(_ sizeInPoints: CGFloat) -> UIFont {
        return UIFont(name: self.rawValue, size: sizeInPoints) ?? defaultFont(withSize: sizeInPoints)
    }
    
    fileprivate func defaultFont(withSize size: CGFloat) ->  UIFont {
        let font = UIFont.systemFont(ofSize: size)
        
        var fontDescriptor: UIFontDescriptor?
        switch self {
        case .Bold, .ExtraBold, .Semibold:
            fontDescriptor = font.fontDescriptor.withSymbolicTraits([.traitBold])
        case .BoldItalic, .ExtraBoldItalic, .SemiboldItalic:
            fontDescriptor = font.fontDescriptor.withSymbolicTraits([.traitBold, .traitItalic])
        case .Italic:
            fontDescriptor = font.fontDescriptor.withSymbolicTraits([.traitItalic])
        case .Light:
            fontDescriptor = font.fontDescriptor.withSymbolicTraits([.traitCondensed])
        case .LightItalic:
            fontDescriptor = font.fontDescriptor.withSymbolicTraits([.traitCondensed, .traitItalic])
        case .Regular:
            fontDescriptor = font.fontDescriptor
        }
        
        guard let descriptor = fontDescriptor else {
            return font
        }
        
        return UIFont(descriptor: descriptor, size: 0)
    }
}


enum HMColor {
    case Title
    case Description
    case Highlight
    case ThemeBlue
    case ThemeGreen
    case TableViewSeparator
    case pickerButton
    case title
    case description
    case highlight
    case themeBlue
    case themeGreen
    case tableViewSeparator

    func color() -> UIColor {
        switch self {
        case .title:
            return UIColor.black
        case .description:
            return UIColor.darkGray
        case .highlight:
            return UIColor(red: 1.0, green: 0.98, blue: 0.753, alpha: 1.0)
        case .themeBlue:
            return UIColor(red: (0/255.0), green: (187/255.0), blue: (240/255.0), alpha: 1.0)
        case .themeGreen:
            return UIColor(red: (18/255.0), green: (205/255.0), blue: (166/255.0), alpha: 1.0)
        case .tableViewSeparator:
            return UIColor(red: 230/255.0, green: 230/255.0, blue: 230/255.0, alpha: 1.0)
        case .pickerButton:
            return UIColor(red: 1/255.0, green: 128/255.0, blue: 193/255.0, alpha: 1.0)
        default:
            return UIColor.red
        }
        
    }
}
