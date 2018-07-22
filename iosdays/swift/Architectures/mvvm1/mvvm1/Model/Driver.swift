//
//  Cabinet.swift
//  mvvm1
//
//  Created by Bharath Nadampalli on 01/08/17.
//  Copyright © 2017 com.samples. All rights reserved.
//

import UIKit

class Driver: NSObject,DataType {
    required override init() {
        
    }

    init?(name: String, familyName: String) {
        self.name = name
        self.familyName = familyName
    }
    var name : String = ""
    var familyName : String = ""
}
