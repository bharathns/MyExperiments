//
//  BNPreferences.h
//  dynamicSample
//
//  Created by Bharath Nadampalli on 14/03/17.
//  Copyright © 2017 EMC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface BNPreferences : NSObject

+(void)enumeratePropertyList:(Class) class;
+(void) buildPropertyTable: (objc_property_t) property;
+(BOOL) isValidType:(NSString*) type;
+(NSString*) getType:(NSString*) typestring;
+(BOOL) doesSupportNSCoding:(Class) class;
@end
