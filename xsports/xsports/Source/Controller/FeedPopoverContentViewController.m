//
//  FeedPopoverContentViewController.m
//  xsports
//
//  Created by Shengzhe Chen on 12/29/14.
//  Copyright (c) 2014 Shengzhe Chen. All rights reserved.
//

#import "FeedPopoverContentViewController.h"
#import "FeedPopoverContentCell.h"

@interface FeedPopoverContentViewController ()

@end

@implementation FeedPopoverContentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.rowHeight = 45.0;
}

#pragma mark TableViewDelegate & TableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FeedPopoverContentCell *cell = [tableView dequeueReusableCellWithIdentifier:FeedPopoverContentCellIdentifier forIndexPath:indexPath];
    switch (indexPath.row) {
        case 0:
        {
            cell.contentImageView.image = [UIImage imageNamed:@"ico_layout_list"];
            cell.contentTextLabel.text = GET_STRING(@"layout_list");
        }
            break;
        case 1:
        {
            cell.contentImageView.image = [UIImage imageNamed:@"ico_layout_grid"];
            cell.contentTextLabel.text = GET_STRING(@"layout_grid");
        }
            break;
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(feedPopoverContentViewController:didSelectIndexPath:)]) {
        [self.delegate feedPopoverContentViewController:self didSelectIndexPath:indexPath];
    }
}

@end
