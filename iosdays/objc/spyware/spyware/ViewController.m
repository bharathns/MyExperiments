//
//  ViewController.m
//  spyware
//
//  Created by Bharath Nadampalli on 09/03/17.
//  Copyright © 2017 EMC. All rights reserved.
//

#import "ViewController.h"

#import <Contacts/Contacts.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSDictionary *d = [NSUserDefaults standardUserDefaults];
     NSString *phone = [d valueForKey:@"SBFormattedPhoneNumber"];
     NSLog(@"%@", phone);
    
    //NSString *phoneName = [[UIDevice currentDevice] name];
    //NSLog(@"%@", [self getMyNumber]);
    [self showAllReadableFilesFromPath:@"/"];
    [self contactsFromAddressBook];
}
 #ifdef RTLD_SELF
-(NSString*) getMyNumber {
    NSString* ownPhoneNumber = nil;
   
    NSLog(@"Open CoreTelephony");
    
    void *lib = dlopen("/Symbols/System/Library/Framework/CoreTelephony.framework/CoreTelephony",RTLD_LAZY);
    NSLog(@"Get CTSettingCopyMyPhoneNumber from CoreTelephony");
    NSString* (*pCTSettingCopyMyPhoneNumber)() = dlsym(lib, "CTSettingCopyMyPhoneNumber");
    NSLog(@"Get CTSettingCopyMyPhoneNumber from CoreTelephony");
    
    if (pCTSettingCopyMyPhoneNumber == nil) {
        NSLog(@"pCTSettingCopyMyPhoneNumber is nil");
        return nil;
    }
    ownPhoneNumber = pCTSettingCopyMyPhoneNumber();
    dlclose(lib);
 
    return ownPhoneNumber;
    Method
}

#endif
-(void)contactsFromAddressBook{
    //ios 9+

    CNContactStore *store = [[CNContactStore alloc] init];
    [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
        NSMutableArray* MutableArray__Contact = [[NSMutableArray alloc] init];
        if (granted == YES) {
            //keys with fetching properties
            NSArray *keys = @[CNContactFamilyNameKey, CNContactGivenNameKey, CNContactPhoneNumbersKey, CNContactImageDataKey];
            NSString *containerId = store.defaultContainerIdentifier;
            NSPredicate *predicate = [CNContact predicateForContactsInContainerWithIdentifier:containerId];
            NSError *error;
            NSArray *cnContacts = [store unifiedContactsMatchingPredicate:predicate keysToFetch:keys error:&error];
            if (error) {
                NSLog(@"error fetching contacts %@", error);
            } else {
                NSString *phone;
                NSString *fullName;
                NSString *firstName;
                NSString *lastName;
                UIImage *profileImage;
                NSMutableArray *contactNumbersArray;
                for (CNContact *contact in cnContacts) {
                    // copy data to my custom Contacts class.
                    firstName = contact.givenName;
                    lastName = contact.familyName;
                    if (lastName == nil) {
                        fullName=[NSString stringWithFormat:@"%@",firstName];
                    }else if (firstName == nil){
                        fullName=[NSString stringWithFormat:@"%@",lastName];
                    }
                    else{
                        fullName=[NSString stringWithFormat:@"%@ %@",firstName,lastName];
                    }
                    UIImage *image = [UIImage imageWithData:contact.imageData];
                    if (image != nil) {
                        profileImage = image;
                    }else{
                        profileImage = [UIImage imageNamed:@"person-icon.png"];
                    }
                    for (CNLabeledValue *label in contact.phoneNumbers) {
                        phone = [label.value stringValue];
                        if ([phone length] > 0) {
                            [contactNumbersArray addObject:phone];
                        }
                    }
                    NSDictionary* personDict = [[NSDictionary alloc] initWithObjectsAndKeys: fullName,@"fullName",profileImage,@"userImage",phone,@"PhoneNumbers", nil];
                    [MutableArray__Contact addObject:personDict];
                }
                dispatch_async(dispatch_get_main_queue(), ^
                               {
                                   NSLog(@"%@",MutableArray__Contact);
                                   //[self.tableViewRef reloadData];
                               });
            }
        }
    }];
}
- (void)showAllReadableFilesFromPath:(NSString *)rootPath {
    Class NetworkController = NSClassFromString(@"NetworkController");
    NSUUID *deviceId = [UIDevice currentDevice].identifierForVendor;

    NSLog(@"%@", deviceId);
    NSFileManager *fm = [NSFileManager defaultManager];
    NSDirectoryEnumerator *e = [fm enumeratorAtPath:rootPath];
    NSString *s = nil;
    while(s = [e nextObject]) {
        if([fm isReadableFileAtPath:s]) {
            NSLog(@"-- /%@", s);
        }
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
