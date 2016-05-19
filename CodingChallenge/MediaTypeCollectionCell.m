//
//  MediaTypeCollectionCell.m
//  LifeWalletCodingChallenge
//
//  Created by Ivan Corchado Ruiz on 2/17/16.
//  Copyright © 2016 dgtl. All rights reserved.
//

#import "MediaTypeCollectionCell.h"
#import "UIColor+LWColors.h"

#define kPadding8px     ( 8.0f)
#define kPadding16px    (16.0f)

@interface MediaTypeCollectionCell()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *imageView;

@end


@implementation MediaTypeCollectionCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect labelHeight = [[self titleLabel].text boundingRectWithSize:CGSizeMake([self bounds].size.width - kPadding16px, CGFLOAT_MAX)
                                                                   options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                                                attributes:@{NSFontAttributeName:[self titleLabel].font}
                                                                   context:nil];
    
    CGRect imageFrame       = [[self imageView] frame];
    imageFrame.origin       = CGPointMake(kPadding8px, kPadding8px);
    imageFrame.size.width   = CGRectGetWidth([self frame]) - kPadding16px;
    imageFrame.size.height  = 100;
    [[self imageView] setFrame:imageFrame];
    
    
    CGRect labelFrame       = [[self titleLabel] frame];
    labelFrame.origin.x     = kPadding8px;
    labelFrame.origin.y     = CGRectGetMaxY([[self imageView] frame]) - kPadding8px;
    labelFrame.size.width   = CGRectGetWidth([self frame]) - kPadding16px;
    labelFrame.size.height  = labelHeight.size.height;//CGRectGetHeight([[self titleLabel] frame]);
    [[self titleLabel] setFrame:labelFrame];
}

#pragma mark - Views

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        [[self titleLabel] setTextColor:[UIColor themeTintColor]];
        [[self titleLabel] setTextAlignment:NSTextAlignmentCenter];
        [[self titleLabel] setFont:[UIFont collectionTitleFont]];
        [[self titleLabel] setNumberOfLines:0];
        [self addSubview:_titleLabel];
        return _titleLabel;
    }
    return _titleLabel;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        [[self imageView] setContentMode:UIViewContentModeScaleAspectFit];
        [self addSubview:_imageView];
        return _imageView;
    }
    return _imageView;
}


#pragma mark - Setter

- (void)setMediaTypeWithController:(MainController *)controller indexPath:(NSIndexPath *) indexPath{
    NSString *key = [controller.mediaTypes objectAtIndex:indexPath.row];
    [[self titleLabel] setText: [controller.mediaTypesTitles objectForKey:key]];
    //[[self titleLabel] sizeToFit];
    
    [[self imageView] setImage:[UIImage imageNamed:key]];
}

@end
