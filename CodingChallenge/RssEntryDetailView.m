//
//  RssEntryDetailView.m
//  	
//
//  Created by Iván Corchado Ruiz on 5/13/16.
//  Copyright © 2016 dgtl. All rights reserved.
//

#import "UIImageView+WebCache.h"
#import "RssEntryDetailView.h"
#import "UIColor+LWColors.h"

#define kImagePlaceholderString (@"placeholder")
#define kHeaderLabelHeight      (16)
#define kValueLabelHeight       (32)
#define kPadding                (16)

#define kLocStringTitle         NSLocalizedString(@"Title", @"Title")
#define kLocStringArtist        NSLocalizedString(@"Artist", @"Artist")
#define kLocStringCategory      NSLocalizedString(@"Category", @"Category")
#define kLocStringReleaseDate   NSLocalizedString(@"Release Date", @"Release Date")


@interface RssEntryDetailView()

@property (nonatomic, strong) UILabel           *titleHeader;
@property (nonatomic, strong) UILabel           *titleLabel;
@property (nonatomic, strong) UILabel           *artistHeader;
@property (nonatomic, strong) UILabel           *artistLabel;
@property (nonatomic, strong) UILabel           *dateHeader;
@property (nonatomic, strong) UILabel           *dateLabel;
@property (nonatomic, strong) UILabel           *categoryHeader;
@property (nonatomic, strong) UILabel           *categoryLabel;
@property (nonatomic, strong) UIImageView       *image;
@property (nonatomic, strong) UIView            *imageWrapperView;
@property (nonatomic, strong) UIView            *labelsWrapperView;
@property (nonatomic, strong) CAGradientLayer   *backgroundGradient;

@property (nonatomic, strong) RSSEntry          *rssEntry;

@end

@implementation RssEntryDetailView

- (void) layoutSubviews {
    [super layoutSubviews];
    
    CGFloat screenWidthMinusMargin  = CGRectGetWidth([_labelsWrapperView frame]) - (kPadding*2);
    CGRect artistLabelHeight = [[self artistLabel].text boundingRectWithSize:CGSizeMake(screenWidthMinusMargin, CGFLOAT_MAX)
                                                                     options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                                                  attributes:@{NSFontAttributeName:[self artistLabel].font}
                                                                     context:nil];
    CGRect titleLabelHeight = [[self titleLabel].text boundingRectWithSize:CGSizeMake(screenWidthMinusMargin, CGFLOAT_MAX)
                                                                   options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                                                attributes:@{NSFontAttributeName:[self titleLabel].font}
                                                                   context:nil];
    
    CGRect gradientFrame = [[self backgroundGradient] frame];
    gradientFrame.origin.x          = 0;
    gradientFrame.origin.y          = 0;
    gradientFrame.size.width        = CGRectGetWidth([self frame]);
    gradientFrame.size.height       = CGRectGetHeight([self frame]);
    [[self backgroundGradient] setFrame:gradientFrame];
    
    CGRect titleHeaderFrame         = [[self titleHeader] frame];
    titleHeaderFrame.origin.x       = kPadding;
    titleHeaderFrame.origin.y       = kPadding;
    titleHeaderFrame.size.width     = screenWidthMinusMargin;
    titleHeaderFrame.size.height    = kHeaderLabelHeight;
    [[self titleHeader] setFrame:titleHeaderFrame];
    
    CGRect titleLabelFrame          = [[self titleLabel] frame];
    titleLabelFrame.origin.x        = kPadding;
    titleLabelFrame.origin.y        = CGRectGetMaxY([_titleHeader frame]);
    titleLabelFrame.size.width      = screenWidthMinusMargin;
    titleLabelFrame.size.height     = CGRectGetHeight(titleLabelHeight);
    [[self titleLabel] setFrame:titleLabelFrame];
    
    CGRect artistHeaderFrame        = [[self artistHeader] frame];
    artistHeaderFrame.origin.x      = kPadding;
    artistHeaderFrame.origin.y      = CGRectGetMaxY([_titleLabel frame]) + kPadding;
    artistHeaderFrame.size.width    = screenWidthMinusMargin;
    artistHeaderFrame.size.height   = kHeaderLabelHeight;
    [[self artistHeader] setFrame:artistHeaderFrame];
    
    CGRect artistLabelFrame         = [[self artistLabel] frame];
    artistLabelFrame.origin.x       = kPadding;
    artistLabelFrame.origin.y       = CGRectGetMaxY([_artistHeader frame]);
    artistLabelFrame.size.width     = screenWidthMinusMargin;
    artistLabelFrame.size.height    = CGRectGetHeight(artistLabelHeight);
    [[self artistLabel] setFrame:artistLabelFrame];
    
    CGRect dateHeaderFrame          = [[self dateHeader] frame];
    dateHeaderFrame.origin.x        = kPadding;
    dateHeaderFrame.origin.y        = CGRectGetMaxY([_artistLabel frame]) + kPadding;
    dateHeaderFrame.size.width      = screenWidthMinusMargin;
    dateHeaderFrame.size.height     = kHeaderLabelHeight;
    [[self dateHeader] setFrame:dateHeaderFrame];
    
    CGRect dateLabelFrame           = [[self dateLabel] frame];
    dateLabelFrame.origin.x         = kPadding;
    dateLabelFrame.origin.y         = CGRectGetMaxY([_dateHeader frame]);
    dateLabelFrame.size.width       = screenWidthMinusMargin;
    dateLabelFrame.size.height      = CGRectGetHeight([_dateLabel frame]);
    [[self dateLabel] setFrame:dateLabelFrame];
    
    CGRect categoryHeaderFrame      = [[self categoryHeader] frame];
    categoryHeaderFrame.origin.x    = kPadding;
    categoryHeaderFrame.origin.y    = CGRectGetMaxY([_dateLabel frame]) + kPadding;
    categoryHeaderFrame.size.width  = screenWidthMinusMargin;
    categoryHeaderFrame.size.height = kHeaderLabelHeight;
    [_categoryHeader setFrame:categoryHeaderFrame];
    
    CGRect categoryLabelFrame       = [[self categoryLabel] frame];
    categoryLabelFrame.origin.x     = kPadding;
    categoryLabelFrame.origin.y     = CGRectGetMaxY([_categoryHeader frame]);
    categoryLabelFrame.size.width   = screenWidthMinusMargin;
    categoryLabelFrame.size.height  = CGRectGetHeight([_categoryLabel frame]);
    [_categoryLabel setFrame:categoryLabelFrame];
    
    [self animateWithDelay:0.1];
}

