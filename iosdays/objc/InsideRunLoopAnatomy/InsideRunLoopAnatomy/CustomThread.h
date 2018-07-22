//
//  CustomThread.h
//  InsideRunLoopAnatomy
//
//  Created by Bharath on 08/07/18.
//  Copyright © 2018 Bharath. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyRunLoopSource.h"
@interface CustomThread : NSObject{
    
}
//@property  MyRunLoopSource* runLoopSource;
@property  BOOL  exitThread;
-(void) start;
-(void) stop;
+(MyRunLoopSource*)sharedSource;
@end
