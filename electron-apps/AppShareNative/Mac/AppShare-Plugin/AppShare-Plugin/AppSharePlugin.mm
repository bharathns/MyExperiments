//
//  AppShare_Plugin.cpp
//  AppShare-Plugin
//
//  Created by Bharath nadampalli on 2/3/21.
//

#include <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import <CoreGraphics/CGGeometry.h>
#import "CGSPrivate.h"
#include <iostream>
#include <AppKit/NSGraphics.h>
#include "AppSharePlugin.hpp"
#include "AppShare_PluginPriv.hpp"
extern "C" AXError _AXUIElementGetWindow(AXUIElementRef, CGSWindowID* out);
extern "C" AppSharePlugin* create_object()
{
  return new AppSharePlugin;
}

extern "C" void destroy_object(AppSharePlugin* object)
{
  delete object;
}


@interface WindowInfo : NSObject {
    AppSharePlugin    *plugin;
    NSArray<NSRunningApplication*>* windowList;
    CFArrayRef windowArray;
}
- (id)initWithMyClass:(AppSharePlugin *)aMyClass;
@end

@implementation WindowInfo
- (id)initWithMyClass:(AppSharePlugin *)aMyClass {
    if ((self = [super init])) {
        plugin = aMyClass;
    }
    return self;
}


-(NSArray<NSRunningApplication*>*) getWindowList {
    NSWorkspace * ws = [NSWorkspace sharedWorkspace];
    NSArray<NSRunningApplication*> *windowList = [ws runningApplications];
    return windowList;
}

-(CFArrayRef) getWindowListWithCFArray {
    return CGWindowListCopyWindowInfo(kCGWindowListOptionOnScreenOnly, kCGNullWindowID);;
}
@end

struct AppSharePluginImpl {
    WindowInfo *wrapped;
};

AppSharePlugin::AppSharePlugin():appSharePlugin(new AppSharePluginImpl) {
    appSharePlugin->wrapped = [[WindowInfo alloc] init];
}

AppSharePlugin::~AppSharePlugin() {
    delete appSharePlugin;
    cout<<"AppSharePlugin Destructor"<<endl;
}

vector<pair<unsigned long, std::string>> AppSharePlugin::getWindowList()
{
    vector<pair<unsigned long, std::string>> vect;
    set<pair<unsigned long, std::string>> windowSet;
    
    CFArrayRef array = [appSharePlugin->wrapped getWindowListWithCFArray];
    for (NSMutableDictionary* entry in (__bridge NSArray*)array) {
        NSString* ownerName = [entry objectForKey:(id)kCGWindowOwnerName];
        NSNumber* processIdentifier = [entry objectForKey:(id)kCGWindowOwnerPID];
        NSInteger windowId = [[entry objectForKey:(id)kCGWindowNumber] integerValue];
        NSString *inStr = [NSString stringWithFormat: @"%ld", (long)windowId];
        NSNumber* windowLayer = [entry objectForKey:(id)kCGWindowLayer];
        
        
        if (windowLayer.integerValue != 0)  continue;
        NSRunningApplication* app = [NSRunningApplication runningApplicationWithProcessIdentifier:(pid_t)processIdentifier.integerValue];
        if (app == nil) continue;
        string appWindowText = this->getWindowText((__bridge void*)app, windowId);
        pair<unsigned long, std::string> p = make_pair(windowId, string(ownerName.UTF8String).append(" - ").append(appWindowText));
        windowSet.insert(p);
    }
    std::copy(windowSet.begin(), windowSet.end(), std::back_inserter(vect));
    return vect;
};

BOOL CGImageWriteToFile(CGImageRef image, NSString *path) {
    CFURLRef url = (__bridge CFURLRef)[NSURL fileURLWithPath:path];
    CGImageDestinationRef destination = CGImageDestinationCreateWithURL(url, kUTTypeBMP, 1, NULL);
    if (!destination) {
        NSLog(@"Failed to create CGImageDestination for %@", path);
        return NO;
    }

    CGImageDestinationAddImage(destination, image, nil);

    if (!CGImageDestinationFinalize(destination)) {
        NSLog(@"Failed to write image to %@", path);
        CFRelease(destination);
        return NO;
    }

    CFRelease(destination);
    return YES;
}

