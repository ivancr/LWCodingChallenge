//
//  MainController.m
//  LifeWalletCodingChallenge
//
//  Created by Ivan Corchado Ruiz on 2/17/16.
//  Copyright © 2016 dgtl. All rights reserved.
//

#import "MainController.h"


#define kLocStringAudiobooks    NSLocalizedString(@"Top Audiobooks", @"Top Audiobooks")
#define kLocStringBooks         NSLocalizedString(@"Top Paid Books", @"Top Paid Books")
#define kLocStringiOSApps       NSLocalizedString(@"Top Paid iOS Apps", @"Top Paid iOS Apps")
#define kLocStringiTunesU       NSLocalizedString(@"Top iTunes U Collections", @"Top iTunes U Collections")
#define kLocStringMacApps       NSLocalizedString(@"Top Paid Mac Apps", @"Top Paid Mac Apps")
#define kLocStringPodcasts      NSLocalizedString(@"Top Podcasts", @"Top Podcasts")

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
        
        self.mediaTypesTitles = @{self.mediaTypes[0] : kLocStringAudiobooks,
                                  self.mediaTypes[1] : kLocStringBooks,
                                  self.mediaTypes[2] : kLocStringiOSApps,
                                  self.mediaTypes[3] : kLocStringiTunesU,
                                  self.mediaTypes[4] : kLocStringMacApps,
                                  self.mediaTypes[5] : kLocStringPodcasts};
    }
    return self;
}

@end