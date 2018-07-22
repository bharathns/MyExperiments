//
//  MyRunLoopContext.h
//  InsideRunLoopAnatomy
//
//  Created by Bharath on 08/07/18.
//  Copyright © 2018 Bharath. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyRunLoopSource.h"
void RunLoopSourceScheduleRoutine (void *info, CFRunLoopRef rl, CFStringRef mode);
void RunLoopSourcePerformRoutine (void *info);
void RunLoopSourceCancelRoutine (void *info, CFRunLoopRef rl, CFStringRef mode);

// RunLoopContext is a container object used during registration of the input source.
@interface MyRunLoopContext : NSObject

@property CFRunLoopRef runLoop;
@property (readonly) MyRunLoopSource* source;

- (id)initWithSource:(MyRunLoopSource*)src andLoop:(CFRunLoopRef)loop;
- (void)updateContext:(CFRunLoopRef)loop;
- (BOOL)isEqualToSource:(MyRunLoopContext*) sourceContext;
@end
