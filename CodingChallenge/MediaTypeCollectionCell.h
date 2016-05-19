//
//  MediaTypeCollectionCell.h
//  LifeWalletCodingChallenge
//
//  Created by Ivan Corchado Ruiz on 2/17/16.
//  Copyright © 2016 dgtl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainController.h"

@interface MediaTypeCollectionCell : UICollectionViewCell

- (void)setMediaTypeWithController:(MainController *)controller indexPath:(NSIndexPath *) indexPath;

@end
