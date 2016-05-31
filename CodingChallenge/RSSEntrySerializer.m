//
//  RSSEntrySerializer.m
//  LifeWalletCondingChallenge
//
//  Created by Iván Corchado Ruiz on 5/16/16.
//  Copyright © 2016 dgtl. All rights reserved.
//

#import "NSString+LWAdditions.h"
#import "RSSEntrySerializer.h"
#import "AppDelegate.h"

NSString *const kLWNameKey          = @"name";
NSString *const kLWArtistKey        = @"artist";
NSString *const kLWImageURLKey      = @"imageURL";
NSString *const kLWReleaseDateKey   = @"releaseDate";
NSString *const kLWContentTypeKey   = @"contentType";
NSString *const kLWCategoryKey      = @"category";
NSString *const kLWPriceKey         = @"price";
NSString *const kLWRSSIdKey         = @"rssId";

NSString *const kLWRSSEntryKey      = @"RSSEntry";

@implementation RSSEntrySerializer

+ (void)serializeRssEntryWithDictionary:(NSDictionary *)dictionary mediaType:(NSString *) mediaType {
    NSManagedObjectContext *context = [self managedObjectContext];
    
    // Temp dictionaries to drill down levels in the JSON dictionary
    NSDictionary *levelOneDictionary;
    NSDictionary *levelTwoDictionary;
    NSArray *imageArray;
    NSString *tempString;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:kLWRSSEntryKey];
    
    levelOneDictionary  = [NSString valueOrNilForKey:@"id" fromContainer:dictionary];
    levelTwoDictionary  = [NSString valueOrNilForKey:@"attributes" fromContainer:levelOneDictionary];
    tempString          = [NSString valueOrNilForKey:@"im:id" fromContainer:levelTwoDictionary];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"rssId==%@",tempString];
    [request setPredicate:pred];
    NSError *error;
    RSSEntry *rssEntry = [[context executeFetchRequest:request error:&error] firstObject];
    if (!rssEntry) {
        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:kLWRSSEntryKey inManagedObjectContext:context];
        rssEntry = [[RSSEntry alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:context];
    }
    
    
    [rssEntry setValue:mediaType forKey:@"mediaType"];
    
    levelOneDictionary  = [NSString valueOrNilForKey:@"im:name" fromContainer:dictionary];
    tempString          = [NSString valueOrNilForKey:@"label" fromContainer:levelOneDictionary];
    [rssEntry setValue:tempString forKey:kLWNameKey];
    
    levelOneDictionary  = [NSString valueOrNilForKey:@"im:artist" fromContainer:dictionary];
    tempString          = [NSString valueOrNilForKey:@"label" fromContainer:levelOneDictionary];
    [rssEntry setValue:tempString forKey:kLWArtistKey];
    
    imageArray          = [NSString valueOrNilForKey:@"im:image" fromContainer:dictionary];
    levelOneDictionary  = [imageArray lastObject];
    tempString          = [NSString valueOrNilForKey:@"label" fromContainer:levelOneDictionary];
    [rssEntry setValue:tempString forKey:kLWImageURLKey];
    
    levelOneDictionary  = [NSString valueOrNilForKey:@"im:releaseDate" fromContainer:dictionary];
    levelTwoDictionary  = [NSString valueOrNilForKey:@"attributes" fromContainer:levelOneDictionary];
    tempString          = [NSString valueOrNilForKey:@"label" fromContainer:levelTwoDictionary];
    [rssEntry setValue:tempString forKey:kLWReleaseDateKey];
    
    levelOneDictionary  = [NSString valueOrNilForKey:@"id" fromContainer:dictionary];
    levelTwoDictionary  = [NSString valueOrNilForKey:@"attributes" fromContainer:levelOneDictionary];
    tempString          = [NSString valueOrNilForKey:@"im:id" fromContainer:levelTwoDictionary];
    [rssEntry setValue:tempString forKey:kLWRSSIdKey];
    
    levelOneDictionary  = [NSString valueOrNilForKey:@"im:contentType" fromContainer:dictionary];
    levelTwoDictionary  = [NSString valueOrNilForKey:@"attributes" fromContainer:levelOneDictionary];
    tempString          = [NSString valueOrNilForKey:@"label" fromContainer:levelTwoDictionary];
    
    if ([tempString isEqualToString:@"MZRssItemTypeIdentifier.Book"]) {
        [rssEntry setValue:@"Book" forKey:@"contentType"];
    } else {
        [rssEntry setValue:tempString forKey:kLWContentTypeKey];
    }
    
    levelOneDictionary  = [NSString valueOrNilForKey:@"category" fromContainer:dictionary];
    levelTwoDictionary  = [NSString valueOrNilForKey:@"attributes" fromContainer:levelOneDictionary];
    tempString          = [NSString valueOrNilForKey:@"label" fromContainer:levelTwoDictionary];
    [rssEntry setValue:tempString forKey:kLWCategoryKey];
    
    
    levelOneDictionary  = [NSString valueOrNilForKey:@"im:price" fromContainer:dictionary];
    tempString          = [NSString valueOrNilForKey:@"label" fromContainer:levelOneDictionary];
    
    if ([tempString isEqualToString:@"Get"]) {
        [rssEntry setValue:@"Free" forKey:@"price"];
    } else {
        [rssEntry setValue:tempString forKey:kLWPriceKey];
    }
    
    if ([rssEntry hasPersistentChangedValues]) {
        NSError *error;
        [context save:&error];
        if (error) {
            NSLog(@"Error in MediaTypeController fetchDataWithMediaType: %@",error);
        }
    }
}

+ (NSManagedObjectContext *)managedObjectContext {
    AppDelegate *appDelegate        = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = appDelegate.managedObjectContext;
    return context;
}

@end
