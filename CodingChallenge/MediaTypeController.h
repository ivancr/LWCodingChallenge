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

- (void) fetchDataWithMediaType: (NSString *)mediaType completion:(void (^)(NSError *error))completionBlock;
- (NSUInteger)countForRSSEntries:(NSString *)mediaType;
@end
