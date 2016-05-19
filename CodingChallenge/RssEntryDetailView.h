//
//  RssEntryDetailView.h
//  	
//
//  Created by Iván Corchado Ruiz on 5/13/16.
//  Copyright © 2016 dgtl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RSSEntry.h"

typedef enum : NSUInteger {
    kDefault,
    kSizeClassCompact,
} SizeClass;

@interface RssEntryDetailView : UIView

@property (nonatomic, assign, readonly) SizeClass configuration;

-(void)setConfiguration:(SizeClass)configuration;
- (void)setViewsToInitialStateForAnimations;
- (void)animateImageAtFirstLaunch;
- (void)setRssEntry:(RSSEntry *) rssEntry;

@end
