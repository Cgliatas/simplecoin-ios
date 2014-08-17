//
//  SDGAppDelegate.m
//  SimpleDoge
//
//  Created by Adam McDonald on 3/16/14.
//  Copyright (c) 2014 Adam McDonald. All rights reserved.
//

#import "SCNAppDelegate.h"

#import "SCNConstants.h"
#import "SCNPoolStatsViewController.h"
#import "SCNUserStatsController.h"

#import <Crashlytics/Crashlytics.h>

@implementation SCNAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Crashlytics startWithAPIKey:kCrashlyticsAPIKey];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [[UINavigationBar appearance] setTintColor:[SCNConstants separatorColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:
        @{NSForegroundColorAttributeName: [SCNConstants separatorColor],
          NSFontAttributeName: [UIFont boldSystemFontOfSize:22.0]
    }];
    
    SCNPoolStatsViewController *vc1 = [[SCNPoolStatsViewController alloc] init];
    UINavigationController *nc1 = [[UINavigationController alloc] initWithRootViewController:vc1];
    nc1.tabBarItem.title = @"Pool Stats";
    nc1.tabBarItem.image = [UIImage imageNamed:@"icon-bar-chart"];

    SCNUserStatsController *vc2 = [[SCNUserStatsController alloc] init];
    UINavigationController *nc2 = [[UINavigationController alloc] initWithRootViewController:vc2];
    nc2.tabBarItem.title = @"User Stats";
    nc2.tabBarItem.image = [UIImage imageNamed:@"icon-user"];
    
    UITabBarController *tbc = [[UITabBarController alloc] init];
    tbc.tabBar.tintColor = [SCNConstants separatorColor];
    tbc.viewControllers = @[nc1, nc2];
    
    self.window.rootViewController = tbc;
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
