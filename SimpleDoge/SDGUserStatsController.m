//
//  SDGUserStatsController.m
//  SimpleDoge
//
//  Created by Adam McDonald on 3/16/14.
//  Copyright (c) 2014 Adam McDonald. All rights reserved.
//

#import "SDGUserStatsController.h"

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
@property (strong, nonatomic) NSArray *addresses;
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
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:nil
                                                                            action:nil];
    
    self.title = @"User Stats";
    
    self.tableView.backgroundColor = [SDGConstants backgroundColor];
    self.tableView.backgroundView.backgroundColor = [SDGConstants backgroundColor];
    self.tableView.separatorInset = UIEdgeInsetsZero;
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
    
    // Hit API
    [self fetchStatsForAddress:address];
}

#pragma mark - Instance Methods

- (void)loadRecentAddresses
{
    NSArray *savedAddresses = [[NSUserDefaults standardUserDefaults] objectForKey:kSDGAddresses];
    if (savedAddresses) {
        self.addresses = savedAddresses;
    } else {
        self.addresses = @[];
    }
    
    [self.tableView reloadData];
}

- (void)fetchStatsForAddress:(NSString *)address
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager GET:[NSString stringWithFormat:@"http://stage.simpledoge.com/api/%@", address]
      parameters:nil
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
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    [self fetchStatsForAddress:cell.textLabel.text];
}

@end
