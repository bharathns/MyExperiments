//
//  BNPreferences.m
//  dynamicSample
//
//  Created by Bharath Nadampalli on 14/03/17.
//  Copyright © 2017 EMC. All rights reserved.
//

#import "BNPreferences.h"
#import "PropertyInfo.h"
#import "NSString+Extensions.h"

#define SetBool  [[BNPreferences shared] setBool:bl forKey:propertyName];
#define SetDouble  [[BNPreferences shared] setDouble:dbl forKey:propertyName];
#define SetFloat  [[BNPreferences shared] setFloat:flt forKey:propertyName];
#define SetInteger  [[BNPreferences shared] setInteger:i forKey:propertyName];
#define SetObject   [[BNPreferences shared] setObject:value forKey:propertyName];
#define SetNSCodingObject \
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:value]; \
    [[BNPreferences shared] setObject:data forKey:propertyName];
#define SetURL  [[BNPreferences shared] setURL:value forKey:propertyName];

#define GetBool bl = [[BNPreferences shared] boolForKey:propertyName];
#define GetDouble dbl = [[BNPreferences shared] doubleForKey:propertyName];
#define GetFloat flt = [[BNPreferences shared] floatForKey:propertyName];
#define GetInteger i = [[BNPreferences shared] integerForKey:propertyName];
#define GetObject value = [[BNPreferences shared] objectForKey:propertyName];
#define GetNSCodingObject NSData* data = [[BNPreferences shared] objectForKey:propertyName];\
            value = [NSKeyedUnarchiver unarchiveObjectWithData:data];
#define GetURL  value = [[BNPreferences shared] URLForKey:propertyName];

@implementation BNPreferences
static NSMutableDictionary* dict;
static NSMutableArray* classArray;

+ (void)initialize
{
    if (self == [BNPreferences class]) {
        dict  = [[NSMutableDictionary alloc] init];
        classArray = [[NSMutableArray alloc] init];
    }
}

+ (NSUserDefaults*) shared {
    return [NSUserDefaults standardUserDefaults];
}

+ (BOOL)resolveInstanceMethod:(SEL)sel {
    NSString *selector = NSStringFromSelector(sel);
    NSString *key = [selector stringByReplacingOccurrencesOfString:@":" withString:@""];
    
    id class = [self class];
    if (class != [BNPreferences class]) {
        if ([classArray indexOfObject:class] == NSNotFound) {
            [BNPreferences enumeratePropertyList:class];
            [classArray addObject:class];
        }
        PropertyInfo* propInfo = [dict objectForKey:key];
        if (propInfo != nil && propInfo != NULL && [BNPreferences isValidType:propInfo.type])
            return YES;
        NSLog(@"property %@ is not supported", key);
    }
    return NO;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector
{
    NSString *sel = NSStringFromSelector(selector);
    NSString *key = [sel stringByReplacingOccurrencesOfString:@":" withString:@""];
    
    PropertyInfo* propInfo =  [dict objectForKey:[key lowercaseString]];
    char types[20];
    if (propInfo.isSetter) {
        sprintf(types, "v@:%c", [propInfo.type characterAtIndex:0]);
    } else {
        sprintf(types, "%c@:", [propInfo.type characterAtIndex:0]);
    }
    return [NSMethodSignature signatureWithObjCTypes:types];
}

- (void)forwardInvocation:(NSInvocation *)invocation
{
    NSString *key = [NSStringFromSelector([invocation selector]) stringByReplacingOccurrencesOfString:@":" withString:@""];
    PropertyInfo* propInfo =  [dict objectForKey:[key lowercaseString]];
    void* value = nil;
    unichar typeString = [propInfo.type characterAtIndex:0];
    NSString* propertyName = propInfo.name;
    BOOL returnValueSet = NO;
    if (propInfo.isSetter) {
        [invocation getArgument:&value atIndex:2];
        switch (typeString) {
            case _C_BOOL: {
                BOOL bl = (BOOL) value;
                SetBool
                break;
            }
            case _C_CHR: {
                BOOL bl = (BOOL) value;
                SetBool
                break;
            }
            case _C_INT: {
                NSInteger i = (NSInteger) value;
                SetInteger
                break;
            }
            case _C_LNG: {
                NSInteger i = (NSInteger) value;
                SetInteger
                break;
            }
            case _C_LNG_LNG: {
                NSInteger i = (NSInteger) value;
                SetInteger
                break;
            }
            case _C_FLT:{
                float flt = 0.0;
                [invocation getArgument:&flt atIndex:2];
                SetFloat
                break;
            }
            case _C_DBL:{
                double dbl = 0.00;
                [invocation getArgument:&dbl atIndex:2];
                SetDouble
                break;
            }
            case _C_ID:{
                NSString *className = [BNPreferences getType:propInfo.type];
                if ([className isEqualToString:@"NSString"] ||
                    [className isEqualToString:@"NSArray"] ||
                    [className isEqualToString:@"NSDictionary"] ||
                    [className isEqualToString:@"NSData"] ||
                    [className isEqualToString:@"NSDate"] ||
                    [className isEqualToString:@"NSNumber"]) {
                    SetObject
                    break;
                } else if([className isEqualToString:@"NSURL"]) {
                    SetURL
                    break;
                }else {
                    Class class = NSClassFromString(className);
                    if ([BNPreferences doesSupportNSCoding:class]) {
                        SetNSCodingObject
                        break;
                    }
                }
            }
        }
    } else {
        switch (typeString) {
            case _C_BOOL: {
                BOOL bl;
                GetBool
                value = (void*)&bl;
                break;
            }
            case _C_CHR:{
                BOOL bl;
                GetBool
                value = (void*)&bl;
                break;
            }
            case _C_INT: {
                NSInteger i;
                GetInteger
                value  = (void*)&i;
                break;
            }
            case _C_LNG:{
                NSInteger i;
                GetInteger
                value  = (void*)&i;
                break;
            }
            case _C_LNG_LNG:{
                NSInteger i;
                GetInteger
                value  = (void*)&i;
                break;
            }
            case _C_FLT:{
                float flt;
                GetFloat
                value = (void*)&flt;
                break;
            }
            case _C_DBL:{
                double dbl;
                GetDouble
                value = (void*)&dbl;
                break;
            }
            case _C_ID:{
                NSString *className = [BNPreferences getType:propInfo.type];
                if ([className isEqualToString:@"NSString"] ||
                    [className isEqualToString:@"NSArray"] ||
                    [className isEqualToString:@"NSDictionary"] ||
                    [className isEqualToString:@"NSData"] ||
                    [className isEqualToString:@"NSDate"] ||
                    [className isEqualToString:@"NSNumber"]) {
                    GetObject
                } else if([className isEqualToString:@"NSURL"]) {
                    GetURL
                }else {
                    Class class = NSClassFromString(className);
                    if ([BNPreferences doesSupportNSCoding:class]) {
                        GetNSCodingObject
                    }
                }
                [invocation setReturnValue:&value];
                returnValueSet = YES;
                break;
            }

        }

        if (value != NULL && !returnValueSet ) {
            [invocation setReturnValue:value];
        }
    }
}

+ (void)enumeratePropertyList:(Class) class
{
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList(class, &outCount);
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        [self buildPropertyTable:property];
    }
}

