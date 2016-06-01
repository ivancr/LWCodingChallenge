//
//  MediaTypeViewController.h
//  LifeWalletCodingChallenge
//
//  Created by Ivan Corchado Ruiz on 2/15/16.
//  Copyright © 2016 dgtl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MediaTypeViewController : UIViewController

@property (nonatomic, strong, readonly) NSString *mediaType;

- (void)setMediaType:(NSString *)mediaType;

@end
