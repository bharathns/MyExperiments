//
//  MainApplication.h
//  BareBonesWithNib
//
//  Created by Bharath on 06/07/18.
//  Copyright © 2018 Bharath. All rights reserved.
//

#ifndef MainApplication_h
#define MainApplication_h

#import <Cocoa/Cocoa.h>

int MyApplicationMain(int argc, const char **argv);

@interface MyApplication : NSApplication
{
    bool shouldKeepRunning;
}

- (void)run;
- (void)terminate:(id)sender;

@end
#endif /* MainApplication_h */