+(void) buildPropertyTable: (objc_property_t) property {
    NSString* getter =  [NSString  stringWithUTF8String:property_getName(property)];
    
    NSString* setter = [NSString stringWithFormat:@"set%@",[getter capitalizedString]];
    NSString* name = getter;
    
    NSString* propertyString  = [NSString  stringWithUTF8String:property_getAttributes(property)];
    NSArray* array = [propertyString componentsSeparatedByString:@","];
    BOOL isReadOnly = NO;
    NSString* type = @"";
    for (NSString* prop in array) {
        NSString* propType = [prop substringToIndex:1];
        if([propType isEqualToString:@"T"]) { // Property Type
            type = [prop substringFromIndex:1];
        }else if ([propType isEqualToString:@"G"]){ //Getter
            getter = [prop substringFromIndex:1];
        }
        else if ([propType isEqualToString:@"S"]){ //Setter
            setter = [prop substringFromIndex:1];
        }
        else if ([propType isEqualToString:@"R"]){ //ReadOnly
            isReadOnly = YES;
        }
    }
    
    if ([self isValidType:type] && !isReadOnly) {
        setter = [setter stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        setter = [setter stringByReplacingOccurrencesOfString:@":" withString:@""];
        [dict setObject:[[PropertyInfo alloc] initWithName:name type:type setter:YES] forKey:[setter lowercaseString]];
        [dict setObject:[[PropertyInfo alloc] initWithName:name type:type setter:NO] forKey:[getter lowercaseString]];
    }
}


+(BOOL) isValidType:(NSString*) type {
    unichar typestring  = [type characterAtIndex:0];
    switch (typestring) {
        case _C_BOOL:
            return YES;
        case _C_CHR:
            return YES;
        case _C_INT:
            return YES;
        case _C_LNG:
            return YES;
        case _C_LNG_LNG:
            return YES;
        case _C_FLT:
            return YES;
        case _C_DBL:
            return YES;
        case _C_ID:{
            NSString *className = [BNPreferences getType:type];
            if ([className isEqualToString:@"NSString"] ||
                [className isEqualToString:@"NSArray"] ||
                [className isEqualToString:@"NSDictionary"] ||
                [className isEqualToString:@"NSData"] ||
                [className isEqualToString:@"NSDate"] ||
                [className isEqualToString:@"NSNumber"] ||
                [className isEqualToString:@"NSURL"]) {
                return YES;
            } else {
                Class class = NSClassFromString(className);
                if ([BNPreferences doesSupportNSCoding:class]) {
                    return YES;
                }
            }
        }
        default:
            return NO;
    }
    return NO;
}

+(NSString*) getType:(NSString*) typestring {
    if ([typestring length] > 1) {
        return [typestring stringBetweenString:@"\"" andString:@"\""];
    }else {
        return [NSString stringWithFormat: @"%C", [typestring characterAtIndex:0]];
    }
}

+(BOOL) doesSupportNSCoding:(Class) class {
    if ([class conformsToProtocol:@protocol(NSCoding)]) {
        return YES;
    }
    return NO;
}
@end
