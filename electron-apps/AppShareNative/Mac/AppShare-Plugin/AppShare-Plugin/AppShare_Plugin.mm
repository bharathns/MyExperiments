//
//  AppShare_Plugin.cpp
//  AppShare-Plugin
//
//  Created by Bharath nadampalli on 2/3/21.
//

#include <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import <ScriptingBridge/ScriptingBridge.h>
#import "CGSPrivate.h"
#include <iostream>
#include <AppKit/NSGraphics.h>
#include "AppSharePlugin.hpp"
#include "AppShare_PluginPriv.hpp"
extern "C" AXError _AXUIElementGetWindow(AXUIElementRef, long* out);
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
    return CGWindowListCopyWindowInfo(kCGWindowListOptionOnScreenOnly, kCGNullWindowID);
}
@end


AppSharePlugin::AppSharePlugin() {
    nsWorkspaceObject =(__bridge void*) [[WindowInfo alloc] initWithMyClass:this];
}

vector<pair<unsigned long, std::string>> AppSharePlugin::getWindowList()
{
    vector<pair<unsigned long, std::string>> vect;
    set<pair<unsigned long, std::string>> windowSet;
    
    CFArrayRef array = [(__bridge WindowInfo*)this->nsWorkspaceObject getWindowListWithCFArray];
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
        pair<unsigned long, std::string> p = make_pair(windowId, string(ownerName.UTF8String).append(" - ").append(appWindowText).append(" : ").append(string([inStr UTF8String])));
        windowSet.insert(p);
    }
    std::copy(windowSet.begin(), windowSet.end(), std::back_inserter(vect));
    return vect;
};

std::string AppSharePlugin::getCaptureOf(unsigned long processId) {
    
    CFArrayRef array = [(__bridge WindowInfo*)this->nsWorkspaceObject getWindowListWithCFArray];
    NSUInteger count = CFArrayGetCount(array);
    
    
    for (NSUInteger i = 0; i < count; i++) {
        CFDictionaryRef app = (CFDictionaryRef)CFArrayGetValueAtIndex(array, i);
        NSString *windowName = (NSString *)CFDictionaryGetValue(app, kCGWindowName);
        NSString *ownerName = (NSString *)CFDictionaryGetValue(app, kCGWindowOwnerName);
        NSRunningApplication *runapp = [NSRunningApplication runningApplicationWithProcessIdentifier:(pid_t)processId];
        if(runapp == nil || [[[runapp executableURL] lastPathComponent] isEqual:@"Dock"]) continue;
        if ([ownerName length]) {
            long processIdentifier = (long)CFDictionaryGetValue(app, kCGWindowOwnerPID);
            long windowId = (long)CFDictionaryGetValue(app, kCGWindowNumber);
            
            pair<unsigned long, std::string> p;
            cout<<"WindowName : "<<windowName<<endl;
            if ( [windowName length]) {
                p = make_pair(processIdentifier, string([ownerName UTF8String]).append(" : ").append([windowName UTF8String]));
            } else {
                p = make_pair(processIdentifier, string([ownerName UTF8String]).append(" : ").append(std::to_string(windowId)));
            }
        }
    }
    return "";
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
    for (NSInteger i = 0; i < windowCount; i++) {
      AXUIElementRef windowElement = (AXUIElementRef)CFArrayGetValueAtIndex(applicationWindows, i);
      result = AXUIElementCopyAttributeValue(windowElement, kAXMinimizedAttribute, &value);
      if (result == kAXErrorSuccess && value && CFBooleanGetValue((CFBooleanRef)value) == NO) {
          CFStringRef title = NULL;
          AXUIElementCopyAttributeValue(windowElement, kAXTitleAttribute, (CFTypeRef*)&title);
          long winid;
          
          _AXUIElementGetWindow(windowElement, &winid);

          str = (__bridge NSString*)title;
          if ([str length] > 0 && winid == windowId) {
              CFRelease(title);
              break;
          }
          CFRelease(title);
      }
    }

    CFRelease(appElem);

    return string(str.UTF8String);
}

void AppShare_PluginPriv::HelloWorldPriv(const char * s) {
    std::cout << s << std::endl;
};

void AppShare_PluginPriv::HelloWorldPriv() {
    std::cout << "HelloWorld" << std::endl;
};

