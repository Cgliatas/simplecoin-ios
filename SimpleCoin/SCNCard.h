//
//  SDGCard.h
//  SimpleDoge
//
//  Created by Adam McDonald on 3/18/14.
//  Copyright (c) 2014 Adam McDonald. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCNCard : NSObject
@property (assign) NSInteger fanPercent;
@property (assign) NSInteger gpuClock;
@property (assign) NSInteger hardwareErrors;
@property (assign) NSInteger memoryClock;
@property (assign) CGFloat mhsAverage;
@property (assign) NSInteger number;
@property (assign) NSInteger temperature;
@property (strong, nonatomic) NSString *status;
- (id)initWithDictionary:(NSDictionary *)dictionary;
@end
