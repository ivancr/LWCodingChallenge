//
//  MainController.m
//  LifeWalletCodingChallenge
//
//  Created by Ivan Corchado Ruiz on 2/17/16.
//  Copyright © 2016 dgtl. All rights reserved.
//

#import "MainController.h"

@implementation MainController

- (id)init {
    self = [super init];
    if (self) {
        self.mediaTypes = @[@"topaudiobooks",
                            @"toppaidebooks",
                            @"toppaidapplications",
                            @"topitunesucollections",
                            @"toppaidmacapps",
                            @"toppodcasts"];
        
        self.mediaTypesTitles = @{self.mediaTypes[0] : NSLocalizedString(@"Top Audiobooks", @"Top Audiobooks"),
                                  self.mediaTypes[1] : NSLocalizedString(@"Top Paid Books", @"Top Paid Books"),
                                  self.mediaTypes[2] : NSLocalizedString(@"Top Paid iOS Apps", @"Top Paid iOS Apps"),
                                  self.mediaTypes[3] : NSLocalizedString(@"Top iTunes U Collections", @"Top iTunes U Collections"),
                                  self.mediaTypes[4] : NSLocalizedString(@"Top Paid Mac Apps", @"Top Mac Apps"),
                                  self.mediaTypes[5] : NSLocalizedString(@"Top Podcasts", @"Top Podcasts")};
        
    }
    return self;
}

@end
