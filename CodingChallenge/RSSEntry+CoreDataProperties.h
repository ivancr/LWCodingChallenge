//
//  RSSEntry+CoreDataProperties.h
//  CodingChallenge
//
//  Created by Iván Corchado Ruiz on 5/31/16.
//  Copyright © 2016 Iván Corchado Ruiz. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "RSSEntry.h"

NS_ASSUME_NONNULL_BEGIN

@interface RSSEntry (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *artist;
@property (nullable, nonatomic, retain) NSString *category;
@property (nullable, nonatomic, retain) NSString *contentType;
@property (nullable, nonatomic, retain) NSString *imageURL;
@property (nullable, nonatomic, retain) NSString *mediaType;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *price;
@property (nullable, nonatomic, retain) NSString *releaseDate;
@property (nullable, nonatomic, retain) NSString *rssId;
@property (nullable, nonatomic, retain) NSString *ranking;

@end

NS_ASSUME_NONNULL_END
