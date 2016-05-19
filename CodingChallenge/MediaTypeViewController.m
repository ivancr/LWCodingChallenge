//
//  MediaTypeViewController.m
//  LifeWalletCodingChallenge
//
//  Created by Ivan Corchado Ruiz on 2/15/16.
//  Copyright © 2016 dgtl. All rights reserved.
//

#import "RssEntryDetailViewController.h"
#import "UIImageView+AFNetworking.h"
#import "MediaTypeViewController.h"
#import "RSSEntryTableviewCell.h"
#import "MediaTypeController.h"
#import "UIColor+LWColors.h"
#import "RSSEntry.h"

static NSString *kReuseIdentifier = @"rssEntryCell";
static NSString *kImagePlaceholderString = @"placeholder";

#define kLocStringLoading   NSLocalizedString(@"Loading...", @"Loading...")
#define kLocStringOK        NSLocalizedString(@"OK", @"OK")
#define kLocStringError     NSLocalizedString(@"Error", @"Error")
#define kLocStringBadLuck   NSLocalizedString(@"Bad luck, try again later!", @"Bad luck, try again later!")
#define kLocStringTop10     NSLocalizedString(@"Top 10", @"Top 10")
#define kLocStringEdit      NSLocalizedString(@"Edit", @"Edit")
#define kLocStringDone      NSLocalizedString(@"Done", @"Done")

#define kCellHeight                 (66)
#define kPadding16px                (16)

@interface MediaTypeViewController()

@property (nonatomic, strong) MediaTypeController       *controller;
@property (nonatomic, strong) UITableView               *tableView;
@property (nonatomic, strong) UIButton                  *addNewButton;
@property (nonatomic, strong) UIActivityIndicatorView   *spinner;
@property (nonatomic, strong) UIView                    *spinnerView;
@property (nonatomic, strong) UILabel                   *spinnerLabel;
@property (nonatomic, strong) NSIndexPath               *editingIndexPath;
@property (nonatomic, strong) RSSEntryTableviewCell     *lastCellSelected;
@property (nonatomic, strong) UIBarButtonItem           *editBarButtonItem;
@property (nonatomic, strong) UIRefreshControl          *refreshControl;
@property (nonatomic, strong) NSMutableArray            *rowsDeletedArray;
@property (nonatomic, strong) UIVisualEffectView        *buttonBlurView;

@end

@implementation MediaTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _controller = [[MediaTypeController alloc] init];
    [self refreshControl];
    
    [[self tableView] registerClass:[RSSEntryTableviewCell class] forCellReuseIdentifier:kReuseIdentifier];
    [[self navigationItem] setRightBarButtonItem:[self editBarButtonItem]];
    [self loadTopTenRssFeeds];
    [self setUpTitles];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    CGRect tableViewFrame       = [[self tableView] frame];
    tableViewFrame.origin.x     = 0;
    tableViewFrame.origin.y     = 0;
    tableViewFrame.size.width   = CGRectGetWidth([[self view] frame]);
    tableViewFrame.size.height  = CGRectGetHeight([[self view] frame]);
    [[self tableView] setFrame:tableViewFrame];
    [[self spinnerView] setFrame:tableViewFrame];
    
    CGRect buttonFrame          = [[self addNewButton] frame];
    buttonFrame.size.width      = CGRectGetWidth([[self view] frame]);
    buttonFrame.size.height     = 50;
    buttonFrame.origin.x        = 0;
    buttonFrame.origin.y        = CGRectGetHeight([[self view] frame]) - buttonFrame.size.height;
    [[self addNewButton] setFrame:buttonFrame];
    [[self buttonBlurView] setFrame:buttonFrame];
    
    [_spinner setCenter:[self spinnerView].center];
    
    CGRect spinnerLabelFrame = [_spinner frame];
    spinnerLabelFrame.origin = CGPointMake(8, [self spinner].center.y-100);
    spinnerLabelFrame.size = CGSizeMake(CGRectGetWidth([[self view] frame]) - kPadding16px, CGRectGetHeight([[self spinnerLabel] frame]));
    [_spinnerLabel setFrame:spinnerLabelFrame];
}


