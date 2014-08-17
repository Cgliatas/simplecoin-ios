//
//  SDGPool.m
//  SimpleCoin
//
//  Created by Adam McDonald on 3/25/14.
//  Copyright (c) 2014 Adam McDonald. All rights reserved.
//

#import "SCNPool.h"

@implementation SCNPool

//@property (assign) CGFloat dailyEstimate;
//@property (assign) CGFloat estimatedRoundPayout;

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        self.completedShares = [dictionary[@"completed_shares"] integerValue];
        self.estimatedSecondsRemaining = [dictionary[@"est_sec_remaining"] integerValue];
        self.hashRate = [dictionary[@"hashrate"] integerValue];
        self.roundDuration = [dictionary[@"round_duration"] integerValue];
        self.roundShares = [dictionary[@"round_shares"] integerValue];
        self.sharesToSolve = [dictionary[@"shares_to_solve"] integerValue];
        self.workers = [dictionary[@"workers"] integerValue];
    }
    return self;
}

@end
