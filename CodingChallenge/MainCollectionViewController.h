//
//  MainCollectionViewController.h
//  LifeWalletCodingChallenge
//
//  Created by Ivan Corchado Ruiz on 2/17/16.
//  Copyright © 2016 dgtl. All rights reserved.
//

#import "MediaTypeViewController.h"
#import <UIKit/UIKit.h>

@interface MainCollectionViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) MediaTypeViewController   *mediaTypeVC;

@end
