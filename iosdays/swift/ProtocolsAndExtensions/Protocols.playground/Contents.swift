//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"


protocol Named {
    var name: String { get }
}
protocol Aged {
    var age: Int { get }
}
struct Person: Named, Aged {
    var name: String
    var age: Int
}
func wishHappyBirthday(to celebrator: Named & Aged) {
    print("Happy birthday, \(celebrator.name), you're \(celebrator.age)!")
}
let birthdayPerson = Person(name: "Malcolm", age: 21)
wishHappyBirthday(to: birthdayPerson)


extension Collection {
    func evenElements () -> [Generator.Element]? {
     
        var index = startIndex
        var result : [Generator.Element]? = []
        print("count : \(abs(count.distance(to: 1)))")
        for i in 0..<abs(count.distance(to: 0)) {
            if i % 2 == 0 {
                result?.append(self[index])
            }
            index = self.index(after: index)
        }
        return result
    }
}

print([1,2,3,4,5,6,7].evenElements())

enum ApplicationError: Error {
    case other
}

protocol ErrorHandler {
    func handle(error: Error)
}


extension ErrorHandler {
    func handle(error: Error) {
        print(error.localizedDescription)
    }
}


struct Handler: ErrorHandler {
    /*func handle(error: Error) {
        fatalError("Unexpected error occurred")
    }*/
}

let handler: Handler = Handler()
handler.handle(error: ApplicationError.other)

protocol Animal {
    func speak()
}

extension Animal {
    func speak() {
        print("I can speak!!")
    }
}

struct Monkey : Animal {
    override func speak() {
        print("Monkey can speak!!")
    }
}
let monkey = Monkey()
monkey.speak()
