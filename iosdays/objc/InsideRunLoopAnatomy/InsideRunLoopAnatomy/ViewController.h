//
//  ViewController.h
//  InsideRunLoopAnatomy
//
//  Created by Bharath on 08/07/18.
//  Copyright © 2018 Bharath. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ThreadManager.h"
#import "MyView.h"
@interface ViewController : NSViewController
@property ThreadManager* threadManager;
-(void) drawAxis;
-(void) drawGraph : (NSNotification*)note;
@property (strong) IBOutlet MyView *myView;

@end

