//
//  MediaTypeCollectionCell.h
//  LifeWalletCodingChallenge
//
//  Created by Ivan Corchado Ruiz on 2/17/16.
//  Copyright © 2016 dgtl. All rights reserved.
//

#import "MainController.h"
#import <UIKit/UIKit.h>

@interface MediaTypeCollectionCell : UICollectionViewCell

- (void)setMediaTypeWithController:(MainController *)controller indexPath:(NSIndexPath *) indexPath;

@end