#pragma mark - Views

- (UIView *)labelsWrapperView {
    if (!_labelsWrapperView) {
        _labelsWrapperView = [[UIView alloc] initWithFrame:CGRectZero];
        [self addSubview:_labelsWrapperView];
        return _labelsWrapperView;
    }
    return _labelsWrapperView;
}

- (UIView *)imageWrapperView {
    if (!_imageWrapperView) {
        _imageWrapperView = [[UIView alloc] initWithFrame:CGRectZero];
        [[self imageWrapperView] setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.2]];
        [self addSubview:_imageWrapperView];
        return _imageWrapperView;
    }
    return _imageWrapperView;
}

- (UILabel *)titleHeader {
    if (!_titleHeader) {
        _titleHeader = [[UILabel alloc] init];
        [[self titleHeader] setTextColor:[UIColor detailHeaderColor]];
        [[self titleHeader] setText:[kLocStringTitle uppercaseString]];
        [[self titleHeader] setFont:[UIFont detailHeaderFont]];
        [[self labelsWrapperView] addSubview:_titleHeader];
        return _titleHeader;
    }
    return _titleHeader;
}

- (UILabel *)titleLabel{
    if (!_titleLabel){
        _titleLabel = [[UILabel alloc] init];
        [[self titleLabel] setTextColor:[UIColor detailTitleColor]];
        [[self titleLabel] setNumberOfLines:3];
        [[self titleLabel] setFont:[UIFont detailTitleFont]];
        [[self labelsWrapperView] addSubview:_titleLabel];
        return _titleLabel;
    }
    return _titleLabel;
}

- (UILabel *)artistHeader {
    if (!_artistHeader) {
        _artistHeader = [[UILabel alloc] init];
        [[self artistHeader] setTextColor:[UIColor detailHeaderColor]];
        [[self artistHeader] setText:[kLocStringArtist uppercaseString]];
        [[self artistHeader] setFont:[UIFont detailHeaderFont]];
        [[self artistHeader] sizeToFit];
        [[self labelsWrapperView] addSubview:_artistHeader];
        return _artistHeader;
    }
    return _artistHeader;
}

