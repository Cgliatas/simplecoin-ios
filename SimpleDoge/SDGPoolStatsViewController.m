//
//  SDGPoolStatsViewController.m
//  SimpleDoge
//
//  Created by Adam McDonald on 3/21/14.
//  Copyright (c) 2014 Adam McDonald. All rights reserved.
//

#import "SDGPoolStatsViewController.h"

#import "SDGPool.h"

#import <AFNetworking/AFHTTPRequestOperationManager.h>

@interface SDGPoolStatsViewController ()
// Interface
@property (weak, nonatomic) IBOutlet UILabel *hashRateLabel;
@property (weak, nonatomic) IBOutlet UILabel *workersLabel;

// Data
@property (strong, nonatomic) SDGPool *pool;
@end

@implementation SDGPoolStatsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Pool Stats";
    
    [self loadPoolStats];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Instance Methods

- (void)loadPoolStats
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager GET:@"http://stage.simpledoge.com/api/pool_stats"
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             NSLog(@"success");
             NSDictionary *response = (NSDictionary *)responseObject;
             NSLog(@"%@", response);
             [self parseStats:response];
             [self updateStats];
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"failure");
             NSLog(@"%@", [error localizedDescription]);
         }];
}

- (void)parseStats:(NSDictionary *)stats
{
    self.pool = [[SDGPool alloc] initWithDictionary:stats];
}

- (void)updateStats
{
    self.hashRateLabel.text = [NSString stringWithFormat:@"%.1f Mh/s", (self.pool.hashRate / 1000.0)];
    self.workersLabel.text = [NSString stringWithFormat:@"%d", self.pool.workers];
}

@end
