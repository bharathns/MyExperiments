//
//  Foo.swift
//  SampleFramework
//
//  Created by Bharath nadampalli on 1/17/21.
//

import UIKit

@objc
public class Foo: NSObject {
    @objc
    public func boo() {
        print("boo")
    }

    @inlinable
    @objc
    public func roo() {
        print("boo")
    }
}
