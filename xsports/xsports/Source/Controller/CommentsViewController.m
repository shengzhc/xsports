//
//  CommentsViewController.m
//  xsports
//
//  Created by Shengzhe Chen on 12/20/14.
//  Copyright (c) 2014 Shengzhe Chen. All rights reserved.
//

#import "CommentsViewController.h"
#import "CommentsCell.h"

@interface CommentsViewController () < UITableViewDataSource, UITableViewDelegate >
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewTopConstraint;
@property (strong, nonatomic) NSDictionary *prototypes;
@property (strong, nonatomic) NSArray *comments;
@end

@implementation CommentsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupNavigationBar];
    [self setupTableView];
    [self load];
}

- (void)setupTableView
{
    [self.tableView registerNib:[UINib nibWithNibName:@"CommentsCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:CommentsCellIdentifier];
    if (self.navigationController) {
        self.tableViewTopConstraint.constant = 64.0;
    }
    [self setupPrototypes];
}

- (void)setupPrototypes
{
    NSMutableDictionary *prototypes = [NSMutableDictionary new];
    id cell = [[[NSBundle mainBundle] loadNibNamed:@"CommentsCell" owner:nil options:nil] objectAtIndex:0];
    prototypes[CommentsCellIdentifier] = cell;
    
    self.prototypes = prototypes;
}

- (void)setupNavigationBar
{
    UILabel *titleView = [[UILabel alloc] init];
    titleView.text = @"COMMENTS";
    titleView.font = [UIFont boldFontWithSize:20];
    titleView.textColor = [UIColor semiFujiColor];
    [titleView sizeToFit];
    self.navigationItem.titleView = titleView;
    
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ico_back"] style:UIBarButtonItemStyleBordered target:self action:@selector(didBackBarButtonItemClicked:)];
    [backBarButtonItem setImageInsets:UIEdgeInsetsMake(0, -16, 0, 0)];
    backBarButtonItem.tintColor = [[UIColor fujiColor] colorWithAlphaComponent:0.75];
    self.navigationItem.leftBarButtonItems = @[backBarButtonItem];
}

- (void)load
{
    NSAssert(self.mediaId != nil, @"Media id is missing");
    [[InstagramServices sharedInstance] getCommentsWithMediaId:self.mediaId successBlock:^(NSError *error, NSArray *comments) {
        self.comments = comments;
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
    return self.comments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Comment *comment = self.comments[indexPath.row];
    CommentsCell *cell = [tableView dequeueReusableCellWithIdentifier:CommentsCellIdentifier forIndexPath:indexPath];
    cell.comment = comment;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentsCell *cell = self.prototypes[CommentsCellIdentifier];
    cell.comment = self.comments[indexPath.row];
    cell.frame = CGRectMake(0, 0, tableView.bounds.size.width, 10000);
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
    CGFloat height = cell.seperator.frame.origin.y + cell.seperator.frame.size.height;
    return height;
}

@end
