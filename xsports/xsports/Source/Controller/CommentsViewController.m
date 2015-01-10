//
//  CommentsViewController.m
//  xsports
//
//  Created by Shengzhe Chen on 12/20/14.
//  Copyright (c) 2014 Shengzhe Chen. All rights reserved.
//

#import "CommentsViewController.h"

@interface CommentsViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@end

@implementation CommentsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupNavigationBar];
    
    self.view.backgroundColor = [UIColor cGrayColor];
    
    [self load];
}

- (void)setupNavigationBar
{
    UILabel *titleView = [[UILabel alloc] init];
    titleView.text = GET_STRING(@"comment");
    titleView.font = [UIFont chnRegularFontWithSize:20];
    titleView.textColor = [UIColor cLightGrayColor];
    [titleView sizeToFit];
    self.navigationItem.titleView = titleView;
    
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ico_back"] style:UIBarButtonItemStyleBordered target:self action:@selector(didBackBarButtonItemClicked:)];
    [backBarButtonItem setImageInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    self.navigationItem.leftBarButtonItems = @[backBarButtonItem];

    if (self.navigationController) {
        self.topConstraint.constant = 64.0;
    }
}

- (void)load
{
    NSAssert(self.mediaId != nil, @"Media id is missing");
    [[InstagramServices sharedInstance] getCommentsWithMediaId:self.mediaId successBlock:^(NSError *error, NSArray *comments) {
        self.textViewController.comments = comments;
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:CommentsTextViewControllerSegueIdentifier]) {
        self.textViewController = (CommentsTextViewController *)segue.destinationViewController;
    }
}

@end