#pragma mark - Views

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
        [_tableView setAutoresizingMask:(UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth)];
        [_tableView setAllowsSelectionDuringEditing:YES];
        [[self view] addSubview:_tableView];
        return _tableView;
    }
    return _tableView;
}

- (UIButton *)addNewButton{
    if (!_addNewButton){
        _addNewButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_addNewButton addTarget:self action:@selector(didTapAddNewEntry) forControlEvents:UIControlEventTouchUpInside];
        [_addNewButton setBackgroundColor:[[UIColor themeTintColor] colorWithAlphaComponent:0.6f]];
        [_addNewButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_addNewButton setTitle:@"Add New" forState:UIControlStateNormal];
        [[self view] insertSubview:_addNewButton aboveSubview:[self buttonBlurView]];
        return _addNewButton;
    }
    return _addNewButton;
}

- (UIVisualEffectView *)buttonBlurView{
    if (!_buttonBlurView) {
        UIVisualEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        _buttonBlurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        [[self buttonBlurView] setUserInteractionEnabled:NO];
        [[self view] addSubview:_buttonBlurView];
        return _buttonBlurView;
    }
    return _buttonBlurView;
}

- (UIView *)spinnerView {
    if (!_spinnerView) {
        _spinnerView = [[UIView alloc] init];
        [_spinnerView setBackgroundColor:[[UIColor lightGrayColor] colorWithAlphaComponent:0.2]];
        [_spinnerView setHidden:YES];
        [[self view] insertSubview:_spinnerView aboveSubview:_tableView];
        return _spinnerView;
    }
    return _spinnerView;
}

- (UIActivityIndicatorView *)spinner {
    if (!_spinner) {
        _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [_spinner setColor: [UIColor themeTintColor]];
        [[self spinnerView] addSubview:_spinner];
        return _spinner;
    }
    return _spinner;
}

- (UILabel *)spinnerLabel{
    if (!_spinnerLabel) {
        _spinnerLabel = [[UILabel alloc] init];
        [_spinnerLabel setText: kLocStringLoading];
        [_spinnerLabel setFont:[UIFont systemFontOfSize:32 weight:UIFontWeightThin]];
        [_spinnerLabel setTextAlignment:NSTextAlignmentCenter];
        [_spinnerLabel setTextColor:[UIColor themeTintColor]];
        [_spinnerLabel sizeToFit];
        [[self spinnerView] addSubview:_spinnerLabel];
        return _spinnerLabel;
    }
    return _spinnerLabel;
}

- (UIBarButtonItem *)editBarButtonItem {
    if (!_editBarButtonItem) {
        _editBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:kLocStringEdit
                                                              style:UIBarButtonItemStylePlain
                                                             target:self
                                                             action:@selector(didTapEditButton:)];
        return _editBarButtonItem;
    }
    return _editBarButtonItem;
}

- (UIRefreshControl *)refreshControl {
    if (!_refreshControl) {
        _refreshControl = [[UIRefreshControl alloc] init];
        _refreshControl.backgroundColor = [UIColor themeTintColor];
        _refreshControl.tintColor = [UIColor whiteColor];
        [_refreshControl addTarget:self
                            action:@selector(refreshCurrentList)
                  forControlEvents:UIControlEventValueChanged];
        [[self tableView] addSubview:self.refreshControl];
        [[self tableView] sendSubviewToBack:self.refreshControl];
        return _refreshControl;
    }
    return _refreshControl;
}

- (NSMutableArray *)rowsDeletedArray {
    if (!_rowsDeletedArray){
        _rowsDeletedArray = [[NSMutableArray alloc] init];
        return _rowsDeletedArray;
    }
    return _rowsDeletedArray;
}

#pragma mark - TableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self controller].rssEntries.count;
}

