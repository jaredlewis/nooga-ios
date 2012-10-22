//
//  Utils.m
//  fireplug-ios
//
//  Created by Cory Walker on 7/17/12.
//  Copyright (c) 2012 Akimbo. All rights reserved.
//

#import "Utils.h"


void runOnMainThread(void (^block)(void))
{
    // this check avoids possible deadlock resulting from
    // calling dispatch_sync() on the same queue as current one
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    if (mainQueue == dispatch_get_current_queue()) {
        // execute code in place
        block();
    } else {
        // dispatch doStuff() to main queue
        dispatch_sync(mainQueue, block);
    }
}

void runOnMainThreadAsync(void (^block)(void))
{
    dispatch_async(dispatch_get_main_queue(), block);
}

void delayBlock(void (^block)(void), float delay)
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delay * NSEC_PER_SEC), dispatch_get_current_queue(), block);
}

void logFonts()
{
    NSArray *familyNames = [[NSArray alloc] initWithArray:[UIFont familyNames]];
    NSArray *fontNames;
    NSInteger indFamily, indFont;
    for (indFamily = 0; indFamily < [familyNames count]; ++indFamily) {
        NSLog(@"Family name: %@", [familyNames objectAtIndex:indFamily]);
        fontNames = [[NSArray alloc] initWithArray:
                     [UIFont fontNamesForFamilyName:
                      [familyNames objectAtIndex:indFamily]]];
        for (indFont = 0; indFont < [fontNames count]; ++indFont) {
            NSLog(@"    Font name: %@", [fontNames objectAtIndex:indFont]);
        }
    }
}
