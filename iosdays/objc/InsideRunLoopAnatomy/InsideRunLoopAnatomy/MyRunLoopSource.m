//
//  MyRunLoopSource.m
//  InsideRunLoopAnatomy
//
//  Created by Bharath on 08/07/18.
//  Copyright © 2018 Bharath. All rights reserved.
//

#import "MyRunLoopSource.h"
#import <Cocoa/Cocoa.h>
#import "AppDelegate.h"
void RunLoopSourceScheduleRoutine (void *info, CFRunLoopRef rl, CFStringRef mode)
{
    NSLog(@"RunLoopSourceScheduleRoutine : ");
    MyRunLoopSource* obj = (MyRunLoopSource*)CFBridgingRelease(info);
    AppDelegate*   delegate = [[NSApplication sharedApplication] delegate];
    MyRunLoopContext* theContext = [[MyRunLoopContext alloc] initWithSource:obj andLoop:rl];

    [delegate performSelectorOnMainThread:@selector(registerSource:) withObject:theContext waitUntilDone:NO];
}

void RunLoopSourcePerformRoutine (void *info)
{
    NSLog(@"RunLoopSourcePerformRoutine : %@", info);
    MyRunLoopSource*  obj = (__bridge MyRunLoopSource*)info;
    
    if([[obj jobQueue] count]>0) {
        [obj handleSignal];
    }
}

void RunLoopSourceCancelRoutine (void *info, CFRunLoopRef rl, CFStringRef mode)
{
    NSLog(@"RunLoopSourceCancelRoutine : %@",info);
    MyRunLoopSource* obj = (__bridge MyRunLoopSource*)info;
    AppDelegate* delegate = [[NSApplication sharedApplication] delegate];
    MyRunLoopContext* theContext = [[MyRunLoopContext alloc] initWithSource:obj andLoop:rl];
    
    [delegate performSelectorOnMainThread:@selector(removeSource:) withObject:theContext waitUntilDone:YES];
}

@interface MyRunLoopSource ()
    @property (strong) NSLock *jobLock;
@end

@implementation MyRunLoopSource

- (id)init
{
    _jobQueue = [[NSMutableArray alloc] init];
    _jobLock = [[NSLock alloc] init];
    CFRunLoopSourceContext    context = {0, (__bridge void *)(self), NULL, NULL, NULL, NULL, NULL,
        &RunLoopSourceScheduleRoutine,
        RunLoopSourceCancelRoutine,
        RunLoopSourcePerformRoutine};
    
    runLoopSource = CFRunLoopSourceCreate(NULL, 0, &context);
    return self;
}

//+ (CFRunLoopSourceRef)sharedRunLoopSource {
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//
//    });
//    return runLoopSource;
//}

- (void)addToCurrentRunLoop
{
     CFRunLoopGetCurrent();
    
    CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, (CFStringRef)@"MyRunLoopMode"); // Custom RunLoopMode
}

- (void)addJob:(Job*)job
{
    [self.jobLock lock];
    [[self jobQueue] addObject:job];
    [self.jobLock unlock];
}

- (void)signalRunLoop:(CFRunLoopRef)runloop
{
    if([[self jobQueue] count]) {
        CFRunLoopSourceSignal(runLoopSource);
        CFRunLoopWakeUp(runloop);
    }
}

- (void)handleSignal{
    [self.jobLock lock]; //lock only to get the job remove from the list
    Job* job = NULL;
    if([[self jobQueue] count]>0) {
        job  = [[self jobQueue] objectAtIndex:0];
        [[self jobQueue] removeObjectAtIndex:0];
    }
    [self.jobLock unlock];
    //[NSThread sleepForTimeInterval:3];
    NSInteger integer = [[[NSThread currentThread] valueForKeyPath:@"private.seqNum"] integerValue];
    int threadid  = (int)integer - 1;
    int jobNumber = [job jobNumber];
    int y = 53 + ((jobNumber)*50) + ((jobNumber)*3);
    int x = 203 + ((threadid)*50) + ((threadid)*3);
    CGRect cgRect = CGRectMake(x, y, 50, 50);
    NSValue* rect  = [NSValue valueWithRect:NSRectFromCGRect(cgRect)];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *userInfo =
        [NSDictionary dictionaryWithObject:rect forKey:@"drawRect"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DrawGraph" object:nil userInfo:userInfo];
    });
    NSLog(@"handleSignal %ld :  %d ", (long)integer, [job jobNumber]);
    //NSLog(@"handleSignal %@ :  %d ", [NSThread currentThread], [job jobNumber]);
}

- (void)invalidate {
    [[self jobQueue] removeAllObjects];
    CFRunLoopSourceInvalidate(runLoopSource);
}

@end


