//
//  SDGUser.m
//  SimpleCoin
//
//  Created by Adam McDonald on 3/25/14.
//  Copyright (c) 2014 Adam McDonald. All rights reserved.
//

#import "SCNUser.h"

#import "SCNWorker.h"

@implementation SCNUser

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        self.dailyEstimate = [dictionary[@"daily_est"] floatValue];
        self.estimatedRoundPayout = [dictionary[@"est_round_payout"] floatValue];
        self.hashRate = [dictionary[@"last_10_hashrate"] floatValue];
        if (dictionary[@"round_shares"] && dictionary[@"round_shares"] != [NSNull null]) {
            self.roundShares = [dictionary[@"round_shares"] integerValue];
        }
        
        NSMutableArray *array = [NSMutableArray array];
        for (NSDictionary *workerDict in dictionary[@"workers"]) {
            SCNWorker *worker = [[SCNWorker alloc] initWithDictionary:workerDict];
            [array addObject:worker];
        }
        self.workers = array;
    }
    return self;
}

@end
