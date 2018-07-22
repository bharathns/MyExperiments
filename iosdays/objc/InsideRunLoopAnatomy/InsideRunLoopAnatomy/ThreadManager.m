//
//  ThreadManager.m
//  InsideRunLoopAnatomy
//
//  Created by Bharath on 10/07/18.
//  Copyright © 2018 Bharath. All rights reserved.
//

#import "ThreadManager.h"
#import "CustomThread.h"

@implementation ThreadManager
- (instancetype)init
{
    self = [super init];
    if (self) {
        _threads  = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)schedule:(int)numberOfThreads {
    int i=0;
    while(i<numberOfThreads) {
        CustomThread* _customThread = [[CustomThread alloc] init];
        [_threads addObject:_customThread];
        [_customThread performSelectorInBackground:@selector(start) withObject:_customThread];
        i++;
    }
}

-(void)stop {
    int i=0;
    while(i<_threads.count) {
        CustomThread* _thread = [_threads  objectAtIndex:i];
        [_thread stop];
        i++;
    }
    [_threads removeAllObjects];
}
@end
