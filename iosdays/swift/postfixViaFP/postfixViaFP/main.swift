//
//  main.swift
//  postfixViaFP
//
//  Created by Bharath Nadampalli on 09/05/18.
//  Copyright © 2018 com.samples. All rights reserved.
//

import Foundation

print("Hello, World!")


extension String {
    func lastOccurrenceOfString(string: String) -> String.Index? {
        let characterSet = CharacterSet(charactersIn: string)
        if let range = rangeOfCharacter(from: characterSet, options: .backwards) {
            let offsetBy = distance(from: startIndex, to: range.upperBound)
            
            return index(startIndex, offsetBy: offsetBy)
        }
        return nil
    }
}


class Stack {
    var stackArray = [AnyObject]()
    func push(stringToPush: AnyObject){
        self.stackArray.append(stringToPush)
    }
    
    func pop() -> AnyObject? {
        if self.stackArray.last != nil {
            guard let stringToReturn = self.stackArray.last else {
                return nil
            }
            self.stackArray.removeLast()
            return stringToReturn
        } else {
            return nil
        }
    }
    
    func top() -> AnyObject? {
        if self.stackArray.last != nil {
            guard let stringToReturn = self.stackArray.last else {
                return nil
            }
            return stringToReturn
        } else {
            return nil
        }
    }
    
    func popAll() {
        stackArray.removeAll()
    }
}

var queryString : String = "((getValue(tmf_scope).contains('Country'))||(getValue(tmf_scope).contains('Site'))) && (getValue(tmf_scope).equals('Trial'))"
//var expressionex  = expression
var specialCharctersReplaceStrings = [String]()
let i: Int? = nil;
print("\(queryString)\n\n")
protocol QueryStringMutable : class {
    var queryString : String? {get set}
}

class QueryString : QueryStringMutable {
    var queryString: String?
    init(qs: String) {
        queryString = qs
    }
}

func replaceForm( expression: inout String)-> [QueryString]? {
    var expressionex = expression
    var result : [QueryString]? = expression.replacingOccurrences(of: "&&", with: "&").replacingOccurrences(of: "||", with: "|").split{$0 == "&" || $0=="|"}.map{QueryString(qs: String($0))}

    //print("\(i.map{$0} ?? 0)")
    print(expression)
    result?.compactMap{
        if let index = $0.queryString?.index(of: "g"),let startIndex  = $0.queryString?.startIndex, index>startIndex {
            $0.queryString = String($0.queryString?.suffix(from: index) ?? "")
        }
        if let index = $0.queryString?.lastOccurrenceOfString(string: "\'"), let lastIndex : String.Index = $0.queryString?.index(index, offsetBy: 1), lastIndex < ($0.queryString?.endIndex)! {
            $0.queryString = String($0.queryString?[..<lastIndex] ?? "")
        }
    }
    
    result?.compactMap{
        if let range  = expressionex.range(of: $0.queryString ?? "") {
            expressionex = expressionex.replacingCharacters(in: range  , with: "$")
        }
    }
    expression = expressionex
    return result;
}
replaceForm(expression: &queryString)?.compactMap{print($0.queryString)}
print("\n result : \(queryString)")
// got to this form here (($)||($)) && ($)
var expressionStack : Stack  = Stack()
var expressionQueue =  [AnyObject]()




