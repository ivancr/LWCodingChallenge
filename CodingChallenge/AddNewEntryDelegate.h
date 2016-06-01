//
//  AddNewEntryDelegate.h
//  CodingChallenge
//
//  Created by Iván Corchado Ruiz on 5/25/16.
//  Copyright © 2016 Iván Corchado Ruiz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewEntryTableViewCell.h"

@protocol AddNewEntryDelegate <NSObject>

- (void)cellTextDidChange:(NSString *) string configuration:(NSUInteger) configuration;

@end
