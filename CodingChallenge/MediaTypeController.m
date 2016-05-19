//
//  MediaTypeController.m
//  LifeWalletCodingChallenge
//
//  Created by Ivan Corchado Ruiz on 2/17/16.
//  Copyright © 2016 dgtl. All rights reserved.
//

#import "MediaTypeController.h"
#import "NetworkingAPI.h"
#import "UIImageView+AFNetworking.h"
#import "RSSEntry.h"



@implementation MediaTypeController

- (void) fetchDataWithMediaType:(NSString *)mediaType completion:(void (^)(NSError *error))completionBlock {

    [NetworkingAPI fetchTopTenforMediaType:mediaType numberOfEntries:30 completionHandler:^(NSMutableArray *entriesArray, NSError *error) {
        self.rssEntries = entriesArray;
        
        if (completionBlock) {
            completionBlock(error);
        }
    }];
}


- (void) fetchOneRandomRSSEntryWithMediaType: (NSString *)mediaType completion:(void (^)(RSSEntry *, NSError *error))completionBlock {
    [NetworkingAPI fetchTopTenforMediaType:mediaType numberOfEntries:50 completionHandler:^(NSMutableArray *entriesArray, NSError *error) {
        RSSEntry *randomEntry = [RSSEntry new];
        randomEntry = [entriesArray objectAtIndex:arc4random_uniform(50)];
        
        if (completionBlock) {
            completionBlock(randomEntry, error);
        }
    }];
}

@end
