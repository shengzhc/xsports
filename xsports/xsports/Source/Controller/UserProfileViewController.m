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
static void *ScrollViewContentOffsetContext = &ScrollViewContentOffsetContext;
//static void *RecordingContext = &RecordingContext;
//static void *SessionRunningAndDeviceAuthorizedContext = &SessionRunningAndDeviceAuthorizedContext;

@interface UserProfileViewController () < UICollectionViewDelegateFlowLayout, UserProfileToolSectionHeaderDelegate >
@property (weak, nonatomic) IBOutlet UIView *overlay;
@property (weak, nonatomic) IBOutlet UserProfileToolSectionHeader *toolBar;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLayoutConstraint;
@property (weak, nonatomic) IBOutlet UIButton *userNameTitle;
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

    [self addObserver:self forKeyPath:@"isFlowLayout" options:NSKeyValueObservingOptionNew context:FeedLayoutContext];
    [self userProfileToolSectionHeader:self.toolBar didListButtonClicked:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.isRootLevel) {
        [self.backBarButtonItem setImage:[UIImage imageNamed:@"ico_menu"]];
    }
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"isFlowLayout"];
    if (self.flowCollectionViewController.parentViewController) {
        [self.flowCollectionViewController removeObserver:self forKeyPath:@"collectionView.contentOffset" context:ScrollViewContentOffsetContext];
    } else {
        [self.gridCollectionViewController removeObserver:self forKeyPath:@"collectionView.contentOffset" context:ScrollViewContentOffsetContext];
    }
}

- (FeedGridCollectionViewController *)gridCollectionViewController
{
    if (_gridCollectionViewController == nil) {
        _gridCollectionViewController = [[UIStoryboard storyboardWithName:@"User" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:UserGridCollectionViewControllerIdentifier];
        _gridCollectionViewController.collectionView.showsVerticalScrollIndicator = NO;
        _gridCollectionViewController.collectionView.showsHorizontalScrollIndicator = NO;
    }
    return _gridCollectionViewController;
}

- (void)setUser:(User *)user
{
    _user = user;
    self.userInfoViewController.user = user;
    [self.userNameTitle setTitle:user.fullName forState:UIControlStateNormal];
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
            isFlowLayout ? [self showFlowCollectionViewController] : [self showGridCollectionViewController];
        });
    } else if (context == ScrollViewContentOffsetContext) {
        CGPoint contentOffset = ((NSValue *)change[NSKeyValueChangeNewKey]).CGPointValue;
        CGFloat height = self.userInfoViewController.view.bounds.size.height + self.toolBar.bounds.size.height;
        CGFloat offset = contentOffset.y + height;
        offset = MAX(0, MIN(offset, self.userInfoViewController.view.bounds.size.height - 64));
        self.topLayoutConstraint.constant = -offset;
        self.overlay.alpha = offset*1.5/height;
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark Setup
- (void)setupViews
{
    self.view.backgroundColor = [UIColor cGrayColor];
    self.toolBar.delegate = self;
    self.overlay.backgroundColor = [UIColor cGrayColor];
    self.overlay.alpha = 0;
    
    CGFloat height = [UIScreen width]/8.0*7.0 + 44;
    self.flowCollectionViewController.collectionView.contentInset = UIEdgeInsetsMake(height, 0, 0, 0);
    self.gridCollectionViewController.collectionView.contentInset = UIEdgeInsetsMake(height, 0, 0, 0);
    
    [self.userNameTitle setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.userNameTitle.titleLabel.font = [UIFont chnRegularFontWithSize:16.0];
}

- (void)loadUser
{
    NSAssert(self.userId != nil, @"User Id should not be empty");
    [[InstagramServices sharedInstance] getUserInfoWithUserId:self.userId successBlock:^(NSError *error, id response) {
        self.user = response;
        self.isFlowLayout = YES;
    } failBlock:^(NSError *error, id response) {
        self.user = nil;
    }];
}

- (void)loadMedia
{
    NSAssert(self.userId != nil, @"User Id should not be empty");
    
    [[InstagramServices sharedInstance] getUserRecentMediaWithUserId:self.userId successBlock:^(NSError *error, NSArray *medias) {
        self.feeds = medias;
    } failBlock:^(NSError *error, id response) {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"instagram" ofType:@"txt"];
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSArray *medias = json[@"data"];
        NSMutableArray *feeds = [NSMutableArray new];
        for (NSDictionary *media in medias) {
            [feeds addObject:[[Media alloc] initWithDictionary:media error:nil]];
        }
        self.feeds = feeds;
    }];
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

- (void)animateTransitionBetweenFromViewController:(UICollectionViewController *)fromViewController toViewController:(UICollectionViewController *)toViewController goingRight:(BOOL)goingRight
{
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [fromViewController.collectionView scrollRectToVisible:CGRectMake(0, -fromViewController.collectionView.contentInset.top, fromViewController.collectionView.bounds.size.width, fromViewController.collectionView.bounds.size.height) animated:YES];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        [fromViewController removeObserver:self forKeyPath:@"collectionView.contentOffset" context:ScrollViewContentOffsetContext];
        [fromViewController willMoveToParentViewController:nil];
        [toViewController willMoveToParentViewController:self];
        [self addChildViewController:toViewController];
        [toViewController addObserver:self forKeyPath:@"collectionView.contentOffset" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:ScrollViewContentOffsetContext];
        
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
    });
}

#pragma mark Action
- (IBAction)didBackBarButtonItemClicked:(id)sender
{
    if (self.isRootLevel) {
        [self.slidingViewController anchorTopViewToRightAnimated:YES];
        return;
    } else {
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
}

- (IBAction)didEditUserBarButtonClicked:(id)sender
{
}

#pragma mark UserProfileToolSectionHeaderDelegate
- (void)userProfileToolSectionHeader:(UserProfileToolSectionHeader *)header didListButtonClicked:(id)sender
{
    header.listButton.selected = YES;
    header.gridButton.selected = NO;
    self.isFlowLayout = YES;
}

- (void)userProfileToolSectionHeader:(UserProfileToolSectionHeader *)header didGridButtonClicked:(id)sender
{
    header.listButton.selected = NO;
    header.gridButton.selected = YES;
    self.isFlowLayout = NO;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:UserProfileInfoViewControllerSegueIdentifier]) {
        self.userInfoViewController = segue.destinationViewController;
    } else if ([segue.identifier isEqualToString:UserFeedFlowCollectionViewControllerSegueIdentifier]) {
        self.flowCollectionViewController = segue.destinationViewController;
        [self.flowCollectionViewController addObserver:self forKeyPath:@"collectionView.contentOffset" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial context:ScrollViewContentOffsetContext];
    } else {
        [super prepareForSegue:segue sender:sender];
    }
}
@end
