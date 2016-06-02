//
//  RSSEntryTableviewCell.m
//  LifeWalletCodingChallenge
//
//  Created by Ivan Corchado Ruiz on 2/18/16.
//  Copyright © 2016 dgtl. All rights reserved.
//

#import "MediaTypeViewController.h"
#import "RSSEntryTableviewCell.h"
#import "UIImageView+WebCache.h"
#import "UIColor+LWColors.h"


#define kImagePlaceholderString             (@"placeholder")
#define kPadding8px                         ( 8.0f)
#define kPadding16px                        (16.0f)

@interface RSSEntryTableviewCell()

@property (nonatomic, strong) UILabel       *entryArtist;
@property (nonatomic, strong) UILabel       *price;
@property (nonatomic, strong) UILabel       *rankingLabel;
@property (nonatomic, strong) UIImageView   *entryImageView;
@property (nonatomic, strong) UIView        *wrapperLabelsView;

@end

@implementation RSSEntryTableviewCell

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect selfFrame        = [self frame];
    CGRect entryImageFrame  = [[self entryImageView] frame];
    CGRect wrapperFrame     = [[self wrapperLabelsView] frame];
    CGFloat paddingForEditingMode;
    
    if ([self isEditing]) {
        paddingForEditingMode = 44;
    } else {
        paddingForEditingMode = 0;
    }
    
    if (_isSelected) {
        wrapperFrame.size.height    = CGRectGetHeight([[self entryName] bounds]) + CGRectGetHeight([[self entryArtist] bounds]) + kPadding8px ;
        wrapperFrame.size.width     = [self frame].size.width - kPadding16px - paddingForEditingMode;
        wrapperFrame.origin.x       = paddingForEditingMode + kPadding8px;
        wrapperFrame.origin.y       = kPadding8px;
        [[self wrapperLabelsView] setFrame:wrapperFrame];
        
        entryImageFrame.size.width  = 120;
        entryImageFrame.size.height = 120;
        entryImageFrame.origin.y    = CGRectGetMaxY([[self wrapperLabelsView] frame]) + kPadding16px;
        entryImageFrame.origin.x    = [self horizontallyCenteredFrameForChildFrame:entryImageFrame].origin.x;
        [[self entryImageView] setFrame:entryImageFrame];
        
    } else {
        entryImageFrame.size        = CGSizeMake(CGRectGetHeight(selfFrame), CGRectGetHeight(selfFrame));
        entryImageFrame.origin.x    = paddingForEditingMode;
        entryImageFrame.origin.y    = 0;
        [[self entryImageView] setFrame:entryImageFrame];
        
        wrapperFrame.size.height    = CGRectGetHeight([[self entryName] bounds]) + CGRectGetHeight([[self entryArtist] bounds]) + kPadding8px ;
        wrapperFrame.size.width     = [self frame].size.width - [[self entryImageView] bounds].size.width - kPadding16px  - paddingForEditingMode;
        wrapperFrame.origin.x       = CGRectGetMaxX([[self entryImageView] frame]) + kPadding8px;
        wrapperFrame.origin.y       = [self verticallyCenteredFrameForChildFrame:wrapperFrame].origin.y;
        [[self wrapperLabelsView] setFrame:wrapperFrame];
    }
    
    CGRect entryRankingFrame         = [[self rankingLabel] frame];
    entryRankingFrame.origin.x       = CGRectGetWidth([[self wrapperLabelsView] bounds]) - entryRankingFrame.size.width - kPadding8px;
    entryRankingFrame.origin.y       = 0;
    entryRankingFrame.size.height    = CGRectGetHeight([[self entryName] bounds]);
    [[self rankingLabel] setFrame:entryRankingFrame];
    
    CGRect entryNameFrame           = [[self entryName] frame];
    entryNameFrame.size.width       = CGRectGetMinX([[self rankingLabel] frame]) - kPadding8px;
    entryNameFrame.origin           = CGPointZero;
    [[self entryName] setFrame:entryNameFrame];
    
    
    CGRect entryPriceFrame         = [[self price] frame];
    entryPriceFrame.origin.x       = CGRectGetWidth([[self wrapperLabelsView] bounds]) - entryPriceFrame.size.width - kPadding8px;
    entryPriceFrame.origin.y       = CGRectGetMaxY([[self entryName] frame]) + kPadding8px;
    [[self price] setFrame:entryPriceFrame];
    
    CGRect entryArtistFrame     = [[self entryArtist] frame];
    entryArtistFrame.size.width = CGRectGetMinX([[self price] frame]) - kPadding8px;
    entryArtistFrame.origin.x   = 0;
    entryArtistFrame.origin.y   = CGRectGetMaxY([[self entryName] frame]) + kPadding8px;
    [[self entryArtist] setFrame:entryArtistFrame];
}

