//
//  SDGPool.h
//  SimpleDoge
//
//  Created by Adam McDonald on 3/25/14.
//  Copyright (c) 2014 Adam McDonald. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SDGPool : NSObject
@property (assign) NSInteger hashRate;
@property (assign) NSInteger roundShares;
@property (assign) NSInteger workers;
- (id)initWithDictionary:(NSDictionary *)dictionary;
@end
