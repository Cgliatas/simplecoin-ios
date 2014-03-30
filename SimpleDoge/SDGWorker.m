//
//  SDGWorker.m
//  SimpleDoge
//
//  Created by Adam McDonald on 3/18/14.
//  Copyright (c) 2014 Adam McDonald. All rights reserved.
//

#import "SDGWorker.h"

#import "SDGCard.h"

@implementation SDGWorker

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        self.accepted = [dictionary[@"accepted"] integerValue];
        self.hashRate = [dictionary[@"last_10_hashrate"] floatValue];
        self.efficiency = [dictionary[@"efficiency"] floatValue];
        self.name = dictionary[@"name"];
        if (self.name == nil || [self.name isEqualToString:@""]) {
            self.name = @"[unnamed]";
        }
        self.isOnline = [dictionary[@"online"] boolValue];
        self.rejected = [dictionary[@"rejected"] integerValue];
        
        NSMutableArray *array = [NSMutableArray array];
        if (dictionary[@"status"] && dictionary[@"status"] != [NSNull null]) {
            NSArray *gpus = dictionary[@"status"][@"gpus"];
            for (NSDictionary *gpuDict in gpus) {
                SDGCard *card = [[SDGCard alloc] initWithDictionary:gpuDict];
                [array addObject:card];
            }
            self.cards = array;
        } else {
            self.cards = @[];
        }
    }
    return self;
}

//- (CGFloat)hashRate
//{
//    return [[self.cards valueForKeyPath:@"@sum.mhsAverage"] floatValue];
//}

//- (CGFloat)efficiency
//{
//    if ((self.accepted + self.rejected) == 0) return 100.0;
//    return (1.0 - (self.rejected / (float)(self.accepted + self.rejected))) * 100.0;
//}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@> name: %@ \n cards: %@", NSStringFromClass([self class]), self.name, self.cards];
}

@end
