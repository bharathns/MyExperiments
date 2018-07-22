//
//  main.m
//  dynamicSample
//
//  Created by Bharath Nadampalli on 09/03/17.
//  Copyright © 2017 EMC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BNPreferences.h"
#define authorName = @"com.Author.name";

@interface Author : NSObject<NSCoding>
@property (retain) NSString* name;
@end

@implementation Author
- (instancetype)init:(NSString*) name
{
    self = [super init];
    if (self) {
        self.name = name;
        
    }
    return self;
}
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.name forKey:@"com.Author.name"];
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    self.name =  [aDecoder decodeObjectForKey:@"com.Author.name"];
    return self;
}
@end







@interface Book : BNPreferences
{
    NSMutableDictionary *data;
}
@property (nonatomic, assign) NSString *username;
@property (nonatomic, assign) NSArray *kids;
@property (nonatomic, assign) NSDictionary *address;
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, assign) BOOL isOK;
@property (nonatomic, assign, getter=handle, setter=become:) NSString *name;
@property (nonatomic, assign) NSData *data;
@property (nonatomic, assign) float height;
@property (nonatomic, assign) double tilt;
@property (nonatomic, assign) NSURL *site;
@property (nonatomic, assign) NSURLConnection *connection;  // Invalid object type
@property (nonatomic, retain) NSString *fruit;              // Invalid retain specifier
@property (nonatomic, assign) NSString *title;
@property (nonatomic, assign) NSDate *date;
@property (nonatomic, assign) NSNumber *number;
@property (nonatomic, assign) NSValue *value;
@property (nonatomic, readonly, assign) NSString *nickname;
@property (nonatomic, retain) Author* author;
@end

@implementation Book
@dynamic author;
@dynamic username;
@dynamic kids;
@dynamic address;
@dynamic age;
@dynamic isOK;
@dynamic name;
@dynamic data;
@dynamic height;
@dynamic tilt;
@dynamic site;
@dynamic connection;
@dynamic fruit;
@dynamic title;
@dynamic number;
@dynamic value;

- (id)init
{
    if ((self = [super init])) {
        data = [[NSMutableDictionary alloc] init];
        [data setObject:@"Tom Sawyer" forKey:@"title"];
        Author* author =  [[Author alloc] init:@"Mark Twain"];
        [data setObject:author forKey:@"author"];
    }
    return self;
}

- (void)dealloc
{
    [data release];
    [super dealloc];
}



@end

int main(int argc, char **argv)
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    NSArray *path = NSSearchPathForDirectoriesInDomains(
                                                        NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *folder = [path objectAtIndex:0];
    NSLog(@"Your NSUserDefaults are stored in this folder: %@/Preferences", folder);
    
    Book *book = [[Book alloc] init];
    Author *author = [[Author alloc] init:@"George Orwell"];
    
    book.username = @"labamba";
    book.title = @"Jithin3";
    book.isOK = YES;
    book.age =  20;
    book.height = 5.7;
    book.tilt = 0.00000042;
    book.kids = @[@"jack", @"jill"];
    book.address = @{@"street": @"Main St", @"city": @"Venice"};
    book.number = @(23);
    book.site  =  [NSURL URLWithString:@"http://apple.com"];
    book.date = [NSDate date];
    book.value = [NSValue valueWithRange:NSMakeRange(0, 1)];
    book.data = [NSData dataWithBytes:"hello" length:5];
    [book become:@"GOD"];
    NSLog(@"username: %@",book.username);
    NSLog(@"title: %@",book.title);
    NSLog(@"isOK: %d",book.isOK);
    NSLog(@"age: %ld",(long)book.age);
    NSLog(@"height: %f",book.height);
    NSLog(@"tilt: %lf",book.tilt);
    NSLog(@"kids: %@",book.kids);
    NSLog(@"address: %@",book.address);
    NSLog(@"number: %@",book.number);
    NSLog(@"site: %@",book.site.absoluteString);
    NSLog(@"date: %@", book.date);
    NSLog(@"value: %@", book.value);
    NSLog(@"data: %@ : %lu", book.data, (unsigned long)book.data.length);
    NSLog(@"handle: %@", book.handle);

    return 0;
}
