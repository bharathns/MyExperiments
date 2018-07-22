//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

protocol Orderable {
    var order : Int {get set}
}
class MyObject : NSObject, Orderable {
     var order : NSNumber = 0
    init(i : Int) {
        super.init()
        order = NSNumber(value: i)
    }
}
extension NSNumber {
    static func < (op1: NSNumber, op2: NSNumber) -> Bool {
        return op1.intValue < op2.intValue
    }
}

extension Sequence where Iterator.Element is  Orderable {
    func sortIt() -> [Iterator.Element] {
        return self.sorted{($0?.order)! < ($1?.order)! }
    }
}


var array : [NSNumber]  = [NSNumber] ()
array.append(NSNumber(value: 6))
array.append(NSNumber(value: 3))
array.append(NSNumber(value: 7))
array.append(NSNumber(value: 1))
array.append(NSNumber(value: 4))
array.append(NSNumber(value: 2))
array.append(NSNumber(value: 8))

array.sort { $0 < $1}
array.map { print("\($0.int32Value)")}




var arraymyobj : [MyObject?] = [MyObject?] ()

arraymyobj.append(MyObject(i: 6))
arraymyobj.append(MyObject(i: 3))
arraymyobj.append(MyObject(i: 7))
arraymyobj.append(MyObject(i: 1))
arraymyobj.append(MyObject(i: 4))
arraymyobj.append(MyObject(i: 2))
arraymyobj.append(MyObject(i: 8))

print("before sort : ..")
arraymyobj.map { print("\($0?.order.intValue)")}
print("after sort : ..")
arraymyobj.sortIt().map { print("\($0?.order.intValue)")}

//arraymyobj.sorted{($0?.order.intValue)! < ($1?.order.intValue)!}.map { print("\($0?.order.intValue)")}
//arraymyobj.map { print("\($0?.order.intValue)")}
