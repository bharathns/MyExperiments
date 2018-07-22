//
//  main.m
//  ARCDisassembly
//
//  Created by Bharath on 12/06/18.
//  Copyright © 2018 Bharath. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYZ : NSObject
-(void) abc;
@end

@implementation XYZ {
    int intvar;
    double doubleDhamaka;
}
-(void) abc {
    NSLog(@"Inside abc");
}
@end
//@interface MyClass : NSObject
//-(void)sample;
//@end
//
//@implementation MyClass
//-(void)sample {
//    NSLog(@"hi from sample");
//}
//- (void)parseTitle:(NSString **)title note:(NSString **)note fromText:(NSString *)text {
//    NSMutableArray *noteLines = [NSMutableArray array];
//    [text enumerateLinesUsingBlock:^(NSString *line, BOOL *stop) {
//        if (*title == nil) {
//            *title = line;
//            return;
//        }
//        [noteLines addObject:line];
//    }];
//    if (noteLines.count > 0) {
//        *note = [noteLines componentsJoinedByString:@"\n"];
//    }
//}
//@end

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
//        MyClass *myClass  = [[MyClass alloc] init];
//        [myClass sample];
        
        XYZ* xyz  = [[XYZ alloc] init];
        NSLog(@"%ld", CFGetRetainCount((__bridge CFTypeRef)xyz));
        [xyz abc];
        NSLog(@"%ld", CFGetRetainCount((__bridge CFTypeRef)xyz));
    }
    return 0;
}

//static CGRect screenBounds;
//
//// This callback will be invoked every time the mouse moves.
////
//CGEventRef
//myCGEventCallback(CGEventTapProxy proxy, CGEventType type,
//                  CGEventRef event, void *refcon)
//{
//    // Do some sanity check.
//    if (type != kCGEventMouseMoved)
//        return event;
//
//    // The incoming mouse position.
//    CGPoint location = CGEventGetLocation(event);
//
//    // We can change aspects of the mouse event.
//    // For example, we can use CGEventSetLoction(event, newLocation).
//    // Here, we just print the location.
//    printf("(%f, %f)\n", location.x, location.y);
//
//    // We must return the event for it to be useful.
//    return event;
//}
//
//int
//main(void)
//{
//
//    CFMachPortRef      eventTap;
//    CGEventMask        eventMask;
//    CFRunLoopSourceRef runLoopSource;
//
//    // The screen size of the primary display.
//    screenBounds = CGDisplayBounds(CGMainDisplayID());
//    printf("The main screen is %dx%d\n", (int)screenBounds.size.width,
//           (int)screenBounds.size.height);
//
//    // Create an event tap. We are interested in mouse movements.
//    eventMask = (1 << kCGEventMouseMoved);
//    eventTap = CGEventTapCreate(
//                                kCGSessionEventTap, kCGHeadInsertEventTap,
//                                0, eventMask, myCGEventCallback, NULL);
//    if (!eventTap) {
//        fprintf(stderr, "failed to create event tap\n");
//        exit(1);
//    }
//
//    // Create a run loop source.
//    runLoopSource = CFMachPortCreateRunLoopSource(
//                                                  kCFAllocatorDefault, eventTap, 0);
//
//    // Add to the current run loop.
//    CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource,
//                       kCFRunLoopCommonModes);
//
//    // Enable the event tap.
//    CGEventTapEnable(eventTap, true);
//
//    // Set it all running.
//    CFRunLoopRun();
//
//    // In a real program, one would have arranged for cleaning up.
//
//    exit(0);
//}
