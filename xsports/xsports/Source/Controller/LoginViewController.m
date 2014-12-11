//
//  LoginViewController.m
//  xsports
//
//  Created by Shengzhe Chen on 12/11/14.
//  Copyright (c) 2014 Shengzhe Chen. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginEmailCell.h"
#import "LoginPasswordCell.h"

@interface LoginViewController ()
@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupTableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)setupTableView
{
    self.tableView.rowHeight = 44.0;
    self.tableView.contentInset = UIEdgeInsetsMake(200, 0, 0, 0);
}

#pragma mark UITableViewDelegate & UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        LoginEmailCell *cell = [tableView dequeueReusableCellWithIdentifier:LoginEmailCellIdentifier forIndexPath:indexPath];
        return cell;
    } else if (indexPath.row == 1) {
        LoginPasswordCell *cell = [tableView dequeueReusableCellWithIdentifier:LoginPasswordCellIdentifier forIndexPath:indexPath];
        return cell;
    }
    
    return nil;
}

@end
