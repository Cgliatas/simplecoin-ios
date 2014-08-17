//
//  SDGWorker.m
//  SimpleDoge
//
//  Created by Adam McDonald on 3/18/14.
//  Copyright (c) 2014 Adam McDonald. All rights reserved.
//

#import "SCNWorker.h"

#import "SCNCard.h"

@implementation SCNWorker

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        self.accepted = [dictionary[@"accepted"] integerValue];
        self.hashRate = [dictionary[@"last_10_hashrate"] floatValue];
        if (! [dictionary[@"efficiency"] isKindOfClass:[NSNull class]]) {
            self.efficiency = [dictionary[@"efficiency"] floatValue];
        }
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
                SCNCard *card = [[SCNCard alloc] initWithDictionary:gpuDict];
                [array addObject:card];
            }
            self.cards = array;
        } else {
            self.cards = @[];
        }
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@> name: %@ \n cards: %@", NSStringFromClass([self class]), self.name, self.cards];
}

@end