- (void)willTransitionToState:(UITableViewCellStateMask)state {
    if (state == UITableViewCellStateShowingEditControlMask && _isSelected) {
        [self setIsSelected:NO];
        [self setSelected:NO];
    }
}

#pragma mark - Getters

- (UIView *)wrapperLabelsView {
    if (!_wrapperLabelsView) {
        _wrapperLabelsView = [[UIView alloc] initWithFrame: CGRectZero];
        [self addSubview:_wrapperLabelsView];
        return _wrapperLabelsView;
    }
    return _wrapperLabelsView;
}

- (UILabel *)entryName {
    if (!_entryName) {
        _entryName = [[UILabel alloc] init];
        [_entryName setTextColor:[UIColor darkGrayColor]];
        [_entryName setTextAlignment:NSTextAlignmentLeft];
        [_entryName setFont:[UIFont cellMediaTypeNameFont]];
        [[self wrapperLabelsView] addSubview:_entryName];
        return _entryName;
    }
    return _entryName;
}

- (UILabel *)entryArtist {
    if (!_entryArtist) {
        _entryArtist = [[UILabel alloc] init];
        [_entryArtist setTextColor: [UIColor lightGrayColor]];
        [_entryArtist setTextAlignment: NSTextAlignmentLeft];
        [_entryArtist setFont: [UIFont cellMediaTypeArtistFont]];
        [[self wrapperLabelsView] addSubview:_entryArtist];
        return _entryArtist;
    }
    return _entryArtist;
}

- (UILabel *)price{
    if (!_price){
        _price = [[UILabel alloc] initWithFrame:CGRectZero];
        [_price setTextColor: [UIColor lightGrayColor]];
        [_price setTextAlignment: NSTextAlignmentRight];
        [_price setFont: [UIFont cellMediaTypeArtistFont]];
        [[self wrapperLabelsView] addSubview:_price];
        return _price;
    }
    return _price;
}

- (UILabel *)rankingLabel{
    if (!_rankingLabel){
        _rankingLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_rankingLabel setTextColor: [UIColor themeTintColor]];
        [_rankingLabel setTextAlignment: NSTextAlignmentRight];
        [_rankingLabel setFont: [UIFont cellMediaTypeRankingFont]];
        [[self wrapperLabelsView] addSubview:_rankingLabel];
        return _rankingLabel;
    }
    return _rankingLabel;
}

- (UIImageView *)entryImageView {
    if (!_entryImageView) {
        _entryImageView = [[UIImageView alloc] initWithFrame: CGRectZero];
        [_entryImageView setContentMode: UIViewContentModeScaleAspectFit];
        [self addSubview:_entryImageView];
        return _entryImageView;
    }
    return _entryImageView;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    [[self entryName]   setText: nil];
    [[self entryArtist] setText: nil];
    [[self price]       setText: nil];
    [[self rankingLabel]setText: nil];
    [[self entryImageView] setImage: nil];
}

#pragma mark - Setter

- (void)setRssEntry:(RSSEntry *)rssEntry {
    _rssEntry = rssEntry;
    
    [[self entryName] setText: rssEntry.name];
    [[self entryName] sizeToFit];
    
    [[self entryArtist] setText: rssEntry.artist];
    [[self entryArtist] sizeToFit];
    
    [[self price] setText:rssEntry.price];
    [[self price] sizeToFit];
    
    NSString *ranking = [NSString stringWithFormat:@"%d",[rssEntry.ranking intValue]];
    [[self rankingLabel] setText:[@"#" stringByAppendingString:ranking]];
    [[self rankingLabel] sizeToFit];
    
    NSURL *imageURL = [[NSURL alloc] initWithString:rssEntry.imageURL];
    [[self entryImageView] sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:kImagePlaceholderString]];
}

-(void)setIsSelected:(BOOL)isSelected {
    _isSelected = isSelected;
}

#pragma mark - Selectors

- (CGRect)verticallyCenteredFrameForChildFrame:(CGRect)childRect {
    CGRect myBounds     = [self bounds];
    childRect.origin.y  = (CGRectGetHeight(myBounds)/2) - (CGRectGetHeight(childRect)/2);
    return childRect;
}

- (CGRect)horizontallyCenteredFrameForChildFrame:(CGRect)childRect{
    CGRect viewBounds       = [self bounds];
    CGFloat listMinX        = CGRectGetMidX(viewBounds) - (CGRectGetWidth(childRect)/2);
    CGRect newChildFrame    = CGRectMake(listMinX,
                                      CGRectGetMinY(childRect),
                                      CGRectGetWidth(childRect),
                                      CGRectGetHeight(childRect));
    return CGRectIntegral(newChildFrame);
}

@end
