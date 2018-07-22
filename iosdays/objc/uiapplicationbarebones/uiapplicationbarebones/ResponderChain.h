//
//  ResponderChain.h
//  uiapplicationbarebones
//
//  Created by Bharath on 05/07/18.
//  Copyright © 2018 Bharath. All rights reserved.
//

#import <AppKit/AppKit.h>

@interface NSView (BNResponderChain)
- (NSView*) bnNextResponder; // Recurse into subviews to find one that responds YES to -isFirstResponder
@end

@interface NSApplication (BNResponderChain)
- (NSView*) bnNextResponder; // in the -keyWindow
@end

@interface NSResponder (BNResponderChain)
- (NSArray*) bnNextResponder; // List the -nextResponder starting at the receiver
@end


NSView * BNFirstResponder(void); // in the app key window
NSArray * BNResponderChain(void);  // Starting at the first responder
