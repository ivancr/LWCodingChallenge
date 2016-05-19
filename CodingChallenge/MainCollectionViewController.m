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
static NSString *navTitle = @"iTunes Store Top 10";

#define kLocStringBack        NSLocalizedString(@"Back", @"Back")

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
    
    CGRect collectionFrame      = [[self mediaTypesCollectionView] frame];
    collectionFrame.origin      = CGPointZero;
    collectionFrame.size.height = CGRectGetHeight([[self view] bounds]);
    collectionFrame.size.width  = CGRectGetWidth([[self view] bounds]);
    [[self mediaTypesCollectionView] setFrame:collectionFrame];
}

#pragma mark - Views

- (UICollectionView *)mediaTypesCollectionView {
    if (!_mediaTypesCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _mediaTypesCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        [_mediaTypesCollectionView setDataSource:self];
        [_mediaTypesCollectionView setDelegate:self];
        [_mediaTypesCollectionView setBackgroundColor:[[UIColor lightGrayColor] colorWithAlphaComponent:0.3]];
        [_mediaTypesCollectionView.collectionViewLayout invalidateLayout];
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

#pragma mark - Helper Methods

- (void)setUpTitles {
    [self setTitle:navTitle];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:kLocStringBack
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:nil
                                                                            action:nil];
}

@end
