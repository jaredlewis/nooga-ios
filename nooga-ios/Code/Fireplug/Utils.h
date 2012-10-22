//
//  Utils.h
//  fireplug-ios
//
//  Created by Cory Walker on 7/17/12.
//  Copyright (c) 2012 Akimbo. All rights reserved.
//

#import <Foundation/Foundation.h>

NSString *getHumanizedTime(NSString *dateString);
void runOnMainThread(void (^block)(void));
void runOnMainThreadAsync(void (^block)(void));
void delayBlock(void (^block)(void), float delay);
void logFonts();

//Testflight/mixpanel
enum {
    FireplugEventCheckpointSectionLogin = 0,
    FireplugEventCheckpointSectionRegister = 1,
    FireplugEventCheckpointSectionLeftMenu = 2,
    FireplugEventCheckpointSectionRightMenu = 3,
    FireplugEventCheckpointSectionBrowseFeeds = 4,
    FireplugEventCheckpointSectionSearch = 5,
    FireplugEventCheckpointSectionPlaylist = 6,
    FireplugEventCheckpointSectionMyStream = 7,
    FireplugEventCheckpointSectionSocialStream = 8,
    FireplugEventCheckpointSectionBookmarks = 9,
    FireplugEventCheckpointSectionArticle = 10,
    FireplugEventCheckpointSectionShare = 11,
    FireplugEventCheckpointSectionSettings = 12
};
typedef NSUInteger FireplugEventCheckpointSection;

void performEventCheckpoint(FireplugEventCheckpointSection section, NSString *action);
void performTestFlightCheckpoint(FireplugEventCheckpointSection section, NSString *action);
void performMixPanelEvent(FireplugEventCheckpointSection section, NSString *action);
void performMixPanelEventWithDictionary(FireplugEventCheckpointSection section, NSString *action, NSDictionary *options);
void performEventCheckpointWithDictionary(FireplugEventCheckpointSection section, NSString *action, NSDictionary *options);
NSString *getEventCheckpointName(FireplugEventCheckpointSection section, NSString *action);
