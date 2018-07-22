//
//  AppDelegate.h
//  InsideRunLoopAnatomy
//
//  Created by Bharath on 08/07/18.
//  Copyright © 2018 Bharath. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MyRunLoopContext.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>
{
@public
    NSMutableArray *sourcesToPing;
}
- (void)registerSource:(MyRunLoopContext*)sourceInfo;
- (void)removeSource:(MyRunLoopContext*)sourceInfo;
- (MyRunLoopContext*)getContext;
- (MyRunLoopContext*)getContextFromSource:(MyRunLoopSource*) source;
- (void)updateUI: (NSNotification*) note;
@end

