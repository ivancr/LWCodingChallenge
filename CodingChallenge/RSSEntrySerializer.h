//
//  RSSEntrySerializer.h
//  LifeWalletCondingChallenge
//
//  Created by Iván Corchado Ruiz on 5/16/16.
//  Copyright © 2016 dgtl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RSSEntry.h"

@interface RSSEntrySerializer : NSObject

+ (RSSEntry *)serializeRssEntryWithDictionary:(NSDictionary *)dictionary;

@end
