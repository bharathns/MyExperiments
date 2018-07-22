//
//  ThreadManager.h
//  InsideRunLoopAnatomy
//
//  Created by Bharath on 10/07/18.
//  Copyright © 2018 Bharath. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ThreadManager : NSObject
@property NSMutableArray* threads;
-(void)schedule:(int)numberOfThreads;
-(void)stop;
@end
