//
//  RSSEntry.h
//  LifeWalletCodingChallenge
//
//  Created by Ivan Corchado Ruiz on 2/16/16.
//  Copyright © 2016 dgtl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RSSEntry : NSObject

@property (nonatomic, copy) NSString    *name;
@property (nonatomic, copy) NSString    *artist;
@property (nonatomic, copy) NSString    *imageURL;
@property (nonatomic, copy) NSString    *releaseDate;
@property (nonatomic, copy) NSString    *contentType;
@property (nonatomic, copy) NSString    *category;
@property (nonatomic, copy) NSString    *price;
@property (nonatomic, copy) UIImageView *image;

@end
