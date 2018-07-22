//
//  main.swift
//  AsyncCallinInit
//
//  Created by Bharath Nadampalli on 19/07/17.
//  Copyright © 2017 EMC. All rights reserved.
//

import Foundation



let apiQueueName = "com.networkmanager.queue.api"
let apiQueue = DispatchQueue(label: apiQueueName, attributes: DispatchQueue.Attributes.concurrent)

class Foo: NSObject {
    
    init(request: Int, queue: DispatchQueue? = nil) {
        super.init()

        if let queue = queue {
            queue.async { [weak self] in
                self?.request(request)
            }
        }
        else {
            self.request(request)
        }
    }
    
    fileprivate func request(_ request: Int)  {
         print("in request \(request)")
    }
}


let foo: Foo = Foo(request: 10, queue: apiQueue)

print("Hello, World!")
