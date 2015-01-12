//
//  CommentsTextViewController.m
//  xsports
//
//  Created by Shengzhe Chen on 12/20/14.
//  Copyright (c) 2014 Shengzhe Chen. All rights reserved.
//

#import "CommentsTextViewController.h"
#import "CommentsCell.h"

@interface CommentsTextViewController ()
@property (strong, nonatomic) NSDictionary *prototypes;
@end

@implementation CommentsTextViewController

+ (UITableViewStyle)tableViewStyleForCoder:(NSCoder *)decoder
{
    return UITableViewStylePlain;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupTableView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self presentKeyboard:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self dismissKeyboard:animated];
    [super viewWillDisappear:animated];
}

- (void)setupTableView
{
    [self.tableView registerNib:[UINib nibWithNibName:@"CommentsCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:CommentsCellIdentifier];
    [self setupPrototypes];
    
    self.bounces = YES;
    self.shakeToClearEnabled = YES;
    self.keyboardPanningEnabled = YES;
    self.shouldScrollToBottomAfterKeyboardShows = NO;
    self.inverted = NO;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    
    self.textView.placeholder = GET_STRING(@"message");
    [self.textView setTintColor:[UIColor textFieldCursorColor]];
    [self.textView setPlaceholderColor:[UIColor textFieldPlaceHolderColor]];
    [self.textView setFont:[UIFont chnRegularFont]];
    [self.textView setTextColor:[UIColor cGrayColor]];
    self.textView.keyboardAppearance = UIKeyboardAppearanceDark;
    self.textView.layer.borderColor = [UIColor colorWithRed:217.0/255.0 green:217.0/255.0 blue:217.0/255.0 alpha:1.0].CGColor;
    self.textView.pastableMediaTypes = SLKPastableMediaTypeAll|SLKPastableMediaTypePassbook;
    
    [self.rightButton setTitle:GET_STRING(@"send") forState:UIControlStateNormal];
    [self.rightButton setTitleColor:[UIColor cGrayColor] forState:UIControlStateNormal];
    self.rightButton.titleLabel.font = [UIFont chnRegularFontWithSize:12.0];
    [self.rightButton setBackgroundColor:[UIColor cYellowColor]];
    self.rightButton.layer.cornerRadius = 5.0;
    self.rightButton.layer.masksToBounds = YES;
    
    [self.textInputbar setBackgroundColor:[UIColor whiteColor]];
    self.textInputbar.autoHideRightButton = YES;
    self.textInputbar.maxCharCount = 140;
    self.textInputbar.counterStyle = SLKCounterStyleSplit;
}

- (void)setupPrototypes
{
    NSMutableDictionary *prototypes = [NSMutableDictionary new];
    id cell = [[[NSBundle mainBundle] loadNibNamed:@"CommentsCell" owner:nil options:nil] objectAtIndex:0];
    prototypes[CommentsCellIdentifier] = cell;
    
    self.prototypes = prototypes;
}

- (void)setComments:(NSArray *)comments
{
    _comments = comments;
    [self.tableView reloadData];
}

#pragma mark UITableViewDelegate & UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.comments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableView) {
        Comment *comment = self.comments[indexPath.row];
        CommentsCell *cell = [tableView dequeueReusableCellWithIdentifier:CommentsCellIdentifier forIndexPath:indexPath];
        cell.comment = comment;
        return cell;
    }
    return nil;
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
