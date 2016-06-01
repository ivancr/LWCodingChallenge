//
//  AddNewViewController.m
//  CodingChallenge
//
//  Created by Iván Corchado Ruiz on 5/24/16.
//  Copyright © 2016 Iván Corchado Ruiz. All rights reserved.
//

#import "NewEntryTableViewCell.h"
#import "AddNewViewController.h"
#import "AddNewEntryDelegate.h"
#import "RSSEntrySerializer.h"
#import "RSSEntry.h"

#define kLocStringNavTitle NSLocalizedString(@"New RSS Entry","New RSS Entry")

static NSString *kReuseIdentifier = @"newRSSEntryCell";

@interface AddNewViewController () <UITableViewDelegate, UITableViewDataSource, AddNewEntryDelegate>

@property (nonatomic, strong) UITableView       *tableView;
@property (nonatomic, strong) UIBarButtonItem   *doneBarButton;
@property (nonatomic, strong) UIBarButtonItem   *cancelBarButton;
@property (nonatomic, strong) RSSEntry          *rssEntry;
@property (nonatomic, strong) NSString          *mediaType;


@end

@implementation AddNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = kLocStringNavTitle;
    
    [[self tableView] registerClass:[NewEntryTableViewCell class] forCellReuseIdentifier:kReuseIdentifier];
    [[self navigationItem] setRightBarButtonItem:[self doneBarButton]];
    [[self navigationItem] setLeftBarButtonItem:[self cancelBarButton]];
}

- (void) viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    CGRect tableViewFrame       = [[self tableView] frame];
    tableViewFrame.origin.x     = 0;
    tableViewFrame.origin.y     = 0;
    tableViewFrame.size.width   = CGRectGetWidth([[self view] frame]);
    tableViewFrame.size.height  = CGRectGetHeight([[self view] frame]);
    [[self tableView] setFrame:tableViewFrame];
}

#pragma mark - Getters

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        [[self tableView] setDelegate:self];
        [[self tableView] setDataSource:self];
        [[self tableView] setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
        [[self tableView] setAutoresizingMask:(UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth)];
        [[self tableView] setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [[self view] addSubview:_tableView];
        return _tableView;
    }
    return _tableView;
}

- (UIBarButtonItem *)doneBarButton {
    if (!_doneBarButton) {
        _doneBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonTapped)];
        [[self doneBarButton] setEnabled:NO];
        return _doneBarButton;
    }
    return _doneBarButton;
}

- (UIBarButtonItem *)cancelBarButton {
    if (!_cancelBarButton) {
        _cancelBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonTapped)];
        return _cancelBarButton;
    }
    return _cancelBarButton;
}

- (RSSEntry *) rssEntry {
    if (!_rssEntry) {
        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:kLWRSSEntryKey inManagedObjectContext:[RSSEntrySerializer managedObjectContext]];
        _rssEntry = [[RSSEntry alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:[RSSEntrySerializer managedObjectContext]];
        return _rssEntry;
    }
    return _rssEntry;
}

#pragma mark - Setters

- (void)setMediaType:(NSString *)mediaType {
    _mediaType = mediaType;
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NewEntryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kReuseIdentifier];
    [cell setDelegate:self];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    switch (indexPath.row) {
        case 0:
            [cell setCellConfiguration:kTitle];
            break;
        case 1:
            [cell setCellConfiguration:kArtist];
            break;
        case 2:
            [cell setCellConfiguration:kPrice];
            break;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return kEmunCount;
}

#pragma mark - Selectors

- (void)doneButtonTapped {
    
    [[self rssEntry] setMediaType:_mediaType];
    [[self rssEntry] setRssId:[NSString stringWithFormat:@"%u",arc4random_uniform(100000)]];
    [[self rssEntry] setCategory:@"N/A"];
    [[self rssEntry] setReleaseDate:@"N/A"];
    [[self rssEntry] setImageURL:@"N/A"];
    [[self rssEntry] setContentType:@"N/A"];
    
    if ([[self rssEntry] hasPersistentChangedValues]) {
        NSError *error;
        [[RSSEntrySerializer managedObjectContext] save:&error];
        if (error) {
            NSLog(@"Error in MediaTypeController fetchDataWithMediaType: %@",error);
        }
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)cancelButtonTapped {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)cellTextDidChange:(NSString *) string configuration:(NSUInteger) configuration {
    switch (configuration) {
        case kTitle:
            [[self rssEntry] setName:string];
            break;
        case kArtist:
            [[self rssEntry] setArtist:string];
            break;
        case kPrice:
            [[self rssEntry] setPrice:string];
            break;
        default:
            break;
    }
    [[self doneBarButton] setEnabled:[self allTextFieldsAreFilled]];
}

- (BOOL)allTextFieldsAreFilled {

    bool nameIsEmpty    = ([[self rssEntry] name].length < 1);
    bool artistIsEmpty  = ([[self rssEntry] artist].length < 1);
    bool priceIsEmpty   = ([[self rssEntry] price].length < 2);

    return (!nameIsEmpty && !artistIsEmpty && !priceIsEmpty);
}

@end
