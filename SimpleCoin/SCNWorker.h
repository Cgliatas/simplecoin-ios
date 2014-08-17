//
//  SDGWorker.h
//  SimpleCoin
//
//  Created by Adam McDonald on 3/18/14.
//  Copyright (c) 2014 Adam McDonald. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCNWorker : NSObject
@property (assign) NSInteger accepted;
@property (assign) CGFloat efficiency;
@property (assign) CGFloat hashRate;
@property (strong, nonatomic) NSString *name;
@property (assign) BOOL isOnline;
@property (assign) NSInteger rejected;
@property (strong, nonatomic) NSArray *cards;
- (id)initWithDictionary:(NSDictionary *)dictionary;
@end
