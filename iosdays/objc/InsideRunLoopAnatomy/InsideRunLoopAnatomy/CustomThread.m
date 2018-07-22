//
//  CustomThread.m
//  InsideRunLoopAnatomy
//
//  Created by Bharath on 08/07/18.
//  Copyright © 2018 Bharath. All rights reserved.
//

#import "CustomThread.h"


#define MyRunLoopMode @"MyRunLoopMode"

@implementation CustomThread
static MyRunLoopSource *runLoopSource = nil;

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.exitThread = NO;
    }
    return self;
}

+(MyRunLoopSource*)sharedSource {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        runLoopSource  = [[MyRunLoopSource alloc] init];
    });
    return runLoopSource;
}

int threadId=0;
-(void) start {
    @autoreleasepool {
        
        NSString* str = [NSString stringWithFormat:@"thread#%d", threadId++];
        NSLog(@"start.... %@ : %@", [NSThread currentThread], str);
        [[NSThread currentThread] setName:str];
        [[CustomThread sharedSource] addToCurrentRunLoop];
        do
        {
            [[NSRunLoop currentRunLoop] runMode:(CFStringRef)@"MyRunLoopMode" beforeDate:[NSDate distantFuture]];
            NSLog(@"Running....");
        }while (!self.exitThread);
        NSLog(@"stop.... %@", [NSThread currentThread]);
    }
}

-(void) stop {
    self.exitThread = YES;
    [[CustomThread sharedSource] invalidate];
}

@end
