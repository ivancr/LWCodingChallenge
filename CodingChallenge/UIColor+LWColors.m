//
//  UIColor+LWColors.m
//  LifeWalletCodingChallenge
//
//  Created by Ivan Corchado Ruiz on 2/19/16.
//  Copyright © 2016 dgtl. All rights reserved.
//

#import "UIColor+LWColors.h"

@implementation UIColor (LWColors)

+ (UIColor *) themeTintColor {
    return [UIColor colorWithRed:51/255.0 green:160/255.0 blue:173/255.0 alpha:1.0];
}

+ (UIColor *) aquaGreen {
    return [UIColor colorWithRed:54/255.0f green:204/255.0 blue:165/255.0 alpha:1.0];
}

+ (UIColor *) detailTitleColor {
    return [UIColor whiteColor];
}

+ (UIColor *) detailHeaderColor {
    return [UIColor colorWithRed:59/255.0 green:93/255.0 blue:96/255.0 alpha:1.0];
}

+ (UIColor *) veryLightGray {
    return [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0];
}

@end


@implementation UIFont (LWFonts)

+ (UIFont *) collectionTitleFont {
    return [UIFont systemFontOfSize:17 weight:UIFontWeightLight];
}

+ (UIFont *) detailTitleFont {
    return [UIFont systemFontOfSize:22 weight: UIFontWeightThin];
}

+ (UIFont *) detailHeaderFont {
    return [UIFont systemFontOfSize:14 weight: UIFontWeightLight];
}

+ (UIFont *) cellMediaTypeNameFont {
    return [UIFont systemFontOfSize:17 weight:UIFontWeightLight];
}

+ (UIFont *) cellMediaTypeArtistFont {
    return [UIFont systemFontOfSize:15 weight:UIFontWeightLight];
}

+ (UIFont *) cellMediaTypeRankingFont {
    return [UIFont systemFontOfSize:13 weight:UIFontWeightMedium];
}

@end