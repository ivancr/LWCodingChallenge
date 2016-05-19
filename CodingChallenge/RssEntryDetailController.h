//
//  RssEntryDetailControl.h
//  LifeWalletCodingChallenge
//
//  Created by Ivan Corchado Ruiz on 2/18/16.
//  Copyright © 2016 dgtl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RSSEntry.h"

@interface RssEntryDetailController : NSObject

@property (nonatomic, strong) RSSEntry *rssEntry;

+ (instancetype)instanceWithRssEntry: (RSSEntry *)entry;

@end