std::string AppSharePlugin::getBase64ImageString(long windowId) {
    
    CGFloat inf = CGFloat(FP_INFINITE);
    CGRect null = CGRectMake(inf, inf, 0, 0);
    CGImageRef cgImage = CGWindowListCreateImage(null, kCGWindowListOptionIncludingWindow,
                                                 CGWindowID(windowId), kCGWindowImageBestResolution);
    NSString *str = @"/Users/bharathns/window.bmp";
    if (!CGImageWriteToFile(cgImage, str)) cout<<"failed to save"<<endl;
    if (cgImage == nil) return string("<empty>");
    NSBitmapImageRep *imageRep = [[NSBitmapImageRep alloc] initWithCGImage:cgImage];
    NSData *imageData = [imageRep representationUsingType:NSBitmapImageFileTypeBMP properties:nil];
    
    NSString *strBase64Image = [imageData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    return string([strBase64Image UTF8String]);
}

std::string AppSharePlugin::getCaptureOf(long windowId) {
    CFArrayRef array = [appSharePlugin->wrapped getWindowListWithCFArray];
    CGRect rect;
    for (NSMutableDictionary* entry in (__bridge NSArray*)array) {
        NSInteger winId = [[entry objectForKey:(id)kCGWindowNumber] integerValue];
        if (windowId == winId) {
            NSDictionary* rectDictionary = [entry objectForKey:(id)kCGWindowBounds];
            CGRectMakeWithDictionaryRepresentation((CFDictionaryRef)rectDictionary, &rect);
            break;
        }
    }
    return this->getBase64ImageString(windowId);
}

std::string AppSharePlugin::getWindowText(void* app, long windowId) {
    pid_t pid = [(__bridge NSRunningApplication*)app processIdentifier];

    // Check for accesibility permissions
    NSDictionary *options = @{(__bridge id)kAXTrustedCheckOptionPrompt: @YES};
    Boolean appHasPermission = AXIsProcessTrustedWithOptions(
                                 (__bridge CFDictionaryRef)options);
    if (!appHasPermission) {
       return ""; // we don't have accessibility permissions
    }
    
    // Get the accessibility element of application.
    AXUIElementRef appElem = AXUIElementCreateApplication(pid);
    if (!appElem) {
      return "";
    }

    // Get the window list
    CFArrayRef windowList;
    AXUIElementCopyAttributeValue(appElem, kAXWindowsAttribute, (CFTypeRef *)&windowList);
    
    if ((!windowList) || CFArrayGetCount(windowList)<1)
        return "";


    CFArrayRef applicationWindows = (CFArrayRef) windowList;
    NSInteger windowCount = CFArrayGetCount(applicationWindows);
    AXError result;
    CFTypeRef value;

    NSString* str;
    string strTitle = "";
    for (NSInteger i = 0; i < windowCount; i++) {
      AXUIElementRef windowElement = (AXUIElementRef)CFArrayGetValueAtIndex(applicationWindows, i);
      result = AXUIElementCopyAttributeValue(windowElement, kAXMinimizedAttribute, &value);
      if (result == kAXErrorSuccess && value && CFBooleanGetValue((CFBooleanRef)value) == NO) {
          CFStringRef title = NULL;
          AXUIElementCopyAttributeValue(windowElement, kAXTitleAttribute, (CFTypeRef*)&title);
          CGSWindowID winid;
          
          _AXUIElementGetWindow(windowElement, &winid);

          str = (__bridge NSString*)title;
          if ([str length] > 0 && winid == windowId) {
              strTitle = string(str.UTF8String);
              CFRelease(title);
              break;
          }
          if(title) CFRelease(title);
      }
    }
    CFRelease(appElem);
    return strTitle;
}
