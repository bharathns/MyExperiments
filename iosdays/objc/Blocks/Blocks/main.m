//
//  main.m
//  Blocks
//
//  Created by Bharath Nadampalli on 01/06/17.
//  Copyright © 2017 EMC. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 Blocks are pretty close to C function pointers in terms of how you declare them!(the only difference being in C function pointers use * here we use ^) we are going to see how.
 Different ways for declaring blocks.
 
 1. returnType (^blockName)(parameters)
 2. typedef is much like C language typedef, or swift's typealias
    syntax is : typedef returntype (^blocktypename) (parameters)
 
 Defining a block
 
 ^ returnType (parameters) {
    return returnType
 };
 
 */
// Below is called declaration if we just make a call with out defining the function we going to end up with with,
// BAD_ACCESS Exception, its like name an anonymouse entity.
void (^myBlock)(void);

void (^myBlockDef)(void) = ^ void (void) {
    NSLog(@"inside myblockdef");
};

/*
 The above can also be written as striping the return value and parameters
 void (^myBlockDef)(void) = ^ {
    NSLog(@"inside myblockdef");
 };
 */

// declaring a block type, in this example the "type is takes an int and returns an int"
typedef int (^MyBlockType) (int);

// using the block type to define a variable.
MyBlockType blockTakingIntReturningInt  =  ^ int (int i) {
    NSLog(@"inside MyBlockType");
    return i * 2;
};

/*
 As you guessed it already we write the same as shown below, return value is assumed.
 MyBlockType blockTakingIntReturningInt  =  ^(int i) {
    NSLog(@"inside MyBlockType");
    return i * 2;
 };
 Now for the same thought process as we used to understand closures in swift.
 can we declare and define a complex block?
*/

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
        //myBlock(); will throw BAD_ACCESS exception no function body
        myBlockDef();
        NSLog(@"%d", blockTakingIntReturningInt(2));
    }
    return 0;
}
