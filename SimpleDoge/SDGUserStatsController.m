//
//  SDGUserStatsController.m
//  SimpleDoge
//
//  Created by Adam McDonald on 3/16/14.
//  Copyright (c) 2014 Adam McDonald. All rights reserved.
//

#import "SDGUserStatsController.h"

#import "SDGConstants.h"
#import "SDGWorkerStatsViewController.h"
#import "SDGWorker.h"

#import <AFNetworking/AFHTTPRequestOperationManager.h>

@interface SDGUserStatsController ()
// Interface
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;

// Data
@property (strong, nonatomic) NSArray *addresses;
@end

@implementation SDGUserStatsController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.addresses = @[@"DDTGag9oaBMRxCmknEMRGBu5hby93VHFrY", @"DEKBPiBMPRVY1fMTfi2znTqmi6rkxUBaD2", @"DPyT9tF5T5CQb7dnwXVE8hD2E6LiAYhTTs"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:nil
                                                                            action:nil];
    
    self.title = @"User Stats";
    
    self.addressTextField.text = @"DDTGag9oaBMRxCmknEMRGBu5hby93VHFrY";
    
    self.tableView.backgroundColor = [SDGConstants backgroundColor];
    self.tableView.backgroundView.backgroundColor = [SDGConstants backgroundColor];
    self.tableView.separatorInset = UIEdgeInsetsZero;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (IBAction)tappedViewStatsButton:(id)sender
{
    NSString *address = self.addressTextField.text;
    NSString *filter = [NSString stringWithFormat:@"{\"user\": \"%@\"}", address];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager GET:@"http://simpledoge.com/api/status"
      parameters:@{@"__filter_by": filter}
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             NSLog(@"success");
             NSDictionary *response = (NSDictionary *)responseObject;
             NSLog(@"%@", response);
             [self parseWorkers:response];
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"failure");
             NSLog(@"%@", [error localizedDescription]);
         }];
}

#pragma mark - Instance Methods

- (void)parseWorkers:(NSDictionary *)response
{
    NSMutableArray *workers = [NSMutableArray array];
    NSArray *objects = response[@"objects"];
    for (NSDictionary *workerDict in objects) {
        SDGWorker *worker = [[SDGWorker alloc] initWithDictionary:workerDict];
        [workers addObject:worker];
    }
    NSLog(@"%@", workers);
    
    SDGWorker *offlineWorker = [[SDGWorker alloc] init];
    offlineWorker.name = @"gtx750ti";
    offlineWorker.isOnline = NO;
    [workers addObject:offlineWorker];
    
    [self presentUserStatsForWorkers:workers];
}

- (void)presentUserStatsForWorkers:(NSArray *)workers
{
    SDGWorkerStatsViewController *vc = [[SDGWorkerStatsViewController alloc] initWithWorkers:workers];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Recently Visited Stats";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.addresses count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSString *cellIdentifier = @"ReuseIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.contentView.backgroundColor = [SDGConstants alternateBackgroundColor];
        cell.textLabel.font = [UIFont systemFontOfSize:13.0];
        cell.textLabel.textColor = [SDGConstants textColor];
    }

    cell.textLabel.text = self.addresses[row];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self tappedViewStatsButton:nil];
}

@end
