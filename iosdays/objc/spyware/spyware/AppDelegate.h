//
//  AppDelegate.h
//  spyware
//
//  Created by Bharath Nadampalli on 09/03/17.
//  Copyright © 2017 EMC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

