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
        self.name = dictionary[@"worker"];
        
        self.isOnline = YES;
        
        NSError *error = nil;
        NSString *status = dictionary[@"status"];
        NSData *statusData = [status dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *statusDict = [NSJSONSerialization JSONObjectWithData:statusData
                                                                   options:kNilOptions
                                                                     error:&error];
        
        if (error) {
            NSLog(@"%@", [error localizedDescription]);
        }
        
        NSMutableArray *array = [NSMutableArray array];
        NSArray *gpus = statusDict[@"gpus"];
        for (NSDictionary *gpuDict in gpus) {
            SDGCard *card = [[SDGCard alloc] initWithDictionary:gpuDict];
            [array addObject:card];
        }
        self.cards = array;
    }
    return self;
}

- (CGFloat)hashRate
{
    return [[self.cards valueForKeyPath:@"@sum.mhsAverage"] floatValue];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@> name: %@ \n cards: %@", NSStringFromClass([self class]), self.name, self.cards];
}

@end
