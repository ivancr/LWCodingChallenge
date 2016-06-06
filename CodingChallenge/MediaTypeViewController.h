//
//  MediaTypeViewController.h
//  LifeWalletCodingChallenge
//
//  Created by Ivan Corchado Ruiz on 2/15/16.
//  Copyright © 2016 dgtl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RSSEntry.h"

@protocol MediaTypeDelegate;

@interface MediaTypeViewController : UIViewController <UISplitViewControllerDelegate>

@property (nonatomic, strong, readonly) NSString *mediaType;
@property (nonatomic, weak            ) id <MediaTypeDelegate> delegate;

- (void)setMediaType:(NSString *)mediaType;

@end

@protocol MediaTypeDelegate <NSObject>

- (void)selectedRSSEntry:(RSSEntry *)rssEntry;

@end