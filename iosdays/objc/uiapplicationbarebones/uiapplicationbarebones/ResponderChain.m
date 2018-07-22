//
//  ResponderChain.m
//  uiapplicationbarebones
//
//  Created by Bharath on 05/07/18.
//  Copyright © 2018 Bharath. All rights reserved.
//

#import "ResponderChain.h"

@implementation NSView (BNResponderChain)
- (NSView*) bnNextResponder
{
    NSResponder *responder = currentView;
    while ((responder = [responder nextResponder])) {
        
    }
    return nil;
}
@end

@implementation NSApplication (BNResponderChain)
- (NSView*) bnNextResponder
{
    NSArray<NSView*> *views  = [[[self keyWindow] contentView] subviews];
    for (int i = 0; i < [views count]; i++) {
        
    }
    return [[self keyWindow] bnNextResponder];
}
@end

@implementation NSResponder (BNResponderChain)
- (NSArray*) bnNextResponder
{
    return [@[self] arrayByAddingObjectsFromArray:[self.nextResponder bnNextResponder]];
}
@end

NSView * BNFirstResponder(void)
{
    return [[NSApplication sharedApplication] bnNextResponder];
}

NSArray * BNResponderChain(void)
{
    return [BNFirstResponder() bnNextResponder];
}
