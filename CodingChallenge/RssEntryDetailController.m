//
//  RssEntryDetailControl.m
//  LifeWalletCodingChallenge
//
//  Created by Ivan Corchado Ruiz on 2/18/16.
//  Copyright © 2016 dgtl. All rights reserved.
//

#import "RssEntryDetailController.h"

@implementation RssEntryDetailController

+ (instancetype)instanceWithRssEntry: (RSSEntry *)entry {
    RssEntryDetailController *controller = [[RssEntryDetailController alloc] init];
    
    controller.rssEntry = entry;
    
    return controller;
}

@end
