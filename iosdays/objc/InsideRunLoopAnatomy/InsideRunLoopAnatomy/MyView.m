//
//  MyView.m
//  InsideRunLoopAnatomy
//
//  Created by Bharath on 10/07/18.
//  Copyright © 2018 Bharath. All rights reserved.
//

#import "MyView.h"

@implementation MyView

- (instancetype)init
{
    self = [super init];
    if (self) {
        _drawRects = [[NSMutableArray alloc] init];
    }
    
    return self;
}

-(instancetype)initWithFrame:(NSRect)frameRect{
    self  = [super initWithFrame:frameRect];
    if(self) {
        _drawRects = [[NSMutableArray alloc] init];
        //CGRect rect = CGRectMake(200, 50, 50, 50);
        //[_drawRects addObject:[NSValue valueWithRect:NSRectFromCGRect(rect)]];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if(self) {
        _drawRects = [[NSMutableArray alloc] init];
//        CGRect rect = CGRectMake(203, 53, 50, 50);
//        [_drawRects addObject:[NSValue valueWithRect:NSRectFromCGRect(rect)]];

    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    [self drawAxis];
    [self drawJobRect];
}


-(void) drawAxis {
    [self drawXAxis];
    [self drawYAxis];
}

-(void) drawXAxis {
    CGContextRef ctx =  (CGContextRef)[[NSGraphicsContext currentContext]graphicsPort];
    CGContextBeginPath(ctx);
    CGContextMoveToPoint(ctx, 200, 50);
    CGContextAddLineToPoint(ctx, 600, 50);
    CGContextSetLineWidth(ctx, 3);
    CGContextSetStrokeColorWithColor(ctx, [NSColor redColor].CGColor);
    CGContextStrokePath(ctx);
}

-(void) drawYAxis {
    CGContextRef ctx =  (CGContextRef)[[NSGraphicsContext currentContext]graphicsPort];
    CGContextBeginPath(ctx);
    CGContextMoveToPoint(ctx, 200, 50);
    CGContextAddLineToPoint(ctx, 200, 400
                            );
    CGContextSetLineWidth(ctx, 3);
    CGContextSetStrokeColorWithColor(ctx, [NSColor redColor].CGColor);
    CGContextStrokePath(ctx);
}

- (void) drawJobRect {

    for(NSValue* rect in _drawRects) {

        CGRect cgRect = NSRectToCGRect([rect rectValue]);
        CGContextRef ctx =  (CGContextRef)[[NSGraphicsContext currentContext]graphicsPort];
        CGContextBeginPath(ctx);
        CGContextAddRect(ctx, cgRect);
        CGContextSetLineWidth(ctx, 3);
        CGContextSetStrokeColorWithColor(ctx, [NSColor blueColor].CGColor);
        CGContextSetFillColorWithColor(ctx, [NSColor blueColor].CGColor);
        CGContextFillRect(ctx, cgRect);
        CGContextStrokePath(ctx);
    }
}
-(void)updateView {
    [self setNeedsDisplay:YES];
    [self setNeedsLayout:YES];
}
@end
