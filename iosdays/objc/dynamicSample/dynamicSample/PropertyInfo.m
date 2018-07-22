//
//  PropertyInfo.m
//  dynamicSample
//
//  Created by Bharath Nadampalli on 14/03/17.
//  Copyright © 2017 EMC. All rights reserved.
//

#import "PropertyInfo.h"



@implementation PropertyInfo

- (id)initWithName:(NSString*)name type:(NSString*)type setter:(BOOL)setter {
    self = [super init];
    if (self) {
        _name = name;
        _type = type;
        _isSetter = setter;
    }
    return self;
}

@end
