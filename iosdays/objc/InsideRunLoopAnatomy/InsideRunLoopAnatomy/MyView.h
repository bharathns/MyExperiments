//
//  MyView.h
//  InsideRunLoopAnatomy
//
//  Created by Bharath on 10/07/18.
//  Copyright © 2018 Bharath. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MyView : NSView
@property NSMutableArray* drawRects;
-(void)updateView;
@property (weak) IBOutlet NSTextField *jobsTextView;
@property (weak) IBOutlet NSTextField *threadsTextView;

@end
