//
//  ViewController.m
//  InsideRunLoopAnatomy
//
//  Created by Bharath on 08/07/18.
//  Copyright © 2018 Bharath. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "CustomThread.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _threadManager = [[ThreadManager alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(drawGraph:)
                                                 name:@"DrawGraph"
                                               object:nil];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

}

- (IBAction)startRunLoop:(id)sender {
    [_threadManager schedule:3];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

int count =0;
-(void) addJob {
    AppDelegate* appDelegate  =  [[NSApplication sharedApplication] delegate];
    NSLog(@"%d : %@",count, [NSThread currentThread]);
    Job* job  = [[Job alloc] initWithNumber:count++];
    MyRunLoopContext* context = [appDelegate getContext];
    if(context != NULL) {
        MyRunLoopSource* source = [context source];
        [source addJob:job];
        
        int threadid  = 0;
        int jobNumber = [job jobNumber];
        int y = 53 + ((jobNumber)*50) + ((jobNumber)*3);
        int x = 203 + ((threadid)*50) + ((threadid)*3);
        CGRect cgRect = CGRectMake(x, y, 50, 50);
        NSValue* rect  = [NSValue valueWithRect:NSRectFromCGRect(cgRect)];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *userInfo =
            [NSDictionary dictionaryWithObject:rect forKey:@"drawRect"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"DrawGraph" object:nil userInfo:userInfo];
        });
    }
}

- (IBAction)stopRunLoop:(id)sender {
    [_threadManager stop];
}

- (IBAction)runJobs:(id)sender {
    AppDelegate* appDelegate  =  [[NSApplication sharedApplication] delegate];
    int jobCount = (int) [[[CustomThread sharedSource] jobQueue] count];
    int i=0;
    while(i<jobCount) {
        int sourceCount = 0;
        while(appDelegate->sourcesToPing.count>sourceCount){
            MyRunLoopContext* context = NULL;
            context = [appDelegate->sourcesToPing objectAtIndex:sourceCount];
            NSLog(@"sourceCount : %d",sourceCount);
            if(context != NULL) {
                [context.source signalRunLoop:context.runLoop];
            }
            sourceCount++;
            i++;
        }
    }
}

- (IBAction)addJobs:(id)sender {
    [self addJob];
}

-(void) drawGraph : (NSNotification*)note {
    NSDictionary* dict = (NSDictionary*)note.userInfo;
    NSValue* rect  = [dict objectForKey:@"drawRect"];
    [[[self myView] drawRects] addObject:rect];
    [[self myView] setNeedsLayout:YES];
    [[self myView] invalidateRestorableState];

    [[self myView] setNeedsDisplayInRect:[[self myView] frame]];
}

@end
