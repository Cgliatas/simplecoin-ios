//
//  SDGAddressStore.m
//  SimpleCoin
//
//  Created by Adam McDonald on 3/26/14.
//  Copyright (c) 2014 Adam McDonald. All rights reserved.
//

#import "SCNAddressStore.h"

#import "SCNConstants.h"

@implementation SCNAddressStore

+ (void)save:(NSString *)address
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *savedAddresses = [defaults objectForKey:kSDGAddresses];
    if (savedAddresses) {
        // Add to existing list of addresses if it doesn't exist already
        if (![savedAddresses containsObject:address]) {
            NSMutableArray *array = [NSMutableArray arrayWithArray:savedAddresses];
            [array addObject:address];
            savedAddresses = array;
        }
    } else {
        // No addresses saved yet
        savedAddresses = @[address];
    }
    [defaults setObject:savedAddresses forKey:kSDGAddresses];
    [defaults synchronize];
}

+ (void)remove:(NSString *)address
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *savedAddresses = [NSMutableArray arrayWithArray:[defaults objectForKey:kSDGAddresses]];
    if (savedAddresses && [savedAddresses containsObject:address]) {
        // Remove existing address from list
        [savedAddresses removeObject:address];
        [defaults setObject:savedAddresses forKey:kSDGAddresses];
        [defaults synchronize];
    }
}

@end
