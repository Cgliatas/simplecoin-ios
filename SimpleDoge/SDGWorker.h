//
//  SDGWorker.h
//  SimpleDoge
//
//  Created by Adam McDonald on 3/18/14.
//  Copyright (c) 2014 Adam McDonald. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SDGWorker : NSObject
@property (strong, nonatomic) NSString *name;
@property (assign) BOOL isOnline;
@property (strong, nonatomic) NSArray *cards;
- (id)initWithDictionary:(NSDictionary *)dictionary;
- (CGFloat)hashRate;
@end
