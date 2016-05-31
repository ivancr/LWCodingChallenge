//
//  networkingAPI.h
//  LifeWalletCodingChallenge
//
//  Created by Ivan Corchado Ruiz on 2/16/16.
//  Copyright © 2016 dgtl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkingAPI : NSObject

@property (nonatomic, strong, readonly) NSString *numberOfEntries;

+ (void) fetchTopTenforMediaType:(NSString *)mediaType numberOfEntries:(NSInteger)numberOfEntries completionHandler:(void (^)(NSArray *, NSError *))completionBlock;

@end
