//
//  NewEntryTableViewCell.h
//  CodingChallenge
//
//  Created by Iván Corchado Ruiz on 5/26/16.
//  Copyright © 2016 Iván Corchado Ruiz. All rights reserved.
//

#import "AddNewEntryDelegate.h"
#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    kTitle,
    kArtist,
    kPrice,
    kEmunCount
} CellType;

@interface NewEntryTableViewCell : UITableViewCell

@property (nonatomic, weak)             id <AddNewEntryDelegate> delegate;
@property (nonatomic, assign, readonly) CellType        cellConfiguration;
@property (nonatomic, strong)           UITextField     *textField;


- (void)setCellConfiguration:(CellType)cellConfiguration;

@end