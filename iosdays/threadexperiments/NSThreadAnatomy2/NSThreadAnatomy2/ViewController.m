//
//  ViewController.m
//  NSThreadAnatomy2
//
//  Created by Bharath Nadampalli on 22/02/17.
//  Copyright © 2017 EMC. All rights reserved.
//

#import "ViewController.h"
#import "ThreadFunctions.h"

@interface MyThread : NSThread

@end

@implementation MyThread
-(void)main {
    @autoreleasepool {
        NSLog(@"in My Thread");
        NSLog(@"%d", getThreadId());
    }
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (IBAction)clickStart:(id)sender {
    NSLog(@"Main Thread: %d", getThreadId());

    // 1st method of calling thread
    MyThread* obj = [[MyThread alloc] init];
    [obj start];
    
    //2nd method of using NSThread
    NSThread* obj1 = [[NSThread alloc] initWithTarget:self selector:@selector(backgroundPrint:) object:[NSNumber numberWithInt:10]];
    [obj1 start];
    
    //3rd method of creating a thread
    [NSThread detachNewThreadSelector:@selector(backgroundPrint:) toTarget:self withObject:[NSNumber numberWithInt:16]];
    
    //4th method
    [self performSelectorInBackground:@selector(backgroundPrint:) withObject:[NSNumber numberWithInt:22]];
    
}

-(void) backgroundPrint : (NSNumber*) number {
    for(int i =  [number intValue];i<=[number intValue]+5;i++) {
        NSLog(@"%d", i);
    }
    NSLog(@"%d", getThreadId());
}


@end
