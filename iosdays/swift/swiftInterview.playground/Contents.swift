import UIKit

var str = "Hello, playground"



for i in stride(from: 10, through: 0, by: -1) {
    print(i)
}

class BaseView {
    var view = "" {
        didSet {
            print("Base \(view)")
        }
    }
    
}

class ChildView: BaseView {
    override var view : String {
        didSet {
            print("Child \(view)")
        }
    }
    
}

let viewC = ChildView()

viewC.view = "test"

viewC.view = "test1"

func dosomething() {
    defer {print("a") }
    defer {print("b") }
    defer {print("c") }
    print("d")
}

dosomething()

func addition(y a: ()->()) {
    func y() {
        print("y")
    }
    y()
}

addition {
    print("x")
}

var dict: [String: Int?] = [
    "one": 1,
    "two": 2,
    "none": nil
]
print("--------")
var dicts = dict
print(dict.count)
dict["two"] = nil
dict["none"] = nil
print(dict.count)
print(dicts.count)


var count = 0
var book = { () -> String in
    count += 1
   return "string"
}()
func add(completion: @autoclosure ()-> String)-> Int {
    defer {
        count += 1
    }
    return count
}

print (add(completion: book), count)
print(UInt.min)

struct A {
    static var xa = "Advanced"
    
    var xb: String {
        didSet {
            A.xa = oldValue
        }
    }
}

var aobj = A(xb: "hello")

print(A.xa)
aobj.xb = "test"
print(A.xa)
var bobj = A(xb: "hellodsdd")
print(A.xa)

func mean(numbers: Double)->(min: Int?,max: Int?)? {
    return (1,1)
}

print(MemoryLayout<Int>.size)
var x: Int? = nil
x? = 9

func counter()->(Int)->String {
    var total = 5
    func add (x: Int)->String {
        total += x + 1
        return ("\(total)")
    }
    
    return add
}

let f = counter()
f(3)

let g = counter()
g(2)

print(f(4))

var animals = ["a","b","c"]
animals.sort(by: <)

enum foo : RawRepresentable {
    
    case one
    case two
    init?(rawValue: RawValue) {
        self = .one
    }
    var rawValue: Int {
        return 1
    }
}

print(foo.one == foo.two)
switch foo.two {
case .one: print("1")
case .two: print("2")
}

class JR {
    func show() {
        print("jr")
    }
}

struct SR {
    var ref = JR()
    
    mutating func change()->String {
        ref.show()
        return isKnownUniquelyReferenced(&ref) ? "no copy" :"copy"
    }
    
    
}

let x2 = SR()
var array = [x2]
print(array[0].change(), array[0].ref.show())

func swap(a: inout Int, b: inout Int) {
    let temp = a
    a = b
    b = temp
    
}

var a = 10
var b = 20

swap(&a, &b)
print(a)
print(b)

class starship {
    var type: String = "hell"
    var age: Int  = 10
}

var obj = starship()


final class Messenger {

    private var messages: [String] = []

    private var queue = DispatchQueue(label: "messages.queue", attributes: .concurrent)

    var lastMessage: String? {
        return queue.sync {
            messages.last
        }
    }

    func postMessage(_ newMessage: String) {
        queue.async (flags: .barrier) { [weak self] in
            Thread.sleep(forTimeInterval: 2)
            self?.messages.append(newMessage)
        }
    }
}

let messenger = Messenger()
// Executed on Thread #1
messenger.postMessage("Hello SwiftLee!")
// Executed on Thread #2
print(messenger.lastMessage) // Prints: Hello SwiftLee!

DispatchQueue.global().async {
    print("c")
    DispatchQueue.main.async {
            print("a")
    }
}
print("b")

var numbers = [1,2,3,4,5,6]
let modifiedLazyNumbers = numbers.lazy.filter { number in
    number % 2 == 0
}.map { number in
    number * 2
}

for item in modifiedLazyNumbers {
    print(item)
}
print (modifiedLazyNumbers.first)

18

