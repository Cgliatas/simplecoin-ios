//
//  SDGPool.h
//  SimpleDoge
//
//  Created by Adam McDonald on 3/25/14.
//  Copyright (c) 2014 Adam McDonald. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCNPool : NSObject
@property (assign) NSInteger completedShares;
@property (assign) NSInteger estimatedSecondsRemaining;
@property (assign) NSInteger hashRate;
@property (assign) NSInteger roundDuration;
@property (assign) NSInteger roundShares;
@property (assign) NSInteger sharesToSolve;
@property (assign) NSInteger workers;
- (id)initWithDictionary:(NSDictionary *)dictionary;
@end
