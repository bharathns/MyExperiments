//
//  Job.h
//  InsideRunLoopAnatomy
//
//  Created by Bharath on 09/07/18.
//  Copyright © 2018 Bharath. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Job : NSObject {
    
}
@property int jobNumber;
- (instancetype)initWithNumber:(int)number NS_DESIGNATED_INITIALIZER;
- (instancetype)init NS_UNAVAILABLE;
@end
