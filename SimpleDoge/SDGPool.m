//
//  SDGPool.m
//  SimpleDoge
//
//  Created by Adam McDonald on 3/25/14.
//  Copyright (c) 2014 Adam McDonald. All rights reserved.
//

#import "SDGPool.h"

@implementation SDGPool

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        self.hashRate = [dictionary[@"hashrate"] integerValue];
        self.roundShares = [dictionary[@"round_shares"] integerValue];
        self.workers = [dictionary[@"workers"] integerValue];
    }
    return self;
}

@end
