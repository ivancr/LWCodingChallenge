//
//  NewEntryTableViewCell.m
//  CodingChallenge
//
//  Created by Iván Corchado Ruiz on 5/26/16.
//  Copyright © 2016 Iván Corchado Ruiz. All rights reserved.
//

#import "NewEntryTableViewCell.h"
#import "UIColor+LWColors.h"

#define kImagePlaceholderString (@"placeholder")
#define kLabelHeight            (16)
#define kFieldHeight            (32)
#define kPadding                (16)

#define kLocStringTitle         NSLocalizedString(@"Title", @"Title")
#define kLocStringArtist        NSLocalizedString(@"Artist", @"Artist")
#define kLocStringPrice         NSLocalizedString(@"Price", @"Price")
#define kLocStringUnknown       NSLocalizedString(@"Unknown", @"Unknown")

@interface NewEntryTableViewCell() <UITextFieldDelegate>

@property (nonatomic, strong) UILabel       *label;
@property (nonatomic, strong) UIView        *fieldLine;
@property (nonatomic, assign) BOOL          textFieldIsEmpty;
@property (nonatomic, strong) UIDynamicAnimator *animator;

@end

@implementation NewEntryTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _textFieldIsEmpty = YES;
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect textFieldFrame       = [[self textField] frame];
    textFieldFrame.size.width   = CGRectGetWidth([self frame]) - (kPadding * 2);
    textFieldFrame.size.height  = kFieldHeight;
    textFieldFrame.origin.x     = kPadding;
    textFieldFrame.origin.y     = kPadding * 2;
    [[self textField] setFrame:textFieldFrame];
    
    CGRect labelFrame           = [[self label] frame];
    labelFrame.size.width       = CGRectGetWidth([[self label] frame]);
    labelFrame.size.height      = kLabelHeight;
    if (!_textFieldIsEmpty || [[self textField] isEditing]) {
        labelFrame.origin.x     = CGRectGetMaxX([[self textField] frame]) - CGRectGetWidth([[self label] frame]);
    } else {
        labelFrame.origin.x     = kPadding;
    }
    labelFrame.origin.y         = CGRectGetMinY([[self textField] frame]);
    [[self label] setFrame:labelFrame];
    
    CGRect fieldLineFrame       = [[self fieldLine] frame];
    fieldLineFrame.size.width   = CGRectGetWidth([[self textField] frame]);
    fieldLineFrame.size.height  = 1.0f;
    fieldLineFrame.origin.x     = kPadding;
    fieldLineFrame.origin.y     = CGRectGetMaxY([[self textField] frame]) - 1;
    [[self fieldLine] setFrame:fieldLineFrame];
}

#pragma mark - Views

- (UILabel *)label {
    if (!_label) {
        _label = [[UILabel alloc] initWithFrame:CGRectZero];
        [[self label] setTextColor:[UIColor lightGrayColor]];
        switch (_cellConfiguration) {
            case kTitle:
                [[self label] setText:kLocStringTitle];
                break;
            case kArtist:
                [[self label] setText:kLocStringArtist];
                break;
            case kPrice:
                [[self label] setText:kLocStringPrice];
                break;
            default:
                [[self label] setText:kLocStringUnknown];
        }
        [[self label] setFont:[UIFont detailHeaderFont]];
        [[self label] sizeToFit];
        [self addSubview:_label];
        return _label;
    }
    return _label;
}

- (UITextField *)textField{
    if (!_textField){
        _textField = [[UITextField alloc] initWithFrame:CGRectZero];
        [[self textField] setDelegate:self];
        [self addSubview:_textField];
        return _textField;
    }
    return _textField;
}

- (UIView *)fieldLine{
    if (!_fieldLine){
        _fieldLine = [[UIView alloc] initWithFrame:CGRectZero];
        [_fieldLine setBackgroundColor:[UIColor themeTintColor]];
        [self addSubview:_fieldLine];
        return _fieldLine;
    }
    return _fieldLine;
}

#pragma mark - Selectors

- (void)setCellConfiguration:(CellType)cellConfiguration {
    _cellConfiguration = cellConfiguration;
}

- (void)cellTextDidChange:(NewEntryTableViewCell *) cell {
    if ([[self delegate] respondsToSelector:@selector(cellTextDidChange:)]) {
        [[self delegate] cellTextDidChange:cell];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    CGRect labelFrame   = [[self label] frame];
    labelFrame.origin.x = CGRectGetMaxX([[self textField] frame]) - CGRectGetWidth([[self label] frame]);
    
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [[self label] setFrame:labelFrame];
        [[self label] setTextColor:[UIColor themeTintColor]];
    } completion:nil];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self cellTextDidChange:self];
    
    if ([[[self textField] text] isEqualToString:@""]) {
        _textFieldIsEmpty = YES;
        CGRect labelFrame   = [[self label] frame];
        labelFrame.origin.x = kPadding;
        [UIView animateWithDuration:0.2 animations:^{
            [[self label] setAlpha:0];
            [[self label] setTextColor:[UIColor lightGrayColor]];
            
        } completion:^(BOOL finished) {
            [[self label] setFrame:labelFrame];
            [[self label] setAlpha:1];
        }];
    } else {
        _textFieldIsEmpty = NO;
    }
}

@end
