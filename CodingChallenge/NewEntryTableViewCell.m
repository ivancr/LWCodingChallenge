//
//  NewEntryTableViewCell.m
//  CodingChallenge
//
//  Created by Iván Corchado Ruiz on 5/26/16.
//  Copyright © 2016 Iván Corchado Ruiz. All rights reserved.
//

#import "NewEntryTableViewCell.h"
#import "RSSEntrySerializer.h"
#import "UIColor+LWColors.h"
#import "RSSEntry.h"

#define kImagePlaceholderString (@"placeholder")
#define kLabelHeight            (32)
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
    textFieldFrame.size.width   = CGRectGetWidth([self bounds]) - (kPadding * 2);
    textFieldFrame.size.height  = kFieldHeight;
    textFieldFrame.origin.x     = kPadding;
    textFieldFrame.origin.y     = kPadding * 2;
    [[self textField] setFrame:textFieldFrame];
    
    CGRect labelFrame           = [[self label] frame];
    labelFrame.size.width       = CGRectGetWidth([[self label] bounds]);
    labelFrame.size.height      = kLabelHeight;
    if (!_textFieldIsEmpty || [[self textField] isEditing]) {
        labelFrame.origin.x     = CGRectGetMaxX([[self textField] frame]) - CGRectGetWidth([[self label] bounds]);
    } else {
        labelFrame.origin.x     = kPadding;
    }
    labelFrame.origin.y         = CGRectGetMinY([[self textField] frame]);
    [[self label] setFrame:labelFrame];
    
    CGRect fieldLineFrame       = [[self fieldLine] frame];
    fieldLineFrame.size.width   = CGRectGetWidth([[self textField] bounds]);
    fieldLineFrame.size.height  = 1.0f;
    fieldLineFrame.origin.x     = kPadding;
    fieldLineFrame.origin.y     = CGRectGetMaxY([[self textField] frame]) - 1;
    [[self fieldLine] setFrame:fieldLineFrame];
}

#pragma mark - Views

- (UILabel *)label {
    if (!_label) {
        _label = [[UILabel alloc] initWithFrame:CGRectZero];
        [_label setTextColor:[UIColor lightGrayColor]];
        switch (_cellConfiguration) {
            case kTitle:
                [_label setText:kLocStringTitle];
                break;
            case kArtist:
                [_label setText:kLocStringArtist];
                break;
            case kPrice:
                [_label setText:kLocStringPrice];
                break;
            default:
                [_label setText:kLocStringUnknown];
                break;
        }
        [_label setFont:[UIFont detailHeaderFont]];
        [_label sizeToFit];
        [self addSubview:_label];
        return _label;
    }
    return _label;
}

- (UITextField *)textField{
    if (!_textField){
        _textField = [[UITextField alloc] initWithFrame:CGRectZero];
        [_textField setDelegate:self];
        
        switch (_cellConfiguration) {
            case kPrice:
                [[self textField] setKeyboardType:UIKeyboardTypeDecimalPad];
                break;
            default:
                [[self textField] setKeyboardType:UIKeyboardTypeDefault];
                [[self textField] setAutocapitalizationType:UITextAutocapitalizationTypeWords];
                break;
        }
        
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

- (void)cellTextDidChange:(NSString *) string configuration:(NSUInteger) configuration {
    if ([[self delegate] respondsToSelector:@selector(cellTextDidChange: configuration:)]) {
        [[self delegate] cellTextDidChange:string configuration:self.cellConfiguration];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    CGRect labelFrame   = [[self label] frame];
    labelFrame.origin.x = CGRectGetMaxX([[self textField] frame]) - CGRectGetWidth([[self label] frame]);
    
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.2 initialSpringVelocity:0.4 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [[self label] setFrame:labelFrame];
        [[self label] setTextColor:[UIColor themeTintColor]];
    } completion:nil];
    
    if (_cellConfiguration == kPrice && _textFieldIsEmpty) {
        textField.text = @"$";
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([[[self textField] text] isEqualToString:@""] || [[[self textField] text] isEqualToString:@"$"] ) {
        _textFieldIsEmpty = YES;
        [[self textField] setText:@""];
        
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

- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (_cellConfiguration == kPrice && range.location == 0)  {
            return NO;
    }
    [self cellTextDidChange:[textField.text stringByReplacingCharactersInRange:range withString:string] configuration:[self cellConfiguration]];
    return YES;
}

@end
