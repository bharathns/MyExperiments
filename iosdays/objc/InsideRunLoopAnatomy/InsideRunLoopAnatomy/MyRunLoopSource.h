//
//  MyRunLoopSource.h
//  InsideRunLoopAnatomy
//
//  Created by Bharath on 08/07/18.
//  Copyright © 2018 Bharath. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Job.h"
@interface MyRunLoopSource : NSObject
{
    CFRunLoopSourceRef runLoopSource;
    CFRunLoopRef runLoop;
@public
        //NSMutableArray* jobQueue;
}
@property NSMutableArray* jobQueue;
- (id)init;
- (void)addToCurrentRunLoop;
- (void)invalidate;
+ (CFRunLoopSourceRef)sharedRunLoopSource;
// Handler method
- (void)handleSignal;

// Client interface for registering commands to process
- (void)addJob:(Job*)job;
- (void)signalRunLoop:(CFRunLoopRef)runloop;

@end
