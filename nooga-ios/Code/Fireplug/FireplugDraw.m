//
//  FireplugDraw.m
//  fireplug-ios
//
//  Created by Jared Lewis on 10/19/12.
//  Copyright (c) 2012 Akimbo. All rights reserved.
//

#import "FireplugDraw.h"

@implementation FireplugDraw

////////////////////////////////////////////////////////
//  Gradient Methods
////////////////////////////////////////////////////////
- (void)drawLinearGradientInContext:(CGContextRef)context withRect:(CGRect)rect andColors:(NSArray *)colors
{
    [self drawLinearGradientInContext:context withRect:rect andColors:colors andLocations:@[@0.0, @1.0]];
}

- (void)drawLinearGradientInContext:(CGContextRef)context withRect:(CGRect)rect andColors:(NSArray *)colors andLocations:(NSArray *)locations
{
    //Convert the locations
    CGFloat floatLocations[[locations count]];
    for (int i = 0; i < [locations count]; ++i) {
        floatLocations[i] = [[locations objectAtIndex:i] floatValue];
    }
    
    //Convert the colors to the components array
    NSMutableArray *colorComponents = [[NSMutableArray alloc] init];
    for (UIColor *color in colors) {
        int numComponents = CGColorGetNumberOfComponents(color.CGColor);
        if (numComponents == 4) {
            const CGFloat *components = CGColorGetComponents(color.CGColor);
            [colorComponents addObject:[NSNumber numberWithFloat:components[0]]];
            [colorComponents addObject:[NSNumber numberWithFloat:components[1]]];
            [colorComponents addObject:[NSNumber numberWithFloat:components[2]]];
            [colorComponents addObject:[NSNumber numberWithFloat:components[3]]];
        }
    }
    CGFloat floatColorComponents[[colorComponents count]];
    for (int i = 0; i < [colorComponents count]; ++i) {
        floatColorComponents[i] = [[colorComponents objectAtIndex:i] floatValue];
    }
    
    
    //Create the color space and gradient
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, floatColorComponents,
                                                                 floatLocations, [locations count]);
    
    //Create the starting and ending points
    CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
    
    
    //Draw the gradient
    CGContextSaveGState(context);
    CGContextAddRect(context, rect);
    CGContextClip(context);
    CGContextDrawLinearGradient (context, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(context);
    
    //Release elements
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}


/////////////////////////////////////////////////////////////////
//  Line Methods
/////////////////////////////////////////////////////////////////
- (void)drawLineInContext:(CGContextRef)context fromPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint withColor:(UIColor *)color andWidth:(float)width
{
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextSetLineWidth(context, width);
    CGContextMoveToPoint(context, fromPoint.x, fromPoint.y);
    CGContextAddLineToPoint(context, toPoint.x, toPoint.y);
    CGContextStrokePath(context);
}

- (void)drawTopBorderInContext:(CGContextRef)context withRect:(CGRect)rect andColor:(UIColor *)color andWidth:(float)width
{
    //Calculate the start point
    CGPoint startPoint = CGPointMake(0, 0);
    
    //Calculate the stop point
    CGPoint stopPoint = CGPointMake(0, rect.size.width);
    
    //Draw the line
    [self drawLineInContext:context fromPoint:startPoint toPoint:stopPoint withColor:color andWidth:width];
}

- (void)drawBottomBorderInContext:(CGContextRef)context withRect:(CGRect)rect andColor:(UIColor *)color andWidth:(float)width
{
    //Calculate the start point
    CGPoint startPoint = CGPointMake(0, rect.size.height);
    
    //Calculate the stop point
    CGPoint stopPoint = CGPointMake(rect.size.width, startPoint.y);
    
    //Draw the line
    [self drawLineInContext:context fromPoint:startPoint toPoint:stopPoint withColor:color andWidth:width];
}

- (void)drawLeftBorderInContext:(CGContextRef)context withRect:(CGRect)rect andColor:(UIColor *)color andWidth:(float)width
{
    //Calculate the start point
    CGPoint startPoint = CGPointMake(0, 0);
    
    //Calculate the stop point
    CGPoint stopPoint = CGPointMake(0, rect.size.height);
    
    //Draw the line
    [self drawLineInContext:context fromPoint:startPoint toPoint:stopPoint withColor:color andWidth:width];
}

- (void)drawRightBorderInContext:(CGContextRef)context withRect:(CGRect)rect andColor:(UIColor *)color andWidth:(float)width
{
    //Calculate the start point
    CGPoint startPoint = CGPointMake(rect.size.width, 0);
    
    //Calculate the stop point
    CGPoint stopPoint = CGPointMake(rect.size.width, rect.size.height);
    
    //Draw the line
    [self drawLineInContext:context fromPoint:startPoint toPoint:stopPoint withColor:color andWidth:width];
}

- (void)drawBorderInContext:(CGContextRef)context withRect:(CGRect)rect andColor:(UIColor *)color andWidth:(float)width
{
    
}

@end
