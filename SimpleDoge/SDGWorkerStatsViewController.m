//
//  SDGWorkerStatsViewController.m
//  SimpleDoge
//
//  Created by Adam McDonald on 3/19/14.
//  Copyright (c) 2014 Adam McDonald. All rights reserved.
//

#import "SDGWorkerStatsViewController.h"

#import "SDGConstants.h"
#import "SDGUser.h"
#import "SDGWorker.h"
#import "SDGWorkerDetailsViewController.h"

@interface SDGWorkerStatsViewController () <UIAlertViewDelegate>
// Interface
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *roundSharesLabel;
@property (weak, nonatomic) IBOutlet UILabel *estimatedRoundPayoutLabel;
@property (weak, nonatomic) IBOutlet UILabel *estimatedDogeDayLabel;
@property (weak, nonatomic) IBOutlet UILabel *averageHashRateLabel;

// Data
@property (strong, nonatomic) SDGUser *user;
@end

@implementation SDGWorkerStatsViewController

- (id)initWithUser:(SDGUser *)user
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
    
    self.tableView.backgroundColor = [SDGConstants backgroundColor];
    self.tableView.backgroundView.backgroundColor = [SDGConstants backgroundColor];
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
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [numberFormatter setMaximumFractionDigits:3];
    
    self.roundSharesLabel.text = [numberFormatter stringFromNumber:[NSNumber numberWithInteger:self.user.roundShares]];
    self.averageHashRateLabel.text = [NSString stringWithFormat:@"%.3f MH/s", self.user.hashRate];
    
    NSString *roundPayout = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:self.user.estimatedRoundPayout]];
    self.estimatedRoundPayoutLabel.text = [NSString stringWithFormat:@"%@ Ð", roundPayout];
    
    NSString *dogeDay = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:self.user.dailyEstimate]];
    self.estimatedDogeDayLabel.text = [NSString stringWithFormat:@"%@ Ð", dogeDay];
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
    headerLabel.backgroundColor = [SDGConstants tableViewSectionHeaderColor];
    headerLabel.font = [UIFont systemFontOfSize:(IS_IPAD ? 22.0 : 12.0)];
    headerLabel.text = @" Worker Stats";
    headerLabel.textColor = [SDGConstants backgroundColor];
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
        cell.detailTextLabel.textColor = [SDGConstants textColor];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:(IS_IPAD ? 22.0 : 12.0)];
        cell.imageView.transform = CGAffineTransformMakeScale(0.4, 0.4);
        cell.textLabel.font = [UIFont systemFontOfSize:(IS_IPAD ? 28.0 : 17.0)];
        cell.textLabel.textColor = [SDGConstants textColor];
    }
    SDGWorker *worker = self.user.workers[row];
    cell.contentView.backgroundColor = isEven ? [SDGConstants alternateBackgroundColor] : [SDGConstants separatorColor];
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
    SDGWorker *worker = self.user.workers[row];
    
    if ([worker.cards count] > 0) {
        SDGWorkerDetailsViewController *vc = [[SDGWorkerDetailsViewController alloc] initWithWorker:worker];
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
