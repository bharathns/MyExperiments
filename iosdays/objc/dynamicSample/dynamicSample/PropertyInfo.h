//
//  PropertyInfo.h
//  dynamicSample
//
//  Created by Bharath Nadampalli on 14/03/17.
//  Copyright © 2017 EMC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PropertyInfo : NSObject
- (id)initWithName:(NSString*)name type:(NSString*)type setter:(BOOL)setter;
@property (atomic, retain) NSString* name;
@property (atomic, assign) BOOL isSetter;
@property (atomic, assign) NSString* type;
@end
