//
//  SDGAddressStore.h
//  SimpleDoge
//
//  Created by Adam McDonald on 3/26/14.
//  Copyright (c) 2014 Adam McDonald. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SDGAddressStore : NSObject
+ (void)save:(NSString *)address;
+ (void)remove:(NSString *)address;
@end
