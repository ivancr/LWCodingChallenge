//
//  MainCollectionViewController.m
//  LifeWalletCodingChallenge
//
//  Created by Ivan Corchado Ruiz on 2/17/16.
//  Copyright © 2016 dgtl. All rights reserved.
//

#import "MainCollectionViewController.h"
#import "MediaTypeCollectionCell.h"
#import "MediaTypeViewController.h"
#import "MainController.h"

static NSString *reuseIdentifier = @"mediaTypeCell";

#define kLocStringBack          NSLocalizedString(@"Back", @"Back")
#define kLocStringNavTitle      NSLocalizedString(@"iTunes Store Top 10","iTunes Store Top 10")

#define kCellHeight             (150)
#define kCellSeparatorHeight    (  2)

@interface MainCollectionViewController ()

@property (nonatomic, strong) UICollectionView *mediaTypesCollectionView;
@property (nonatomic, strong) MainController *controller;

@end

@implementation MainCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.controller = [[MainController alloc] init];
    [[self mediaTypesCollectionView] registerClass:[MediaTypeCollectionCell class] forCellWithReuseIdentifier: reuseIdentifier];
    [self setUpTitles];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    [[self mediaTypesCollectionView] setFrame:[[self view] frame]];
}

#pragma mark - Views

- (UICollectionView *)mediaTypesCollectionView {
    if (!_mediaTypesCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _mediaTypesCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        [_mediaTypesCollectionView setDataSource:self];
        [_mediaTypesCollectionView setDelegate:self];
        [_mediaTypesCollectionView setBackgroundColor:[[UIColor lightGrayColor] colorWithAlphaComponent:0.3]];
        [[self view] addSubview:_mediaTypesCollectionView];
    }
    return _mediaTypesCollectionView;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self controller].mediaTypes.count;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MediaTypeCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    [cell setMediaTypeWithController:[self controller] indexPath:indexPath];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MediaTypeViewController *mediaTypeVC = [[MediaTypeViewController alloc] init];
    
    NSString *key = [[self controller].mediaTypes objectAtIndex:indexPath.row];
    [mediaTypeVC setTitle:[[self controller].mediaTypesTitles objectForKey:key]];
    [mediaTypeVC setMediaType:key];
    
    [[self navigationController] pushViewController:mediaTypeVC animated:YES];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((CGRectGetWidth([[self view] frame])/2)-1, kCellHeight);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return kCellSeparatorHeight;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsZero;
}

-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [[[self mediaTypesCollectionView] collectionViewLayout] invalidateLayout];
}

#pragma mark - Selectors

- (void)setUpTitles {
    [self setTitle:kLocStringNavTitle];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:kLocStringBack
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:nil
                                                                            action:nil];
}

@end
