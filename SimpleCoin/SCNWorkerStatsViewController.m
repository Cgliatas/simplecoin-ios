//
//  SDGWorkerStatsViewController.m
//  SimpleDoge
//
//  Created by Adam McDonald on 3/19/14.
//  Copyright (c) 2014 Adam McDonald. All rights reserved.
//

#import "SCNWorkerStatsViewController.h"

#import "SCNConstants.h"
#import "SCNUser.h"
#import "SCNWorker.h"
#import "SCNWorkerDetailsViewController.h"

@interface SCNWorkerStatsViewController () <UIAlertViewDelegate>
// Interface
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *roundSharesLabel;
@property (weak, nonatomic) IBOutlet UILabel *estimatedRoundPayoutLabel;
@property (weak, nonatomic) IBOutlet UILabel *estimatedDailyPayoutHeaderLabel;
@property (weak, nonatomic) IBOutlet UILabel *estimatedDogeDayLabel;
@property (weak, nonatomic) IBOutlet UILabel *averageHashRateLabel;

// Data
@property (strong, nonatomic) SCNUser *user;
@end

@implementation SCNWorkerStatsViewController

- (id)initWithUser:(SCNUser *)user
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.user = user;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Worker Stats";
    
    if (IS_IOS_7) {
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                                 style:UIBarButtonItemStylePlain
                                                                                target:nil
                                                                                action:nil];
    }
    
#if SIMPLEDOGE
    self.estimatedDailyPayoutHeaderLabel.text = @"Est. Doge/day";
#else
    self.estimatedDailyPayoutHeaderLabel.text = @"Est. Vert/day";
#endif
    
    self.tableView.backgroundColor = [SCNConstants backgroundColor];
    self.tableView.backgroundView.backgroundColor = [SCNConstants backgroundColor];
    if (IS_IOS_7) {
        self.tableView.separatorInset = UIEdgeInsetsZero;
    }
    
    [self updateStats];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Instance Methods

- (void)updateStats
{
#ifdef SIMPLEDOGE
    NSString *symbol = @"Ð";
#else
    NSString *symbol = @"ᗐ";
#endif
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [numberFormatter setMaximumFractionDigits:3];
    
    self.roundSharesLabel.text = [numberFormatter stringFromNumber:[NSNumber numberWithInteger:self.user.roundShares]];
    self.averageHashRateLabel.text = [NSString stringWithFormat:@"%.3f MH/s", self.user.hashRate];
    
    NSString *roundPayout = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:self.user.estimatedRoundPayout]];
    self.estimatedRoundPayoutLabel.text = [NSString stringWithFormat:@"%@ %@", roundPayout, symbol];
    
    NSString *dogeDay = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:self.user.dailyEstimate]];
    self.estimatedDogeDayLabel.text = [NSString stringWithFormat:@"%@ %@", dogeDay, symbol];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kPowerpoolAgentURL]];
    }
}

#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return IS_IPAD ? 40.0 : 20.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    headerLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    headerLabel.backgroundColor = [SCNConstants tableViewSectionHeaderColor];
    headerLabel.font = [UIFont systemFontOfSize:(IS_IPAD ? 22.0 : 12.0)];
    headerLabel.text = @" Worker Stats";
    headerLabel.textColor = [SCNConstants backgroundColor];
    return headerLabel;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.user.workers count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return IS_IPAD ? 88.0 : 44.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    BOOL isEven = (row % 2 == 0);
    NSString *cellIdentifier = @"ReuseIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.detailTextLabel.textColor = [SCNConstants textColor];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:(IS_IPAD ? 22.0 : 12.0)];
        cell.imageView.transform = CGAffineTransformMakeScale(0.4, 0.4);
        cell.textLabel.font = [UIFont systemFontOfSize:(IS_IPAD ? 28.0 : 17.0)];
        cell.textLabel.textColor = [SCNConstants textColor];
    }
    SCNWorker *worker = self.user.workers[row];
    cell.contentView.backgroundColor = isEven ? [SCNConstants alternateBackgroundColor] : [SCNConstants separatorColor];
    cell.detailTextLabel.backgroundColor = cell.contentView.backgroundColor;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Hash rate: %.3f MH/s  •  Efficiency: %.2f%%", worker.hashRate, worker.efficiency];
    cell.imageView.image = worker.isOnline ? [UIImage imageNamed:@"online"] : [UIImage imageNamed:@"offline"];
    cell.textLabel.backgroundColor = cell.contentView.backgroundColor;
    cell.textLabel.text = worker.name;
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger row = indexPath.row;
    SCNWorker *worker = self.user.workers[row];
    
    if ([worker.cards count] > 0) {
        SCNWorkerDetailsViewController *vc = [[SCNWorkerDetailsViewController alloc] initWithWorker:worker];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No GPUs"
                                                        message:@"Setup advanced stats to track GPU temps and actual hashrate with Powerpool Agent."
                                                       delegate:self
                                              cancelButtonTitle:@"Close"
                                              otherButtonTitles:@"Setup", nil];
        [alert show];
    }
}

@end
