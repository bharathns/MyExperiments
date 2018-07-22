//
//  NSString+Extensions.m
//  dynamicSample
//
//  Created by Bharath Nadampalli on 14/03/17.
//  Copyright © 2017 EMC. All rights reserved.
//

#import "NSString+Extensions.h"

@implementation NSString (Extensions)
-(NSString*)stringBetweenString:(NSString*)start andString:(NSString *)end
{
    NSScanner* scanner = [NSScanner scannerWithString:self];
    [scanner setCharactersToBeSkipped:nil];
    [scanner scanUpToString:start intoString:NULL];
    if ([scanner scanString:start intoString:NULL]) {
        NSString* result = nil;
        if ([scanner scanUpToString:end intoString:&result]) {
            return result;
        }
    }
    return nil;
}

@end
