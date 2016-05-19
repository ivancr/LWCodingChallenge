//
//  RSSEntrySerializer.m
//  LifeWalletCondingChallenge
//
//  Created by Iván Corchado Ruiz on 5/16/16.
//  Copyright © 2016 dgtl. All rights reserved.
//

#import "NSString+LWAdditions.h"
#import "RSSEntrySerializer.h"

@implementation RSSEntrySerializer

+ (RSSEntry *)serializeRssEntryWithDictionary:(NSDictionary *)dictionary {
    
    RSSEntry *rssEntry = [[RSSEntry alloc] init];
    
    // Temp dictionaries to drill down levels in the JSON dictionary
    NSDictionary *levelOneDictionary;
    NSDictionary *levelTwoDictionary;
    NSArray *imageArray;
    
    levelOneDictionary = [NSString valueOrNilForKey:@"im:name" fromContainer:dictionary];
    rssEntry.name = [NSString valueOrNilForKey:@"label" fromContainer:levelOneDictionary];
    
    levelOneDictionary = [NSString valueOrNilForKey:@"im:artist" fromContainer:dictionary];
    rssEntry.artist = [NSString valueOrNilForKey:@"label" fromContainer:levelOneDictionary];
    
    imageArray = [NSString valueOrNilForKey:@"im:image" fromContainer:dictionary];
    levelOneDictionary = [imageArray lastObject];
    rssEntry.imageURL = [NSString valueOrNilForKey:@"label" fromContainer:levelOneDictionary];
    
    levelOneDictionary = [NSString valueOrNilForKey:@"im:releaseDate" fromContainer:dictionary];
    levelTwoDictionary = [NSString valueOrNilForKey:@"attributes" fromContainer:levelOneDictionary];
    rssEntry.releaseDate = [NSString valueOrNilForKey:@"label" fromContainer:levelTwoDictionary];
    
    levelOneDictionary = [NSString valueOrNilForKey:@"im:contentType" fromContainer:dictionary];
    levelTwoDictionary = [NSString valueOrNilForKey:@"attributes" fromContainer:levelOneDictionary];
    rssEntry.contentType = [NSString valueOrNilForKey:@"label" fromContainer:levelTwoDictionary];
    if ([rssEntry.contentType isEqualToString:@"MZRssItemTypeIdentifier.Book"]) {
        rssEntry.contentType = @"Book";
    }
    
    levelOneDictionary = [NSString valueOrNilForKey:@"category" fromContainer:dictionary];
    levelTwoDictionary = [NSString valueOrNilForKey:@"attributes" fromContainer:levelOneDictionary];
    rssEntry.category = [NSString valueOrNilForKey:@"label" fromContainer:levelTwoDictionary];
    
    levelOneDictionary = [NSString valueOrNilForKey:@"im:price" fromContainer:dictionary];
    rssEntry.price = [NSString valueOrNilForKey:@"label" fromContainer:levelOneDictionary];
    if ([rssEntry.price isEqualToString:@"Get"]) {
        rssEntry.price = @"Free";
    }
    
    return rssEntry;
}

@end
