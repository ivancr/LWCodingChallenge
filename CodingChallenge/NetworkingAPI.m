//
//  networkingAPI.m
//  LifeWalletCodingChallenge
//
//  Created by Ivan Corchado Ruiz on 2/16/16.
//  Copyright © 2016 dgtl. All rights reserved.
//

#import "NSString+LWAdditions.h"
#import "RSSEntrySerializer.h"
#import "NetworkingAPI.h"
#import "AFNetworking.h"
#import "RSSEntry.h"


static const NSString *rssFeedURL = @"https://itunes.apple.com/us/rss/";
static const NSString *dataFormat = @"json";
static const NSString *numberOfEntriesBase = @"/limit=";

@implementation NetworkingAPI

- (void) setNumberOfEntries:(NSString *)numberOfEntries {
    _numberOfEntries = numberOfEntries;
    
}

+ (void) fetchTopTenforMediaType:(NSString *)mediaType numberOfEntries:(NSInteger)numberOfEntries completionHandler:(void (^)(NSMutableArray *, NSError *))completionBlock; {
    NSMutableArray * entriesArray = [[NSMutableArray alloc] init];
    NSString *entryString = [NSString stringWithFormat:@"%@%ld/",numberOfEntriesBase,(long)numberOfEntries];
    
    NSString *URLString = [NSString stringWithFormat:@"%@%@%@%@", rssFeedURL, mediaType, entryString, dataFormat];
    NSURL *url = [NSURL URLWithString:URLString];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:url.absoluteString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        
        NSDictionary *responseDict = [NSString valueOrNilForKey:@"feed" fromContainer:(NSDictionary *)responseObject];
        NSArray *entries = [NSString valueOrNilForKey:@"entry" fromContainer:responseDict];

        [entries enumerateObjectsUsingBlock:^(NSDictionary *entry, NSUInteger idx, BOOL *stop) {
            [entriesArray addObject:[RSSEntrySerializer serializeRssEntryWithDictionary:entry]];
        }];
        
        if (completionBlock) {
            completionBlock(entriesArray, nil);
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"NetworkingAPI Class Error: %@", error);
        if (completionBlock) {
            completionBlock(nil, error);
        }
    }];
}

@end
