//
//  main.swift
//  OperationQueues
//
//  Created by Bharath Nadampalli on 21/07/17.
//  Copyright © 2017 bharath.com. All rights reserved.
//

import Foundation


class task: Foundation.Operation {

    override func main() {
        print("main")
        if isCancelled {
            return
        }
    }

    override func start() {
        
        for i in 0..<3{
            print("🍏\(i)")
        }
        print("start : \(Thread.current.isMainThread)")
        guard let completionBlock = self.completionBlock else  {
            return
        
        }
        completionBlock()
    }

    override func cancel() {
        
    }
}


class NonConcurrent: Operation {
    
    override func main() {
        print("main")
        if isCancelled {
            return
        }
    }
    
}
let noncon = NonConcurrent()
let taskobj: task = task()

let taskobj1: task = task()
taskobj.completionBlock = { () -> () in
    print("task completed")
}
let queue = OperationQueue()
queue.name = "expt"
queue.maxConcurrentOperationCount = 2
/*queue.addOperation {
    print("starting operation...")
}*/
noncon.main()
queue.addOperation(taskobj)
queue.addOperation(taskobj1)
//taskobj.start() // completion block doesn't get called
sleep(10)
print("Hello, World!")

