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

@interface SDGWorkerStatsViewController ()
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
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:nil
                                                                            action:nil];
    
    self.tableView.backgroundColor = [SDGConstants backgroundColor];
    self.tableView.backgroundView.backgroundColor = [SDGConstants backgroundColor];
    self.tableView.separatorInset = UIEdgeInsetsZero;
    
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
    self.averageHashRateLabel.text = [NSString stringWithFormat:@"%.3f Mh/s", self.user.hashRate];
    
    NSString *roundPayout = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:self.user.estimatedRoundPayout]];
    self.estimatedRoundPayoutLabel.text = [NSString stringWithFormat:@"%@ Ð", roundPayout];
    
    NSString *dogeDay = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:self.user.dailyEstimate]];
    self.estimatedDogeDayLabel.text = [NSString stringWithFormat:@"%@ Ð", dogeDay];
}

#pragma mark - UITableViewDataSource

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @" Worker Status";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.user.workers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    BOOL isEven = (row % 2 == 0);
    NSString *cellIdentifier = @"ReuseIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.contentView.backgroundColor = isEven ? [SDGConstants alternateBackgroundColor] : [SDGConstants separatorColor];
        cell.detailTextLabel.textColor = [SDGConstants textColor];
        cell.imageView.transform = CGAffineTransformMakeScale(0.4, 0.4);
        cell.textLabel.textColor = [SDGConstants textColor];
    }
    SDGWorker *worker = self.user.workers[row];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Hash rate: %.3f Mh/s  •  Efficiency: %.2f%%", worker.hashRate, worker.efficiency];
    cell.imageView.image = worker.isOnline ? [UIImage imageNamed:@"online"] : [UIImage imageNamed:@"offline"];
    cell.textLabel.text = worker.name;
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger row = indexPath.row;
    SDGWorker *worker = self.user.workers[row];
    SDGWorkerDetailsViewController *vc = [[SDGWorkerDetailsViewController alloc] initWithWorker:worker];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
