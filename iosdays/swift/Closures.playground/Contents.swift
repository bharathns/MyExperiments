//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

let closure = { (a:Int) -> Int in
    return a * 2
}

closure(2)

// write a typealias to define the kind of function we want to return, makes thing easier
typealias func1 = (String) -> Void

// function returning a function of type (String) -> Void (takes a string and returns a void)
func getDriver () -> func1 {
    func driver (name: String) -> Void {
        print("\(name) is your driver")
        return //"\(name) is your driver"
    }
    return driver
}

// how to call the function
let funcall = getDriver()
funcall("Rahul")


// The above function can be written as follows
/*
Typealias simplifies complex function declarations

func getDriverEx () -> ((String) -> Void) {
    func driver (name: String) -> Void {
        print("\(name) is your driver")
        return //"\(name) is your driver"
    }
    return driver
}
*/

// Now let us take a look at a more complex function declaration.

/*
  Lets try to define a "(function which takes a function which takes a string and returns a function which takes an int and returns an int and returns a void"
 
  So the trick is as follows ( https://www.eskimo.com/~scs/cclass/int/sx10c.html one of my favorites in C programming)
 
  We need to start defining aliases for every function mentioned there but in the reverse order! is that it?
  Yes of course!! (let us see if works)
*/

typealias func4 = (Int) -> Int
typealias func3 = (String) ->  func4
typealias func2 = (func3) -> Void

// All above declarations did not flag an error, so we still might be doing something right.

// so func2 would represent the complex function declaration we started to define.
// Below is same as func2 but in one go. I Have just expanded it back. Many a times it is difficult to arrive at this declaration in one go.
// But now we no the trick.!
typealias funcomplex = ((String) -> ((Int) -> Int)) -> Void

/*
 Till now we looked at function declarations and typealiases. We need to extend this knowledge to closures. Is it possible?
 How do we do this? We have a guiding force in the below prototype of a closure
 This is a prototype of a closure
 {(params) -> returntype in
 }
*/

let closure4 : func4 = { (a:Int) -> Int in
    print("inside closure 4 : \(a)")
    return 1
}

let closure3 : func3 = { (name:String) -> func4 in
    print("inside closure 3 : \(name)")
    return closure4
}

let closure2 : func2 = { (closure:func3) -> Void in
    let oneMoreClosure = closure("Bharath")
    print("inside closure 2 : \(oneMoreClosure(2))")
    return
}

closure2(closure3)

/*
 So just to recollect, what are those salient points to chew a large elephant?
 1. Cut it to smaller pieces.
 2. Use TypeAlias its your friend, at least initially.
 3. Typealiases are used in the Declaration phase
 4. Closures are used in the Definition phase of your initialization.
 
 We can go ahead now and condense the above closures in to one closure the way did for functions.
 
 Next we will see how this is used in swift provided types
 Below example shows an array of numbers lets try to sort it.
 
 The Prototype of sort function below is as follows
 
 public func sort(@noescape isOrderedBefore: (Self.Generator.Element, Self.Generator.Element) -> Bool) -> [Self.Generator.Element]
 
 let us not try to decipher everything here we are interested in the isOrderedBefore parameter.
 So the 2nd parameter is function pointer which takes two elements of the array and returns a Bool so we can replace it with a closure

*/


var numbers = [1, 5, 2]
let sort : (Int, Int) -> Bool = { (lhs:Int, rhs: Int) -> Bool in
    return lhs > rhs
}
print (numbers.sorted (by: sort))

// actually there is an operator already written for that > let us use it.
print(numbers.sorted(by: >))
/* 
 So here the sort closure we wrote has been replaced by > this works for datatypes which conforms to Comparable Protocol.
 so it is used by all these types mentioned here https://developer.apple.com/reference/swift/comparable#relationships
 
*/

var team = ["Sowmya", "Jithin", "Anumpama","Brahma", "Arjun"]
let sortString : (String, String) -> Bool = { (lhs:String, rhs: String) -> Bool in
    return lhs < rhs
}

print (team.sorted(by: sortString))
print (team.sorted(by: <))
// Both of the above do the samething just empahasizing the statement I made about Comparable protocol.


/* 
 So that is it.
 The goal of this exercise was to simplify closures and its understanding, thro' samples
 Trying to take the understanding from Terse to utterly Trivial.
*/

var arr = [[1,2,3], [4,5],[6,7]]
var arr1  = arr.flatMap{ (val : Array<Int>) -> Array<Int> in
    return val
}
print (arr1)

var numbers1 = [1, 2, 3, 4]
print (numbers1.flatMap { $0})

let mapped = numbers1.map { Array(repeating: $0, count: $0) }
//[[1], [2, 2], [3, 3, 3], [4, 4, 4, 4]]
print(mapped)

let flatMapped = numbers1.flatMap { Array(repeating: $0, count: $0) }
//[1, 2, 2, 3, 3, 3, 4, 4, 4, 4]
print(flatMapped)
func dosomethingelse(completion: ()->Void) {
    
    print("dosomethingelse closure")
    completion()
}
func dosomething(completion: ()->Void) {
    dosomethingelse(completion: {()->Void in
        sleep(4)
        completion()
    })
    print("dosomething closure")
}

dosomething {
    print("original closure")
}



