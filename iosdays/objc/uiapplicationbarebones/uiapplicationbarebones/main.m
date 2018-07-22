//
//  main.m
//  uiapplicationbarebones
//
//  Created by Bharath on 04/07/18.
//  Copyright © 2018 Bharath. All rights reserved.
//

#include <limits.h>
#include <math.h>
#include <stdio.h>
#include <assert.h>
#include <objc/objc.h>
#include <objc/runtime.h>
#include <objc/message.h>
#include <objc/NSObjCRuntime.h>
#import <Cocoa/Cocoa.h>

bool stop = false;
@interface AppDelegate : NSObject<NSApplicationDelegate>
    -(NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender;
@end
@implementation AppDelegate
    -(NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender
    {
        stop = true;
        return NSTerminateCancel;
    }
@end

NSUInteger applicationShouldTerminate(id self, SEL _sel, id sender)
{
    NSLog(@"applicationShouldTerminate\n");
    stop = true;
    return 0;
}

@interface WindowDelegate : NSObject<NSWindowDelegate>
    -(void)windowWillClose:(NSNotification*)notification;
    -(NSButton*) getButton: (NSString*)string;
@end

@implementation WindowDelegate
-(void)windowWillClose:(NSNotification*)notification
{
    (void)notification;
        stop = true;
}

-(NSButton*) getButton : (NSString*) string {
    NSButton *myButton = [[NSButton alloc] initWithFrame:NSMakeRect(200, 200, 200, 25)];
    [myButton setTitle: string];
    [myButton setButtonType:NSMomentaryLightButton]; //Set what type button You want
    [myButton setBezelStyle:NSRoundedBezelStyle]; //Set what style You want
    [myButton setTarget:self];
    [myButton setAction:@selector(buttonPressed)];
    return myButton;
}

-(void)buttonPressed {
    NSLog(@"Button pressed!");
}
@end

@interface TextField : NSTextField
    - (void)textDidBeginEditing:(NSNotification *)notification;
@end

@implementation TextField
- (BOOL)textShouldBeginEditing:(NSText *)textObject {
    
    NSLog(@"textDidBeginEditing textobject : %@", textObject.string);
    return TRUE;
}
@end

void windowWillClose(id self, SEL _sel, id notification)
{
    NSLog(@"window will close\n");
        stop = true;
}

NSTextField* getTextField(NSString* string) {
    TextField* textField = [[TextField alloc] initWithFrame:NSMakeRect(200, 200, 200, 25)];
    [textField setStringValue:string];
    [textField setBezeled:NO];
    [textField setDrawsBackground:NO];
    [textField setEditable:YES];
    [textField setSelectable:YES];
    return textField;
}

NSEvent* getMessage() {
    return [NSApp nextEventMatchingMask:NSEventMaskAny untilDate:[NSDate distantPast] inMode:NSDefaultRunLoopMode dequeue:YES];
}


int main()
{
    @autoreleasepool
    {

        [NSApplication sharedApplication];
        [NSApp setActivationPolicy:NSApplicationActivationPolicyRegular];
        AppDelegate * appDelegate = [[AppDelegate alloc] init];

        [NSApp setDelegate:appDelegate];
        [NSApp finishLaunching];
        
        id menubar = [[NSMenu alloc] init];
        id appMenuItem = [[NSMenuItem alloc] init];
        [menubar addItem:appMenuItem];
        [NSApp setMainMenu:menubar];
        id appMenu = [[NSMenu alloc] init];
        id appName = [[NSProcessInfo processInfo] processName];
        id quitTitle = [@"Quit " stringByAppendingString:appName];
        id quitMenuItem = [[NSMenuItem alloc] initWithTitle:quitTitle action:@selector(terminate:) keyEquivalent:@"q"];
        [appMenu addItem:quitMenuItem];
        [appMenuItem setSubmenu:appMenu];
        
        id window = [[NSWindow alloc] initWithContentRect:NSMakeRect(0, 0, 500, 500) styleMask:NSWindowStyleMaskTitled | NSWindowStyleMaskClosable | NSWindowStyleMaskMiniaturizable | NSWindowStyleMaskResizable backing:NSBackingStoreBuffered defer:NO];

        [window setReleasedWhenClosed:NO];

        WindowDelegate * windowDelegate = [[WindowDelegate alloc] init];
        [window setDelegate:windowDelegate];
        NSView * contentView = [window contentView];
        NSButton* button  = [windowDelegate getButton:@"HelloWorld"];
        [contentView addSubview:button];

        [window cascadeTopLeftFromPoint:NSMakePoint(20,20)];
        [window setTitle:@"Bare Bones Sample"];
        
        [window makeKeyAndOrderFront:window];
        [window setAcceptsMouseMovedEvents:YES];

        [NSApp activateIgnoringOtherApps:YES];
        
        NSLog(@"entering runloop\n");
        //this loop is not required if [NSApp run] is called
        //[NSApp run] ends up calling [NSApp nextEventMatchingMask:NSEventMaskAny untilDate:[NSDate distantPast] inMode:NSDefaultRunLoopMode dequeue:YES]; which ends up calling CFRunLoopRun
        while(!stop )
        {
            NSEvent * event = getMessage();
            if(event)
            {
                NSEventType eventType = [event type];
                switch(eventType)
                {
                    case NSEventTypeMouseMoved:
                    case NSEventTypeLeftMouseDragged:
                    case NSEventTypeRightMouseDragged:
                    case NSEventTypeOtherMouseDragged:
                    {
                        NSLog(@"NSEventTypeOtherMouseDragged");
                        break;
                    }
                    case NSEventTypeLeftMouseDown:
                        NSLog(@"NSEventTypeLeftMouseDown\n");
                        break;
                    case NSEventTypeLeftMouseUp:
                        NSLog(@"NSEventTypeLeftMouseUp\n");
                        break;
                    case NSEventTypeRightMouseDown:
                        NSLog(@"NSEventTypeRightMouseDown\n");
                        break;
                    case NSEventTypeRightMouseUp:
                        NSLog(@"NSEventTypeRightMouseUp\n");
                        break;
                    case NSEventTypeOtherMouseDown:
                    {
                        NSInteger number = [event buttonNumber];
                        NSLog(@"NSEventTypeOtherMouseDown : %i\n", (int)number);
                        break;
                    }
                    case NSEventTypeOtherMouseUp:
                    {
                        NSInteger number = [event buttonNumber];
                        NSLog(@"NSEventTypeOtherMouseDown : %i\n", (int)number);
                        break;
                    }
                    case NSEventTypeScrollWheel:
                    {
                        CGFloat deltaX = [event scrollingDeltaX];
                        CGFloat deltaY = [event scrollingDeltaY];
    
                        NSLog(@"NSEventTypeScrollWheel %f %f\n", deltaX, deltaY);

                        break;
                    }
                    case NSEventTypeFlagsChanged:
                    {
                        break;
                    }
                    case NSEventTypeKeyDown:
                    {
                        NSString * inputText = [event characters];
                        const char * inputTextUTF8 = [inputText UTF8String];
                        uint16_t keyCode = [event keyCode];
                        NSLog(@"NSEventTypeKeyDown '%hu'\n", keyCode, inputTextUTF8);
                        break;
                    }
                    case NSEventTypeKeyUp:
                    {
                        uint16_t keyCode = [event keyCode];
                        
                        NSLog(@"NSEventTypeKeyUp %u\n", keyCode);
                        break;
                    }
                    default:
                        break;
                }
                // DispatchMessage
                [NSApp sendEvent:event];

                if(stop) //user clicks on quit button  break out
                    break;
                [NSApp updateWindows];
            }
        }
        NSLog(@"leaving runloop\n");
    }
    return 0;
}