- (UILabel *)artistLabel{
    if (!_artistLabel){
        _artistLabel = [[UILabel alloc] init];
        [[self artistLabel] setTextColor:[UIColor detailTitleColor]];
        [[self artistLabel] setNumberOfLines:0];
        [[self artistLabel] setFont:[UIFont detailTitleFont]];
        [[self labelsWrapperView] addSubview:_artistLabel];
        return _artistLabel;
    }
    return _artistLabel;
}

- (UILabel *)dateHeader {
    if (!_dateHeader) {
        _dateHeader = [[UILabel alloc] init];
        [[self dateHeader] setTextColor:[UIColor detailHeaderColor]];
        [[self dateHeader] setText:[kLocStringReleaseDate uppercaseString]];
        [[self dateHeader] setFont:[UIFont detailHeaderFont]];
        [[self dateHeader] sizeToFit];
        [[self labelsWrapperView] addSubview:_dateHeader];
        return _dateHeader;
    }
    return _dateHeader;
}

- (UILabel *)dateLabel{
    if (!_dateLabel){
        _dateLabel = [[UILabel alloc] init];
        [[self dateLabel] setTextColor:[UIColor detailTitleColor]];
        [[self dateLabel] setFont:[UIFont detailTitleFont]];
        [[self labelsWrapperView] addSubview:_dateLabel];
        return _dateLabel;
    }
    return _dateLabel;
}

- (UILabel *)categoryHeader {
    if (!_categoryHeader) {
        _categoryHeader = [[UILabel alloc] init];
        [[self categoryHeader] setTextColor:[UIColor detailHeaderColor]];
        [[self categoryHeader] setText:[kLocStringCategory uppercaseString]];
        [[self categoryHeader] setFont:[UIFont detailHeaderFont]];
        [[self categoryHeader] sizeToFit];
        [[self labelsWrapperView] addSubview:_categoryHeader];
        return _categoryHeader;
    }
    return _categoryHeader;
}

- (UILabel *)categoryLabel{
    if (!_categoryLabel){
        _categoryLabel = [[UILabel alloc] init];
        [[self categoryLabel] setTextColor:[UIColor detailTitleColor]];
        [[self categoryLabel] setFont:[UIFont detailTitleFont]];
        [[self labelsWrapperView] addSubview:_categoryLabel];
        return _categoryLabel;
    }
    return _categoryLabel;
}

- (UIImageView *)image {
    if (!_image) {
        _image = [[UIImageView alloc]init];
        [[self image] setBackgroundColor:[UIColor clearColor]];
        [[self image] setContentMode:UIViewContentModeScaleAspectFit];
        [[[self image] layer] setShadowOffset:CGSizeMake(0, 5)];
        [[[self image] layer] setShadowColor:[UIColor darkGrayColor].CGColor];
        [[[self image] layer] setShadowOpacity:0.3];
        [[[self image] layer] setShadowRadius:15.0];
        [[self imageWrapperView] addSubview:_image];
        return _image;
    }
    return _image;
}

- (CAGradientLayer *)backgroundGradient {
    if (!_backgroundGradient) {
        UIColor *topColor = [UIColor aquaGreen];
        UIColor *bottomColor = [UIColor themeTintColor];
        _backgroundGradient = [CAGradientLayer layer];
        [_backgroundGradient setColors:[NSArray arrayWithObjects: (id)topColor.CGColor, (id)bottomColor.CGColor, nil]];
        [[self layer] insertSublayer:_backgroundGradient atIndex:0];
        return _backgroundGradient;
    }
    return _backgroundGradient;
}

#pragma mark - Setters

-(void)setConfiguration:(SizeClass)configuration {
    _configuration = configuration;
}

- (void)setRssEntry:(RSSEntry *)rssEntry {
    _rssEntry = rssEntry;
    
    [[self titleLabel] setText:[[self rssEntry].name capitalizedString]];
    [[self artistLabel] setText:[[self rssEntry].artist capitalizedString]];
    
    [[self dateLabel] setText:[[self rssEntry].releaseDate capitalizedString]];
    [[self dateLabel] sizeToFit];
    
    [[self categoryLabel] setText:[[self rssEntry].category capitalizedString]];
    [[self categoryLabel] sizeToFit];
    
    NSURL *imageURL = [[NSURL alloc] initWithString:[self rssEntry].imageURL];
    [[self image] sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:kImagePlaceholderString]];
}

