//
//  SDGCard.m
//  SimpleDoge
//
//  Created by Adam McDonald on 3/18/14.
//  Copyright (c) 2014 Adam McDonald. All rights reserved.
//

#import "SCNCard.h"

@implementation SCNCard

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        self.fanPercent = [dictionary[@"Fan Percent"] integerValue];
        self.gpuClock = [dictionary[@"GPU Clock"] integerValue];
        self.hardwareErrors = [dictionary[@"Hardware Errors"] integerValue];
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
    return [NSString stringWithFormat:@"<%@> GPU #%d - fanPercent: %d, gpuClock: %d, memoryClock: %d, mhsAverage: %f, temperature: %d, status: %@", NSStringFromClass([self class]), self.number, self.fanPercent, self.gpuClock, self.memoryClock, self.mhsAverage, self.temperature, self.status];
}

@end
