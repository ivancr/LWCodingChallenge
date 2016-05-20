//
//  MediaTypeController.h
//  LifeWalletCodingChallenge
//
//  Created by Ivan Corchado Ruiz on 2/17/16.
//  Copyright © 2016 dgtl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RSSEntryTableviewCell.h"
#import <UIKit/UIKit.h>

@interface MediaTypeController : NSObject

@property (nonatomic, strong) NSMutableArray *rssEntries;

- (void) fetchDataWithMediaType: (NSString *)mediaType completion:(void (^)(NSError *error))completionBlock;
- (void) fetchOneRandomRSSEntryWithMediaType: (NSString *)mediaType completion:(void (^)(RSSEntry *, NSError *error))completionBlock;
@end
