//
//  SDGPoolStatsViewController.m
//  SimpleDoge
//
//  Created by Adam McDonald on 3/21/14.
//  Copyright (c) 2014 Adam McDonald. All rights reserved.
//

#import "SCNPoolStatsViewController.h"

#import "SCNPool.h"

#import <AFNetworking/AFHTTPRequestOperationManager.h>

@interface SCNPoolStatsViewController ()
// Interface
@property (weak, nonatomic) IBOutlet UIView *hashRateView;
@property (weak, nonatomic) IBOutlet UILabel *hashRateLabel;
@property (weak, nonatomic) IBOutlet UILabel *workersLabel;
@property (weak, nonatomic) IBOutlet UILabel *roundTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *estimatedTimeLeftLabel;
@property (weak, nonatomic) IBOutlet UILabel *roundLuckLabel;

// Data
@property (strong, nonatomic) SCNPool *pool;
@end

@implementation SCNPoolStatsViewController

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
    
    self.navigationItem.rightBarButtonItem = [self refreshBarButtonItem];
    
    [self.hashRateView makeConstraints:^(MASConstraintMaker *make) {
        if (IS_IOS_7) {
            if (IS_IPAD) {
                make.top.offset(84.0);
            } else {
                make.top.offset(75.0);
            }
        } else {
            if (IS_IPAD) {
                make.top.offset(20.0);
            } else {
                make.top.offset(10.0);
            }
        }
    }];
    
    [self loadPoolStats];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Instance Methods

- (UIBarButtonItem *)refreshBarButtonItem
{
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                               target:self
                                                                               action:@selector(loadPoolStats)];
    return barButton;
}

- (void)loadPoolStats
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager GET:@"http://simpledoge.com/api/pool_stats"
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             NSDictionary *response = (NSDictionary *)responseObject;
             [self parseStats:response];
             [self updateStats];
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"%@", [error localizedDescription]);
         }];
}

- (void)parseStats:(NSDictionary *)stats
{
    self.pool = [[SCNPool alloc] initWithDictionary:stats];
}

- (void)updateStats
{
    self.hashRateLabel.text = [NSString stringWithFormat:@"%.1f MH/s", (self.pool.hashRate / 1000.0)];
    self.workersLabel.text = [NSString stringWithFormat:@"%d", self.pool.workers];
    self.roundTimeLabel.text = [NSString stringWithFormat:@"%.2d:%02d:%02d",
                                (self.pool.roundDuration / 3600),
                                ((self.pool.roundDuration / 60) % 60),
                                (self.pool.roundDuration % 60)];
    
    NSString *timeLeft = [NSString stringWithFormat:@"%.2d:%02d:%02d",
                          (self.pool.estimatedSecondsRemaining / 3600),
                          abs((self.pool.estimatedSecondsRemaining / 60) % 60),
                          abs(self.pool.estimatedSecondsRemaining % 60)];
    if ((self.pool.estimatedSecondsRemaining / 3600) == 0) {
        timeLeft = [@"-" stringByAppendingString:timeLeft];
    }
    self.estimatedTimeLeftLabel.text = timeLeft;
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [numberFormatter setMaximumFractionDigits:1];
    CGFloat luck = ((self.pool.sharesToSolve / (float)self.pool.completedShares) * 100.0);
    NSString *luckString = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:luck]];
    self.roundLuckLabel.text = [NSString stringWithFormat:@"%@%%", luckString];
}

@end
