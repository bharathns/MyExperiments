//
//  MyRunLoopContext.m
//  InsideRunLoopAnatomy
//
//  Created by Bharath on 08/07/18.
//  Copyright © 2018 Bharath. All rights reserved.
//

#import "MyRunLoopContext.h"
#import <Cocoa/Cocoa.h>
#import "AppDelegate.h"

@implementation MyRunLoopContext

- (id)initWithSource:(MyRunLoopSource *)src andLoop:(CFRunLoopRef)loop {
    _source = src;
    _runLoop = loop;
    return self;
}

- (void)updateContext:(CFRunLoopRef)loop {
    NSLog(@"updateContext");
    _runLoop = loop;
}

- (BOOL)isEqualToSource:(MyRunLoopContext*) sourceContext {
    return _runLoop == sourceContext.runLoop;
}

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    
    if (![object isKindOfClass:[MyRunLoopContext class]]) {
        return NO;
    }
    
    return [self isEqualToSource:(MyRunLoopContext *)object];
}

@end
