//
//  SDGCard.m
//  SimpleDoge
//
//  Created by Adam McDonald on 3/18/14.
//  Copyright (c) 2014 Adam McDonald. All rights reserved.
//

#import "SDGCard.h"

@implementation SDGCard

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        self.difficultyAccepted = [dictionary[@"Difficulty Accepted"] integerValue];
        self.difficultyRejected = [dictionary[@"Difficulty Rejected"] integerValue];
        self.fanPercent = [dictionary[@"Fan Percent"] integerValue];
        self.gpuClock = [dictionary[@"GPU Clock"] integerValue];
        self.memoryClock = [dictionary[@"Memory Clock"] integerValue];
        self.mhsAverage = [dictionary[@"MHS av"] floatValue];
        self.number = [dictionary[@"GPU"] integerValue];
        self.temperature = [dictionary[@"temp"] integerValue];
        self.status = dictionary[@"Status"];
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@> GPU #%d - difficultyAccepted: %d, difficultyRejected: %d, fanPercent: %d, gpuClock: %d, memoryClock: %d, mhsAverage: %f, temperature: %d, status: %@", NSStringFromClass([self class]), self.number, self.difficultyAccepted, self.difficultyRejected, self.fanPercent, self.gpuClock, self.memoryClock, self.mhsAverage, self.temperature, self.status];
}

@end
