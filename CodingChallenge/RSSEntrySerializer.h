//
//  RSSEntrySerializer.h
//  LifeWalletCondingChallenge
//
//  Created by Iván Corchado Ruiz on 5/16/16.
//  Copyright © 2016 dgtl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RSSEntry.h"

extern NSString *const kLWRSSEntryKey;
extern NSString *const kLWContentTypeKey;
extern NSString *const kLWRanking;

@interface RSSEntrySerializer : NSObject

+ (void)serializeRssEntryWithDictionary:(NSDictionary *)dictionary mediaType:(NSString *) mediaType ranking:(NSString *)ranking;
+ (NSManagedObjectContext *)managedObjectContext;

@end
