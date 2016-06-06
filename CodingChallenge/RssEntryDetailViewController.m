//
//  RssEntryDetailViewcontrol.m
//  LifeWalletCodingChallenge
//
//  Created by Ivan Corchado Ruiz on 2/15/16.
//  Copyright © 2016 dgtl. All rights reserved.
//

#import "RssEntryDetailViewController.h"
#import "UIImageView+AFNetworking.h"
#import "MediaTypeViewController.h"
#import "SplitRootViewController.h"
#import "RssEntryDetailView.h"
#import "UIColor+LWColors.h"

@interface RssEntryDetailViewController() <MediaTypeDelegate>

@property (nonatomic, strong) RssEntryDetailView    *detailView;

@end

@implementation RssEntryDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[self view] setBackgroundColor:[UIColor themeTintColor]];
    [[self detailView] setViewsToInitialStateForAnimations];
    [[self detailView] animateImageAtFirstLaunch];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    CGRect detailViewFrame      = [[self detailView] frame];
    detailViewFrame.origin.x    = 0;
    detailViewFrame.origin.y    = CGRectGetMaxY([[self navigationController] navigationBar].frame);
    detailViewFrame.size.width  = CGRectGetWidth([[self view] frame]);
    detailViewFrame.size.height = CGRectGetHeight([[self view] frame]) - detailViewFrame.origin.y;
    [[self detailView] setFrame: detailViewFrame];
    
    if ([[self view] traitCollection].verticalSizeClass == UIUserInterfaceSizeClassCompact) {
        [[self detailView] setConfiguration:kSizeClassCompact];
    } else {
        [[self detailView] setConfiguration:kDefault];
    }
}

- (UIView *)detailView {
    if (!_detailView) {
        _detailView = [[RssEntryDetailView alloc] init];
        [[self view] addSubview:_detailView];
        return _detailView;
    }
    return _detailView;
}

#pragma mark - MediaTypeDelegate

- (void)selectedRSSEntry:(RSSEntry *)rssEntry {
    [self setTitle:rssEntry.contentType];
    [[self detailView] setRssEntry:rssEntry];
}

@end
