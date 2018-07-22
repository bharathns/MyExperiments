//
//  Job.m
//  InsideRunLoopAnatomy
//
//  Created by Bharath on 09/07/18.
//  Copyright © 2018 Bharath. All rights reserved.
//

#import "Job.h"

@implementation Job
- (instancetype)initWithNumber:(int)number
{
    self = [super init];
    if (self) {
        _jobNumber  = number;
    }
    return self;
}
@end
