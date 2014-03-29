//
//  SDGUser.h
//  SimpleDoge
//
//  Created by Adam McDonald on 3/25/14.
//  Copyright (c) 2014 Adam McDonald. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SDGUser : NSObject
@property (assign) CGFloat dailyEstimate;
@property (assign) CGFloat estimatedRoundPayout;
@property (assign) CGFloat hashRate;
@property (assign) NSInteger roundShares;
@property (nonatomic, strong) NSArray *workers;
- (id)initWithDictionary:(NSDictionary *)dictionary;
@end