- (void)setViewsToInitialStateForAnimations {
    
    CGRect labelsViewFrame = [[self labelsWrapperView] frame];
    labelsViewFrame.origin.x    = -1000;
    [[self labelsWrapperView] setFrame:labelsViewFrame];
    
    CGRect imageViewFrame       = [[self imageWrapperView] frame];
    imageViewFrame.origin.x     = -1000;
    [[self imageWrapperView] setFrame:imageViewFrame];
}

#pragma mark - View Helper Methods

- (void)animateImageAtFirstLaunch {
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 * 10 * 1 ];
    rotationAnimation.duration = 0.5;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = 1;
    [[[self image] layer] addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

- (void)layoutPortrait {
    
    CGRect labelsViewFrame = [[self labelsWrapperView] frame];
    labelsViewFrame.origin.x    = 0;
    labelsViewFrame.origin.y    = 0;
    labelsViewFrame.size.width  = CGRectGetWidth([self frame]);
    labelsViewFrame.size.height = CGRectGetMaxY([[self categoryLabel] frame]) + kPadding;
    [[self labelsWrapperView] setFrame:labelsViewFrame];
    
    CGRect imageViewFrame       = [[self imageWrapperView] frame];
    imageViewFrame.origin.x     = 0;
    imageViewFrame.origin.y     = CGRectGetMaxY([[self labelsWrapperView] frame]);
    imageViewFrame.size.width   = CGRectGetWidth([[self labelsWrapperView] frame]);
    imageViewFrame.size.height  = CGRectGetHeight([self frame]) - CGRectGetMaxY([[self labelsWrapperView] frame]);
    [[self imageWrapperView] setFrame:imageViewFrame];
    
    CGRect imageFrame               = [[self image] frame];
    imageFrame.size.height          = CGRectGetHeight([[self imageWrapperView] frame]) * 0.5;
    imageFrame.size.width           = imageFrame.size.height;
    imageFrame.origin.x             = CGRectGetMidX([[self imageWrapperView] frame]) - (imageFrame.size.width/2);
    imageFrame.origin.y             = (CGRectGetHeight([[self imageWrapperView] frame]) / 2) - (imageFrame.size.height/2);
    [_image setFrame:imageFrame];
}

- (void)layoutLandscape {
    
    CGRect imageViewFrame       = [[self imageWrapperView] frame];
    imageViewFrame.origin.x     = 0;
    imageViewFrame.origin.y     = 0;
    imageViewFrame.size.width   = CGRectGetWidth([self frame]) * 0.25;
    imageViewFrame.size.height  = CGRectGetHeight([self frame]);
    [[self imageWrapperView] setFrame:imageViewFrame];
    
    CGRect labelsViewFrame      = [[self labelsWrapperView] frame];
    labelsViewFrame.origin.x    = CGRectGetMaxX([[self imageWrapperView] frame]);
    labelsViewFrame.origin.y    = 0;
    labelsViewFrame.size.width  = CGRectGetWidth([self frame]) - CGRectGetMaxX([[self imageWrapperView] frame]);
    labelsViewFrame.size.height = CGRectGetHeight([self frame]);
    [[self labelsWrapperView] setFrame:labelsViewFrame];
    
    CGRect imageFrame               = [[self image] frame];
    imageFrame.size.width           = CGRectGetWidth([[self imageWrapperView] frame]) * 0.5;
    imageFrame.size.height          = imageFrame.size.width;
    imageFrame.origin.x             = CGRectGetMidX([[self imageWrapperView] frame]) - (imageFrame.size.width/2);
    imageFrame.origin.y             = (CGRectGetHeight([[self imageWrapperView] frame]) / 2) - (imageFrame.size.height/2);
    [_image setFrame:imageFrame];
}

- (void)animateWithDelay:(double) delay {
    [_image setAlpha:0];
    [_imageWrapperView setAlpha:0];
    
    [UIView animateWithDuration:0.4 delay:delay usingSpringWithDamping:0.6 initialSpringVelocity:0.9 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [[self image] setAlpha:1];
        [[self imageWrapperView] setAlpha:1];
        
        if (_configuration == kSizeClassCompact) {
            [self layoutLandscape];
        } else {
            [self layoutPortrait];
        }
    } completion:nil];
}

@end
