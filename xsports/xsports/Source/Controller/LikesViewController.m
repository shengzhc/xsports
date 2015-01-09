//
//  LikesViewController.m
//  xsports
//
//  Created by Shengzhe Chen on 12/19/14.
//  Copyright (c) 2014 Shengzhe Chen. All rights reserved.
//

#import "LikesViewController.h"
#import "LikesCell.h"

@interface LikesViewController () < UITableViewDataSource, UITableViewDelegate >
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewTopConstraint;
@property (strong, nonatomic) NSArray *likers;
@end

@implementation LikesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupNavigationBar];
    [self setupTableView];
    [self load];
}

- (void)setupTableView
{
    self.view.backgroundColor = [UIColor cGrayColor];
    self.tableView.rowHeight = 50.0;
    if (self.navigationController) {
        self.tableViewTopConstraint.constant = 64.0;
    }
}

- (void)setupNavigationBar
{
    UILabel *titleView = [[UILabel alloc] init];
    titleView.text = GET_STRING(@"user_follow");
    titleView.font = [UIFont chnRegularFont];
    titleView.textColor = [UIColor cLightGrayColor];
    [titleView sizeToFit];
    self.navigationItem.titleView = titleView;
    
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ico_back"] style:UIBarButtonItemStyleBordered target:self action:@selector(didBackBarButtonItemClicked:)];
    [backBarButtonItem setImageInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    self.navigationItem.leftBarButtonItems = @[backBarButtonItem];
}

- (void)load
{
    [[InstagramServices sharedInstance] getLikesWithMediaId:self.mediaId successBlock:^(NSError *error, NSArray *likers) {
        self.likers = likers;
        [self.tableView reloadData];
    } failBlock:nil];
}

#pragma mark Action
- (void)didBackBarButtonItemClicked:(id)sender
{
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark UITableViewDelegate & UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.likers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    User *liker = self.likers[indexPath.row];
    LikesCell *cell = [tableView dequeueReusableCellWithIdentifier:LikesCellIdentifier forIndexPath:indexPath];
    cell.liker = liker;
    return cell;
}

@end
