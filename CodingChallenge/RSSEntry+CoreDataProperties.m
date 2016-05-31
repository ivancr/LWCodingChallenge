//
//  RSSEntry+CoreDataProperties.m
//  CodingChallenge
//
//  Created by Iván Corchado Ruiz on 5/23/16.
//  Copyright © 2016 Iván Corchado Ruiz. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "RSSEntry+CoreDataProperties.h"

@implementation RSSEntry (CoreDataProperties)

@dynamic name;
@dynamic artist;
@dynamic imageURL;
@dynamic releaseDate;
@dynamic contentType;
@dynamic mediaType;
@dynamic category;
@dynamic price;
@dynamic rssId;

@end
