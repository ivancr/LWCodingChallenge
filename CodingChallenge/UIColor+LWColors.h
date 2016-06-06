//
//  UIColor+LWColors.h
//  LifeWalletCodingChallenge
//
//  Created by Ivan Corchado Ruiz on 2/19/16.
//  Copyright © 2016 dgtl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (LWColors)

+ (UIColor *) themeTintColor;
+ (UIColor *) aquaGreen;
+ (UIColor *) detailTitleColor;
+ (UIColor *) detailHeaderColor;
+ (UIColor *) veryLightGray;

@end


@interface UIFont (LWFonts)

+ (UIFont *) collectionTitleFont;
+ (UIFont *) detailTitleFont;
+ (UIFont *) detailHeaderFont;
+ (UIFont *) cellMediaTypeNameFont;
+ (UIFont *) cellMediaTypeArtistFont;
+ (UIFont *) cellMediaTypeRankingFont;

@end
