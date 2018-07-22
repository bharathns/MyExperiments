//
//  main.swift
//  functionalSwift
//
//  Created by Bharath on 26/05/18.
//  Copyright © 2018 Bharath. All rights reserved.
//

import Foundation

print("Hello, World!")

let closure = { (a:Int) -> Int in
    return a * 2
}

print(closure(2))

class Request {
    let requestValue : Int = 100;
    func executeRequest(request: String, completion:@escaping ()-> Void) {
        DispatchQueue.global().async {
            completion()
        }
    }
    
    func callRequest () {
        self.executeRequest(request: "print hello") {
            print("original : \(self.requestValue)") // perfect recipe for retain cycle
        }
    }
    
    func theRightCallRequest () {
        self.executeRequest(request: "print hello") {[weak self] in
            print("original : \(String(describing: self?.requestValue))") // this would be the correction for callRequest
        }
    }
}
let request: Request = Request()
request.callRequest()

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


let voidSomething  = {
    print("voidSomething closure")
}

dosomethingelse (completion: voidSomething)


let arr : [Int] = [1,1,2,3]
print(arr.compactMap{ $0 })
func reduce<A, R>(arr: [A], initialValue: R,
                  combine: (R, A) -> R) -> R {
    var result = initialValue
    for i in arr {
        result = combine(result, i) }
    return result
}

func sumUsingReduce(xs: [Int]) -> Int {
    return reduce(arr: xs, initialValue: 0,combine: +) //{ result, x in result + x }
}
func productUsingReduce(xs: [Int]) -> Int {
    return reduce(arr: xs, initialValue: 1,combine: *) //{ result, x in result * x }
}

print(sumUsingReduce(xs: arr))
print(productUsingReduce(xs: arr))


class Solution {
    func numberToWords(_ num: Int) -> String {
        let b: Int  = 1000000000
        let m: Int  = 1000000
        let t: Int  = 1000
        if num>=b {
            let rem : Int  = num/b
            if rem == 0 {
                return numberToWords(num/b) + " Billion"
            }
            else {
                return numberToWords(num/b) + " Billion" + numberToWords(rem)
            }
        } else if num >= m {
            let rem : Int  = num/m
            if rem == 0 {
                return numberToWords(num/m) + " Million"
            }
            else {
                return numberToWords(num/m) + " Million" + numberToWords(rem)
            }
        }else if num>=t {
            let rem : Int  = num/t
            if rem == 0 {
                return numberToWords(num/t) + " Thousand"
            }
            else {
                return numberToWords(num/t) + " Thousand" + numberToWords(rem)
            }
        }else if num >= 100 {
            let rem : Int  = num%100
            if rem==0 {
                return under20[num/100] + " Hundred"
            }
            else {
                return under20[num/100] + " Hundred " + numberToWords(rem)
            }
        }else if num>=20 {
            let rem : Int = num%10
            if rem==0 {
                return tens[num/10]
            }
            else {
                return tens[num/10] + " " + numberToWords(rem)
            }
        }
        else {
            return under20[num]
        }
    }
    
    let under20 : [String] = [
        "Zero","One","Two","Three","Four","Five","Six","Seven","Eight","Nine",
        "Ten","Eleven", "Twelve", "Thirteen", "Fourteen", "Fifteen", "Sixteen", "Seventeen",
        "Eighteen", "Nineteen"];
    let tens : [String] = [
        "", "", "Twenty", "Thirty", "Forty", "Fifty", "Sixty", "Seventy", "Eighty", "Ninety" ];
}

let sol : Solution = Solution()
print(sol.numberToWords(12345))
