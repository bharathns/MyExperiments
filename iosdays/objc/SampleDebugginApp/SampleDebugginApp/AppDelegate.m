//
//  AppDelegate.m
//  SampleDebugginApp
//
//  Created by Bharath on 04/07/18.
//  Copyright © 2018 Bharath. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end
long count = 0;
CGEventRef eventOccurred(CGEventTapProxy proxy, CGEventType type, CGEventRef event, void* refcon) {
    @autoreleasepool {
    

        NSLog(@"activity %lu: %u", ++count, type);
    }
    
    return event;
}

CGEventRef myCGEventCallback(CGEventTapProxy proxy, CGEventType type,
                  CGEventRef event, void *refcon)
{
    // Do some sanity check.
    if (type != kCGEventMouseMoved)
        return event;
    
    // The incoming mouse position.
    CGPoint location = CGEventGetLocation(event);
    
    // We can change aspects of the mouse event.
    // For example, we can use CGEventSetLoction(event, newLocation).
    // Here, we just print the location.
    printf("(%f, %f)\n", location.x, location.y);
    
    // We must return the event for it to be useful.
    return event;
}

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
//    CFRunLoopObserverRef observer = CFRunLoopObserverCreateWithHandler(NULL, (kCFRunLoopEntry | kCFRunLoopExit), YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity)
//                                                                       {
//                                                                           static unsigned long count = 0;
//                                                                           NSLog(@"activity %lu: %@", ++count, (activity & kCFRunLoopEntry ? @"Enter" : @"Exit"));
//                                                                       });
//    CFRunLoopAddObserver(CFRunLoopGetMain(), observer, kCFRunLoopCommonModes);
//

    if (!AXIsProcessTrusted() ) {
        NSLog(@"AXIsProcessTrusted : false");
    }
    CGEventMask eventMask;
    eventMask = (1 << kCGEventMouseMoved);

    CFMachPortRef mouseMoved = CGEventTapCreate(
                                                kCGAnnotatedSessionEventTap, kCGTailAppendEventTap,
                                                0, eventMask, myCGEventCallback, NULL);
    if (mouseMoved) {
        CFRunLoopRef loop = CFRunLoopGetCurrent();
        CFRunLoopSourceRef src = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, mouseMoved, 0);
        CFRunLoopAddSource(loop, src, kCFRunLoopCommonModes);
        CGEventTapEnable(mouseMoved, true);
        //CFRunLoopRun();
        //[[NSRunLoop currentRunLoop] run];
        //CFRelease(src);
        //CFRelease(mouseMoved);
        
    }
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


@end


