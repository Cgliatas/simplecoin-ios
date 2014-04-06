//
//  SDGUserStatsController.m
//  SimpleDoge
//
//  Created by Adam McDonald on 3/16/14.
//  Copyright (c) 2014 Adam McDonald. All rights reserved.
//

#import "SDGUserStatsController.h"

#import "SDGAddressStore.h"
#import "SDGConstants.h"
#import "SDGUser.h"
#import "SDGWorkerStatsViewController.h"
#import "SDGWorker.h"

#import <AFNetworking/AFHTTPRequestOperationManager.h>

@interface SDGUserStatsController ()
// Interface
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;

// Data
@property (strong, nonatomic) NSMutableArray *addresses;
@end

@implementation SDGUserStatsController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (IS_IOS_7) {
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                                 style:UIBarButtonItemStylePlain
                                                                                target:nil
                                                                                action:nil];
    }
    
    self.title = @"User Stats";
    
    self.tableView.backgroundColor = [SDGConstants backgroundColor];
    self.tableView.backgroundView.backgroundColor = [SDGConstants backgroundColor];
    if (IS_IOS_7) {
        self.tableView.separatorInset = UIEdgeInsetsZero;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadRecentAddresses];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.addressTextField.text = @"";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Actions

- (IBAction)tappedViewStatsButton:(id)sender
{
    [self.addressTextField resignFirstResponder];
    
    NSString *address = self.addressTextField.text;
    
    // Validate address
    if (address == nil || [address length] == 0) return;
    
    // Store address
    [SDGAddressStore save:address];
    
    // Hit API
    [self fetchStatsForAddress:address];
}

#pragma mark - Instance Methods

- (void)loadRecentAddresses
{
    NSArray *savedAddresses = [[NSUserDefaults standardUserDefaults] objectForKey:kSDGAddresses];
    if (savedAddresses) {
        self.addresses = [NSMutableArray arrayWithArray:savedAddresses];
    } else {
        self.addresses = [NSMutableArray array];
    }
    
    [self.tableView reloadData];
}

- (void)fetchStatsForAddress:(NSString *)address
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager GET:[NSString stringWithFormat:@"http://simpledoge.com/api/%@", address]
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             NSDictionary *response = (NSDictionary *)responseObject;
             [self parseWorkers:response];
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"%@", [error localizedDescription]);
         }];
}

- (void)parseWorkers:(NSDictionary *)response
{
    SDGUser *user = [[SDGUser alloc] initWithDictionary:response];
    [self presentUserStats:user];
}

- (void)presentUserStats:(SDGUser *)user
{
    SDGWorkerStatsViewController *vc = [[SDGWorkerStatsViewController alloc] initWithUser:user];
    [self.navigationController pushViewController:vc animated:YES];
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
    headerLabel.text = @" Recently Visited Stats";
    headerLabel.textColor = [SDGConstants backgroundColor];
    return headerLabel;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.addresses count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return IS_IPAD ? 88.0 : 44.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSString *cellIdentifier = @"ReuseIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.contentView.backgroundColor = [SDGConstants alternateBackgroundColor];
        cell.textLabel.backgroundColor = [SDGConstants alternateBackgroundColor];
        cell.textLabel.font = [UIFont systemFontOfSize:(IS_IPAD ? 26.0 : 13.0)];
        cell.textLabel.textColor = [SDGConstants textColor];
    }

    cell.textLabel.text = self.addresses[row];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Remove from persistent storage
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        NSString *address = cell.textLabel.text;
        [SDGAddressStore remove:address];
        
        // Remove from local array
        NSInteger row = indexPath.row;
        [self.addresses removeObjectAtIndex:row];
        
        // Remove from table view
        cell.alpha = 0.0;
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    [self fetchStatsForAddress:cell.textLabel.text];
}

@end
