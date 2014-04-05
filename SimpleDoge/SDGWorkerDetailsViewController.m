//
//  SDGWorkerDetailsViewController.m
//  SimpleDoge
//
//  Created by Adam McDonald on 3/19/14.
//  Copyright (c) 2014 Adam McDonald. All rights reserved.
//

#import "SDGWorkerDetailsViewController.h"

#import "SDGCard.h"
#import "SDGConstants.h"
#import "SDGWorker.h"

@interface SDGWorkerDetailsViewController ()
// Interface
@property (weak, nonatomic) IBOutlet UITableView *tableView;

// Data
@property (strong, nonatomic) SDGWorker *worker;
@end

@implementation SDGWorkerDetailsViewController

- (id)initWithWorker:(SDGWorker *)worker
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.worker = worker;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = self.worker.name;
    
    self.tableView.backgroundColor = [SDGConstants backgroundColor];
    self.tableView.backgroundView.backgroundColor = [SDGConstants backgroundColor];
    self.tableView.separatorInset = UIEdgeInsetsZero;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.worker.cards count];
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
        cell.contentView.backgroundColor = isEven ? [SDGConstants alternateBackgroundColor] : [SDGConstants separatorColor];
        cell.detailTextLabel.textColor = [SDGConstants textColor];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:(IS_IPAD ? 22.0 : 12.0)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:(IS_IPAD ? 28.0 : 17.0)];
        cell.textLabel.textColor = [SDGConstants textColor];
    }
    SDGCard *card = self.worker.cards[row];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d KH/s  •  HW: %d  •  %d°  •  Fan: %d  •  %d/%d", (int)(card.mhsAverage*1000), card.hardwareErrors, card.temperature, card.fanPercent, card.gpuClock, card.memoryClock];
    cell.textLabel.text = [NSString stringWithFormat:@"GPU #%d", card.number];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
