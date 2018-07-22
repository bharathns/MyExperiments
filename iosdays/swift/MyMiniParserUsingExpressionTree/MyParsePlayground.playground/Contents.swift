//: Playground - noun: a place where people can play
// Way to parse a logical expression by building postFix expression tree using a stack and queue
// Encountered this problem while we had to evaluate a javascript in using swift ended up building an expression tree
import UIKit
import Foundation

var sa = "(getValue(fieldName1).contains('Cat') && getValue(fieldName3).contains('True')) || (getValue(fieldName2).equals('India') && getValue(fieldName1).contains('Cat'))"
var sa1 = "getValue(fieldName1).contains('India') && getValue(fieldName3).contains('False') || getValue(fieldName2).equals('Experiment')"
var sa2 = "getValue(fieldName1).contains('India') && getValue(fieldName3).contains('False') || getValue(fieldName2).equals('Experiment') || (getValue(fieldName1).contains('India') && getValue(fieldName3).contains('TRUE'))"


class Stack {
    var stackArray = [String]()
    func push(stringToPush: String){
        self.stackArray.append(stringToPush)
    }
    
    func pop() -> String? {
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
    
    func top() -> String? {
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

extension String {
    func index(of string: String) -> Index? {
        return rangeOfString(string, options: .LiteralSearch)?.startIndex
    }
    
    func index(of string: String, from: Index) -> Index? {
        return rangeOfString(string, options: .LiteralSearch, range: from..<self.endIndex)?.startIndex
    }
}
infix operator ∧ { associativity left }
func ∧(lhs: Bool, rhs: Bool) -> Bool {
    return lhs && rhs
}

class Expression {
    var expressionStack : Stack  = Stack()
    var expressionQueue =  [String]()
    var specialCharctersReplaceStrings = [String]()
    func replaceQueriesWithSpecialCharacter(id:String)-> String {
        
        let sentence = id
        let query = "getValue"
        var searchRange = sentence.startIndex..<sentence.endIndex
        var indexes: [String.Index] = []
        
        specialCharctersReplaceStrings.removeAll()
        while let range = sentence.rangeOfString(query, options: .CaseInsensitiveSearch, range: searchRange) {
            searchRange = range.endIndex..<searchRange.endIndex
            indexes.append(range.startIndex)
        }
        //        print(indexes)
        
        var expression = sentence
        
        for i in 0..<indexes.count {
            let indexArray = NSMutableDictionary()
            //            print(expression)
            
            let indexValue = expression.index(of: "getValue")
            //            print(indexValue)
            
            let intValue = expression.startIndex.distanceTo(indexValue!)
            indexArray[intValue] = "g"
            
            for index in intValue..<expression.characters.count {
                
                if expression[expression.startIndex.advancedBy(index)] == "(" {
                    indexArray[index] = "("
                }
                
                if expression[expression.startIndex.advancedBy(index)] == ")" {
                    indexArray[index] = ")"
                }
                
                if expression[expression.startIndex.advancedBy(index)] == "&" || expression[expression.startIndex.advancedBy(index)] == "|" {
                    break
                }
            }
            var keysArray = indexArray.allKeys as? [Int]
            keysArray = keysArray!.sort { $0 < $1 }
            //            print(keysArray)
            let firstIndex:Int = keysArray![0]
            let lastIndex: Int = keysArray![4]
            
            let range = Range(expression.startIndex.advancedBy(firstIndex) ..< expression.startIndex.advancedBy(lastIndex+1))
            let substring = expression.substringWithRange(range)
            specialCharctersReplaceStrings.insert(substring, atIndex: i)
            let result = expression.stringByReplacingCharactersInRange(range, withString: "$")
            expression = result
        }
        
        //print("############################################### \n Expression : \(id) \n Replace $ expression : \(expression) \n Evaluations string : \(specialCharctersReplaceStrings) \n###############################################")
        //print("\n \(expression)")
        return expression
    }

    func isNotOperator(val: String) -> Bool {
        
        return val.containsString("$")
    }


    func buildPostFix(expression: String) {
        expressionStack.popAll()
        expressionQueue.removeAll()
        var operators: [String:String.CharacterView.Index? ] = ["(":nil, "$":nil, "&&":nil, "||":nil, ")":nil]
        var startIndex = expression.startIndex
        
        while startIndex < expression.endIndex {
            for (_,element) in operators.enumerate() {
                //print("\(element.0) : \(element.1)")
                operators[element.0] =  nil
                if let operatorIndex = expression.index(of: element.0, from: startIndex) {
                    operators[element.0] = operatorIndex
                }
            }
            
            let element  = operators.minElement { $0.1 < $1.1}
            guard let op = element?.0, opIndex = element?.1  else{
                continue
            }
            startIndex =  opIndex.advancedBy(1)
            if isNotOperator(op)  {
                expressionQueue.append(op)
                if expressionStack.top() != "(", let op1 = expressionStack.pop() {
                    expressionQueue.append(op1)
                }
            }else {
                if op != ")" {
                    expressionStack.push(op)
                }else {
                    while let op1 = expressionStack.pop() where op1 != "(" {
                        expressionQueue.append(op1)
                    }
                }
            }
        }
        while let op1 = expressionStack.pop()  {
            expressionQueue.append(op1)
        }
    }

    
    
    func isOperator(string: String) ->Bool {
        return ((string != "&&") || (string != "||"))
    }
    
    func getResult(lhs: String, rhs: String) -> Bool {
        return (true ∧ false)
    }
    
    func evaluate() {
        // Here we can just reverse the expressionQueue like this and reuse Stack :-) to pop and push/evaluate to a new stack like shown below
        // and then evaluate the stack this is a very basic piece of code. thou' the below code is incomplete and just shown as pseudocode.
        let stack: Stack = Stack()
        stack.stackArray = expressionQueue.reverse()
        let evalStack : Stack = Stack()
//        while let obj = stack.pop() {
//            if (self.isOperator(obj)), let leftOp = evalStack.pop(), let righOp = evalStack.pop() {
//                let result = getResult(leftOp, rhs: righOp)
//                evalStack.push("result")
//            }else {
//                evalStack.push(obj)
//            }
//        }
        //print(stack.stackArray)
    }
    
    func eval(expression: String) {
        let evalutatedExpression = replaceQueriesWithSpecialCharacter (expression)
        buildPostFix(evalutatedExpression)
        
        self.evaluate()
        print("\(evalutatedExpression) \n \(specialCharctersReplaceStrings) \n \(expressionQueue)\n")
    }
}

let exp: Expression =  Expression()
exp.eval(sa)
exp.eval(sa1)
exp.eval(sa2)
