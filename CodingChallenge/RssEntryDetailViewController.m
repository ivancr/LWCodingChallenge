//
//  RssEntryDetailViewcontrol.m
//  LifeWalletCodingChallenge
//
//  Created by Ivan Corchado Ruiz on 2/15/16.
//  Copyright © 2016 dgtl. All rights reserved.
//

#import "RssEntryDetailViewController.h"
#import "UIImageView+AFNetworking.h"
#import "RssEntryDetailView.h"
#import "UIColor+LWColors.h"

@interface RssEntryDetailViewController()

@property (nonatomic, strong) RssEntryDetailView    *detailView;

@end

@implementation RssEntryDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:[self rssEntry].contentType];
    [[self view] setBackgroundColor:[UIColor themeTintColor]];
    
    [[self detailView] setRssEntry:_rssEntry];
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

#pragma mark - Setters

-(void)setRssEntry:(RSSEntry *)rssEntry {
    _rssEntry = rssEntry;
    [_detailView setRssEntry:_rssEntry];
}

@end
