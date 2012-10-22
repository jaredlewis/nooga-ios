//
//  FireplugDraw.h
//  fireplug-ios
//
//  Created by Jared Lewis on 10/19/12.
//  Copyright (c) 2012 Akimbo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FireplugDraw : NSObject


//Gradients
- (void)drawLinearGradientInContext:(CGContextRef)context withRect:(CGRect)rect andColors:(NSArray *)colors;
- (void)drawLinearGradientInContext:(CGContextRef)context withRect:(CGRect)rect andColors:(NSArray *)colors andLocations:(NSArray *)locations;

//Lines
- (void)drawLineInContext:(CGContextRef)context fromPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint withColor:(UIColor *)color andWidth:(float)width;
- (void)drawTopBorderInContext:(CGContextRef)context withRect:(CGRect)rect andColor:(UIColor *)color andWidth:(float)width;
- (void)drawBottomBorderInContext:(CGContextRef)context withRect:(CGRect)rect andColor:(UIColor *)color andWidth:(float)width;
- (void)drawLeftBorderInContext:(CGContextRef)context withRect:(CGRect)rect andColor:(UIColor *)color andWidth:(float)width;
- (void)drawRightBorderInContext:(CGContextRef)context withRect:(CGRect)rect andColor:(UIColor *)color andWidth:(float)width;
- (void)drawBorderInContext:(CGContextRef)context withRect:(CGRect)rect andColor:(UIColor *)color andWidth:(float)width;
@end
