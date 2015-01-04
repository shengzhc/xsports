//
//  UserProfileViewController.m
//  xsports
//
//  Created by Shengzhe Chen on 1/3/15.
//  Copyright (c) 2015 Shengzhe Chen. All rights reserved.
//

#import "UserProfileViewController.h"
#import "UserInfoViewController.h"
#import "FeedFlowCollectionViewController.h"
#import "UserGridCollectionViewController.h"

#import "UserProfileToolSectionHeader.h"

static void *FeedLayoutContext = &FeedLayoutContext;
//static void *RecordingContext = &RecordingContext;
//static void *SessionRunningAndDeviceAuthorizedContext = &SessionRunningAndDeviceAuthorizedContext;

@interface UserProfileViewController () < UICollectionViewDelegateFlowLayout, UserProfileToolSectionHeaderDelegate >
@property (weak, nonatomic) IBOutlet UserProfileToolSectionHeader *toolBar;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLayoutConstraint;
@property (strong, nonatomic) UserInfoViewController *userInfoViewController;
@property (strong, nonatomic) FeedFlowCollectionViewController *flowCollectionViewController;
@property (strong, nonatomic) UserGridCollectionViewController *gridCollectionViewController;
@property (strong, nonatomic) User *user;
@property (strong, nonatomic) NSArray *feeds;
@property (assign, nonatomic) BOOL isFlowLayout;
@end

@implementation UserProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupViews];
    [self loadUser];
    [self loadMedia];

    [self addObserver:self forKeyPath:@"isFlowLayout" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:FeedLayoutContext];
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"isFlowLayout"];
}

- (FeedGridCollectionViewController *)gridCollectionViewController
{
    if (_gridCollectionViewController == nil) {
        _gridCollectionViewController = [[UIStoryboard storyboardWithName:@"User" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:UserGridCollectionViewControllerIdentifier];
    }
    return _gridCollectionViewController;
}

- (void)setUser:(User *)user
{
    _user = user;
    self.userInfoViewController.user = user;
}

- (void)setFeeds:(NSArray *)feeds
{
    _feeds = feeds;
    self.flowCollectionViewController.feeds = feeds;
    self.gridCollectionViewController.feeds = feeds;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == FeedLayoutContext) {
        __block BOOL isFlowLayout = [change[NSKeyValueChangeNewKey] boolValue];
        dispatch_async(dispatch_get_main_queue(), ^{
            isFlowLayout ? [self userProfileToolSectionHeader:self.toolBar didListButtonClicked:nil] : [self userProfileToolSectionHeader:self.toolBar didGridButtonClicked:nil];
        });
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark Setup
- (void)setupViews
{
    [self.navigationController clearBackground];
    self.view.backgroundColor = [UIColor cGrayColor];
    self.toolBar.delegate = self;
}

- (void)loadUser
{
    NSAssert(self.userId != nil, @"User Id should not be empty");
    [[InstagramServices sharedInstance] getUserInfoWithUserId:self.userId successBlock:^(NSError *error, id response) {
        self.user = response;
    } failBlock:^(NSError *error, id response) {
        self.user = nil;
    }];
}

- (void)loadMedia
{
    NSAssert(self.userId != nil, @"User Id should not be empty");
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"instagram" ofType:@"txt"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    NSArray *medias = json[@"data"];
    NSMutableArray *feeds = [NSMutableArray new];
    for (NSDictionary *media in medias) {
        [feeds addObject:[[Media alloc] initWithDictionary:media error:nil]];
    }
    self.feeds = feeds;
}

#pragma mark Logic
- (void)showFlowCollectionViewController
{
    if (self.flowCollectionViewController.feeds != self.feeds) {
        self.flowCollectionViewController.feeds = self.feeds;
    }
    
    if (self.flowCollectionViewController.parentViewController) {
        return;
    }
    
    if (self.gridCollectionViewController.parentViewController) {
        [self animateTransitionBetweenFromViewController:self.gridCollectionViewController toViewController:self.flowCollectionViewController goingRight:NO];
    }
}

- (void)showGridCollectionViewController
{
    if (self.gridCollectionViewController.feeds != self.feeds) {
        self.gridCollectionViewController.feeds = self.feeds;
    }
    
    if (self.gridCollectionViewController.isViewLoaded && self.gridCollectionViewController.view.window) {
        return;
    }
    
    if (self.flowCollectionViewController.parentViewController) {
        [self animateTransitionBetweenFromViewController:self.flowCollectionViewController toViewController:self.gridCollectionViewController goingRight:YES];
    }
}

- (void)animateTransitionBetweenFromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController goingRight:(BOOL)goingRight
{
    [fromViewController willMoveToParentViewController:nil];
    [toViewController willMoveToParentViewController:self];
    [self addChildViewController:toViewController];
    
    SlidingAndFadingAnimator *animator = [[SlidingAndFadingAnimator alloc] init];
    SlidingAndFadingTransitionContext *transitionContext = [[SlidingAndFadingTransitionContext alloc] initWithFromViewController:fromViewController toViewController:toViewController goingRight:goingRight];
    transitionContext.completionBlock = ^(BOOL didComplete) {
        [fromViewController.view removeFromSuperview];
        [fromViewController removeFromParentViewController];
        [toViewController didMoveToParentViewController:self];
        if ([animator respondsToSelector:@selector (animationEnded:)]) {
            [animator animationEnded:didComplete];
        }
    };
    [animator animateTransition:transitionContext];
}

#pragma mark Action
- (IBAction)didBackBarButtonItemClicked:(id)sender
{
    if (self.navigationController) {
        if (self.navigationController.viewControllers[0] == self) {
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)didEditUserBarButtonClicked:(id)sender
{
}

#pragma mark UserProfileToolSectionHeaderDelegate
- (void)userProfileToolSectionHeader:(UserProfileToolSectionHeader *)header didListButtonClicked:(id)sender
{
    header.listButton.selected = YES;
    header.gridButton.selected = NO;
    
    [self showFlowCollectionViewController];
}

- (void)userProfileToolSectionHeader:(UserProfileToolSectionHeader *)header didGridButtonClicked:(id)sender
{
    header.listButton.selected = NO;
    header.gridButton.selected = YES;
    
    [self showGridCollectionViewController];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:UserProfileInfoViewControllerSegueIdentifier]) {
        self.userInfoViewController = segue.destinationViewController;
    } else if ([segue.identifier isEqualToString:UserFeedFlowCollectionViewControllerSegueIdentifier]) {
        self.flowCollectionViewController = segue.destinationViewController;
    } else {
        [super prepareForSegue:segue sender:sender];
    }
}
@end