#pragma mark - TableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RSSEntryTableviewCell *cell = [tableView dequeueReusableCellWithIdentifier:kReuseIdentifier forIndexPath:indexPath];
//    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    [cell setTag:indexPath.row];
    
    [cell setRssEntry:[[self controller].rssEntries objectAtIndex:indexPath.row]];
    [cell setIsSelected:(_editingIndexPath == indexPath)];
    
    return cell;
     
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([_editingIndexPath isEqual: indexPath]) {
        return (kCellHeight * 2) + 80;
    }
    return kCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //_editingIndexPath = _editingIndexPath == indexPath ? nil : indexPath;
    RSSEntryTableviewCell *currentCell = [tableView cellForRowAtIndexPath:indexPath];
    
    // First time any cell is selected
    if (![_lastCellSelected isEqual:currentCell] && _editingIndexPath == nil) {
        
        [currentCell setIsSelected:YES];
        _lastCellSelected = currentCell;
        _editingIndexPath = indexPath;
    
    // Last Cell selected is the same now
    } else if (_lastCellSelected == currentCell) {
        
        [currentCell setIsSelected:NO];
        _editingIndexPath = nil;
        _lastCellSelected = nil;
    
    // A diffent cell selected while another cell is being selected
    } else if (![_lastCellSelected isEqual:currentCell] && _editingIndexPath != nil) {
        
        [_lastCellSelected setIsSelected:NO];
        [currentCell setIsSelected:YES];
        _lastCellSelected = currentCell;
        _editingIndexPath = indexPath;
    }
    
    [[self tableView] beginUpdates];
    [[self tableView] endUpdates];
    
//    [[self tableView] deselectRowAtIndexPath:indexPath animated:YES];
//    RssEntryDetailViewController *rssEntryVC = [[RssEntryDetailViewController alloc] init];
//    [rssEntryVC setRssEntry:[[self controller].rssEntries objectAtIndex:indexPath.row]];
//    
//    [self.navigationController pushViewController:rssEntryVC animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableview shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [[self rowsDeletedArray] addObject:indexPath];
        [[[self controller] rssEntries] removeObjectAtIndex:indexPath.row];
        
        [[self tableView] beginUpdates];
        [[self tableView] deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [[self tableView] endUpdates];
    }
}

#pragma mark - Selectors

- (void)setUpTitles {
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:kLocStringTop10
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:nil
                                                                            action:nil];
}

- (void) loadTopTenRssFeeds {
    [[self spinnerView] setHidden:NO];
    [[self spinner] startAnimating];
    [self spinnerLabel];
    
    [self.controller fetchDataWithMediaType:self.mediaType completion: ^ (NSError * error){
        if (error) {
            [self showAlertWithError:error];
        }
        [[self tableView] reloadData];
        [[self spinnerView] setHidden:YES];
        [[self spinner] stopAnimating];
    }];
}

- (void)refreshCurrentList {
    [[self refreshControl] beginRefreshing];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d, h:mm a"];
    NSString *title = [NSString stringWithFormat:@"Last update: %@", [formatter stringFromDate:[NSDate date]]];
    NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor whiteColor]
                                                                forKey:NSForegroundColorAttributeName];
    NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
    self.refreshControl.attributedTitle = attributedTitle;
    
    [[self controller] fetchDataWithMediaType:[self mediaType] completion: ^ (NSError * error){
        if (error) {
            [self showAlertWithError:error];
        } else {
            [[self tableView] reloadData];
            [[self rowsDeletedArray] removeAllObjects];
            [[self refreshControl] endRefreshing];
        }
    }];
}


- (void)didTapEditButton:(UIButton *)sender{
    [[self tableView] setEditing:![[self tableView] isEditing] animated:YES];
    
    if ([[self tableView] isEditing]) {
        _editBarButtonItem.title = kLocStringDone;
    } else {
        _editBarButtonItem.title = kLocStringEdit;
    }
}

- (void)didTapAddNewEntry {
    [[self controller] fetchOneRandomRSSEntryWithMediaType:[self mediaType] completion:^(RSSEntry *randomEntry, NSError *error) {
        if (error) {
            [self showAlertWithError:error];
        } else {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [[[self controller] rssEntries] insertObject:randomEntry atIndex:0];
            
            [[self tableView] beginUpdates];
            [[self tableView] insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
            [[self tableView] endUpdates];
        }
    }];
}


- (void)showAlertWithError: (NSError *)error {
    NSLog(@"Error: %@",error);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:kLocStringError message:kLocStringBadLuck preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:kLocStringOK style:UIAlertActionStyleDefault handler:nil]];
        
        [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:alert animated:YES completion:nil];
    });
}


@end
