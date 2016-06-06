//
//  MediaTypeController.m
//  LifeWalletCodingChallenge
//
//  Created by Ivan Corchado Ruiz on 2/17/16.
//  Copyright © 2016 dgtl. All rights reserved.
//

#import "UIImageView+AFNetworking.h"
#import "MediaTypeController.h"
#import "RSSEntrySerializer.h"
#import "NetworkingAPI.h"
#import "AppDelegate.h"
#import "RSSEntry.h"

@implementation MediaTypeController

- (void) fetchDataWithMediaType:(NSString *)mediaType completion:(void (^)(NSError *error))completionBlock {

    [NetworkingAPI fetchTopTenforMediaType:mediaType numberOfEntries:30 completionHandler:^(NSArray *entries, NSError *error) {
        
        [entries enumerateObjectsUsingBlock:^(NSDictionary *entry, NSUInteger idx, BOOL *stop) {
            [RSSEntrySerializer serializeRssEntryWithDictionary:entry mediaType:mediaType ranking:[NSString stringWithFormat:@"%lu",(unsigned long)idx+1]];
        }];
        if (completionBlock) {
            completionBlock(error);
        }
    }];
}

- (NSUInteger)countForRSSEntries:(NSString *)mediaType {
    AppDelegate *appDelegate        = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = appDelegate.managedObjectContext;
    
    NSFetchRequest *request         = [NSFetchRequest fetchRequestWithEntityName:kLWRSSEntryKey];
    [request setPredicate:[self predicateWithMediaType:mediaType]];
    
    NSError *error;
    NSUInteger count = [context countForFetchRequest:request error:&error];
    if (error) {
        NSLog(@"Error in MediaTypeController countForRSSEntries: %@",error);
    }
    return count;
}

- (NSPredicate *)predicateWithMediaType:(NSString *)mediaType {
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"mediaType==%@", mediaType];
    return pred;
}

@end
