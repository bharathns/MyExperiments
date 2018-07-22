//
//  MainApplication.m
//  BareBonesWithNib
//
//  Created by Bharath on 06/07/18.
//  Copyright © 2018 Bharath. All rights reserved.
//

#import "MainApplication.h"

// this is from Matt Gallagher with some fixes


//MyApplicationMain is not required as NSApplicationMain in main.h will end up using MyApplication as AppDelegate
//Since the principal class info.plist has been pointed to MyAPPLICATION instead of AppDelegate
//int MyApplicationMain(int argc, const char **argv)
//{
//    @autoreleasepool {
//
//        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
//        Class principalClass =
//        NSClassFromString([infoDictionary objectForKey:@"NSPrincipalClass"]);
//        NSApplication *applicationObject = [principalClass sharedApplication];
//
//        NSString *mainNibName = [infoDictionary objectForKey:@"NSMainNibFile"];
//        NSNib *mainNib = [[NSNib alloc] initWithNibNamed:mainNibName bundle:[NSBundle mainBundle]];
//        [mainNib instantiateWithOwner:applicationObject topLevelObjects:nil];
//
//        if ([applicationObject respondsToSelector:@selector(run)])
//        {
//            [applicationObject
//             performSelectorOnMainThread:@selector(run)
//             withObject:nil
//             waitUntilDone:YES];
//        }
//
//    }
//    return 0;
//}

@implementation MyApplication

- (void)run
{
    [self finishLaunching];
    [[NSNotificationCenter defaultCenter]
     postNotificationName:NSApplicationWillFinishLaunchingNotification
     object:NSApp];
    [[NSNotificationCenter defaultCenter]
     postNotificationName:NSApplicationDidFinishLaunchingNotification
     object:NSApp];
    
    shouldKeepRunning = YES;
    do
    {
        NSEvent *event =
        [self
         nextEventMatchingMask:NSEventMaskAny
         untilDate:[NSDate distantFuture]
         inMode:NSDefaultRunLoopMode
         dequeue:YES];
        
        [self sendEvent:event];
        [self updateWindows];
    } while (shouldKeepRunning);
}

- (void)terminate:(id)sender
{
    shouldKeepRunning = NO;
}

@end
