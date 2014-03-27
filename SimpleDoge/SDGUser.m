//
//  SDGUser.m
//  SimpleDoge
//
//  Created by Adam McDonald on 3/25/14.
//  Copyright (c) 2014 Adam McDonald. All rights reserved.
//

#import "SDGUser.h"

#import "SDGWorker.h"

@implementation SDGUser

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        self.hashRate = [dictionary[@"last_10_hashrate"] floatValue];
        if (dictionary[@"round_shares"] && dictionary[@"round_shares"] != [NSNull null]) {
            self.roundShares = [dictionary[@"round_shares"] integerValue];
        }
        
        NSMutableArray *array = [NSMutableArray array];
        for (NSDictionary *workerDict in dictionary[@"workers"]) {
            SDGWorker *worker = [[SDGWorker alloc] initWithDictionary:workerDict];
            [array addObject:worker];
        }
        self.workers = array;
    }
    return self;
}

@end
