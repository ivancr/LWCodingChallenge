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

@interface RSSEntrySerializer : NSObject

+ (void)serializeRssEntryWithDictionary:(NSDictionary *)dictionary mediaType:(NSString *) mediaType;
+ (NSManagedObjectContext *)managedObjectContext;

@end
