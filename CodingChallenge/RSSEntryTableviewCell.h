//
//  RSSEntryTableviewCell.h
//  LifeWalletCodingChallenge
//
//  Created by Ivan Corchado Ruiz on 2/18/16.
//  Copyright © 2016 dgtl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RSSEntry.h"

@interface RSSEntryTableviewCell : UITableViewCell

@property (nonatomic, strong, readonly) RSSEntry    *rssEntry;
@property (nonatomic, assign, readonly) BOOL        isSelected;
@property (nonatomic, strong) UILabel       *entryName;

- (void) setRssEntry:(RSSEntry *)rssEntry;
- (void)setIsSelected:(BOOL)isSelected;

@end
