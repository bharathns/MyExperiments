//
//  AppDelegate.m
//  InsideRunLoopAnatomy
//
//  Created by Bharath on 08/07/18.
//  Copyright © 2018 Bharath. All rights reserved.
//

#import "AppDelegate.h"


@interface AppDelegate ()

@end

@implementation AppDelegate
-(instancetype)init {
    self = [super init];
    if (self) {
       sourcesToPing  = [[NSMutableArray alloc] init];
    }
    return self;
}
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


- (void)registerSource:(MyRunLoopContext*)sourceInfo;
{
    NSLog(@"registerSource");
    [sourcesToPing addObject:sourceInfo];
    NSLog(@"%lu : %@",(unsigned long)sourcesToPing.count, sourceInfo);
}

- (void)removeSource:(MyRunLoopContext*)sourceInfo
{
    id    objToRemove = nil;
    for (MyRunLoopContext* context in sourcesToPing)
    {
        if ([context isEqual:sourceInfo])
        {
            objToRemove = context;
            CFRunLoopStop(context.runLoop);
            break;
        }
    }
    if (objToRemove!=nil) {
        CFRetain((__bridge CFTypeRef)(objToRemove));
        [sourcesToPing removeObject:objToRemove];
    }
    NSLog(@"removeSource : %lu", (unsigned long)sourcesToPing.count);
}

-(MyRunLoopContext*) getContext {
    if(sourcesToPing.count>0) {
        return [sourcesToPing objectAtIndex:0];
    }
    return NULL;
}

-(MyRunLoopContext*) getNextContext {
    if(sourcesToPing.count>0) {
        return [sourcesToPing objectAtIndex:0];
    }
    return NULL;
}

-(MyRunLoopContext*) getContextFromSource:(MyRunLoopSource*) source {
    for (MyRunLoopContext* context in sourcesToPing)
    {
        if ([context.source isEqual:source])
        {
            return context;
        }
    }
    return NULL;
}

-(void) updateUI: (NSNotification*) note {
//    NSInteger integer = [[[NSThread currentThread] valueForKeyPath:@"private.seqNum"] integerValue];
//    int threadid  = (int)integer - 1;
//    int jobNumber = [job jobNumber];
//    int y = ((jobNumber)*50) + ((jobNumber)*3);
//    int x = ((threadid)*50) + ((threadid)*3);
//    CGRect cgRect = CGRectMake(x, y, 50, 50);
//    NSValue* rect  = [NSValue valueWithRect:NSRectFromCGRect(cgRect)];
//    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        NSDictionary *userInfo =
//        [NSDictionary dictionaryWithObject:rect forKey:@"drawRect"];
//        [[NSNotificationCenter defaultCenter]
//         postNotificationName:@"TestNotification"
//         object:nil userInfo:userInfo];
//    });
}
@end
