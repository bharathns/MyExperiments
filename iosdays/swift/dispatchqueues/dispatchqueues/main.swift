//
//  main.swift
//  dispatchqueues
//
//  Created by Bharath Nadampalli on 25/01/18.
//  Copyright © 2018 Bharath Nadampalli. All rights reserved.
//

import Foundation

print("Hello, World!")

//  Definition for singly-linked list.
  public class ListNode {
      public var val: Int
      public var next: ListNode?
      public init(_ val: Int) {
          self.val = val
          self.next = nil
      }
  }

class Solution {
    func myAtoi(_ str: String) -> Int {
        let digits = CharacterSet.decimalDigits
        let signed  =  str.contains("-") ? true : false
        let convStr = str.replacingOccurrences(of: "-", with: "", options: NSString.CompareOptions.literal, range: nil)
        var ans : UInt32? = 0
        for (index, char) in convStr.unicodeScalars.enumerated() {
            if digits.contains(char) {
                if let value : UInt32 = char.value, let actVal : UInt32? = (value - 48) as? UInt32 {
                    ans = ans! * 10 + actVal!
                }
            }
        }
        let myans : Int = Int(UInt32(ans!)) * (signed == true ? -1 : 1)
        return myans
        
    }
}

func printApples(){

    print("PrintApples ThreadName = \(String(describing: Thread.current ))")
    for i in 0..<3{
        print("🍏\(i)")
    }
}


func printStrawberries(){
    print("PrintStrawberries ThreadName = \(String(describing: Thread.current ))")
    for i in 0..<3{
        print("🍓\(i)")
    }
}

func printBalls(){
    print("PrintBalls ThreadName = \(String(describing: Thread.current ))")
    for i in 0..<3{
        print("🎱\(i)")
    }
}

func printCopyWrite(){
    
    print("PrintCopyWrite ThreadName = \(String(describing: Thread.current ))")
    for i in 0..<3{
        print("© \(i)")
    }
}

func testPrintMethods(){
    printApples()
    printStrawberries()
    printBalls()
}
//testPrintMethods() // all functions execute in main thread one after the other

func queueTest1(){
    let queue1 = DispatchQueue(label: "queue1")

    
    queue1.async {
        printApples()
    }
    queue1.async {
        printStrawberries()
    }
    queue1.async {
        printBalls()
    }
}
//queueTest1() // there the queue is serial the tasks are executed one by one.

func queueTest2(){
    let queue1 = DispatchQueue(label: "queue1")
    let queue2 = DispatchQueue(label: "queue2")
    let queue3 = DispatchQueue(label: "queue3")
    
    queue1.async {
   
        printApples()
    }

    queue2.async {
        printStrawberries()
    }
    queue3.async {
        printBalls()
    }
}
//queueTest2() // Three queues are created each having working on a thread

func globalQueueTest3() {
    let queue1 = DispatchQueue.global(qos: DispatchQoS.QoSClass.userInteractive)
    queue1.async {
        printApples()
    }
    
    queue1.async {
        printStrawberries()
    }
    queue1.async {
        printBalls()
    }
}
//globalQueueTest3() // creates 3 threads


func globalQueueTest4() {
    let queue1 = DispatchQueue.global(qos: .background)
    
    
    queue1.async {
        printStrawberries()
    }
    queue1.async {
        printBalls()
    }
    queue1.async {
        printBalls()
    }
    queue1.async {
        printCopyWrite()
    }
    queue1.sync {
        printApples()
    }
}
globalQueueTest4()
