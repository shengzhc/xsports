//
//  FeedViewController.m
//  xsports
//
//  Created by Shengzhe Chen on 12/12/14.
//  Copyright (c) 2014 Shengzhe Chen. All rights reserved.
//

#import "FeedViewController.h"
#import "FeedFlowCollectionViewController.h"
#import "FeedGridCollectionViewController.h"
#import "FeedPopoverContentViewController.h"

@interface FeedViewController () < UINavigationControllerDelegate, FeedPopoverContentViewControllerDelegate, WEPopoverControllerDelegate >
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (strong, nonatomic) FeedFlowCollectionViewController *flowCollectionViewController;
@property (strong, nonatomic) FeedGridCollectionViewController *gridCollectionViewController;
@property (strong, nonatomic) WEPopoverController *popController;

@property (strong, nonatomic) NSArray *feeds;
@end

@implementation FeedViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupViews];
    [self load];
    [self showFlowCollectionViewController];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[[AVPlayerManager sharedInstance] currentPlayingItem] stop];
}

#pragma mark Setup
- (void)setupViews
{
    self.view.backgroundColor = [UIColor cDarkGrayColor];
    self.headerActionButton.titleLabel.font = [UIFont chnRegularFont];
    [self.headerActionButton setTitle:[NSString stringWithFormat:@"%@ \u25BC", GET_STRING(@"feed_title")] forState:UIControlStateNormal];
    [self.headerActionButton setTitle:[NSString stringWithFormat:@"%@ \u25B2", GET_STRING(@"feed_title")] forState:UIControlStateSelected];
    [self.headerActionButton setTitleColor:[UIColor cLightGrayColor] forState:UIControlStateNormal];
    [self.headerActionButton setTitleColor:[UIColor cYellowColor] forState:UIControlStateSelected];
    self.headerActionButton.layer.cornerRadius = 2.0;
    self.headerActionButton.layer.masksToBounds = YES;
    [self.headerActionButton setBackgroundColor:[UIColor clearColor]];
}

- (void)setupFlowCollectionViewPullAndInfinite
{
    __weak FeedViewController *weakSelf = (FeedViewController *)self;
    [self.flowCollectionViewController.collectionView addPullToRefreshWithActionHandler:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf load];
            [weakSelf.flowCollectionViewController.collectionView.pullToRefreshView stopAnimating];
        });
    }];
    
    [self.flowCollectionViewController.collectionView addInfiniteScrollingWithActionHandler:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.flowCollectionViewController.collectionView.infiniteScrollingView stopAnimating];
        });
    }];
}

- (void)setupGridCollectionViewPullAndInfinite
{
    __weak FeedViewController *weakSelf = (FeedViewController *)self;
    [self.gridCollectionViewController.collectionView addPullToRefreshWithActionHandler:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf load];
            [weakSelf.gridCollectionViewController.collectionView.pullToRefreshView stopAnimating];
        });
    }];
    
    [self.gridCollectionViewController.collectionView addInfiniteScrollingWithActionHandler:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.gridCollectionViewController.collectionView.infiniteScrollingView stopAnimating];
        });
    }];
}

- (FeedGridCollectionViewController *)gridCollectionViewController
{
    if (_gridCollectionViewController == nil) {
        _gridCollectionViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:FeedGridCollectionViewControllerIdentifier];
        [self setupGridCollectionViewPullAndInfinite];
    }
    
    return _gridCollectionViewController;
}

- (void)setFeeds:(NSArray *)feeds
{
    _feeds = feeds;
    if (self.gridCollectionViewController) {
        self.gridCollectionViewController.feeds = _feeds;
    }
    if (self.flowCollectionViewController) {
        self.flowCollectionViewController.feeds = _feeds;
    }
}

#pragma mark Logic
- (void)load
{
    [[InstagramServices sharedInstance] getPopularMediaWithSuccessBlock:^(NSError *error, id response) {
        self.feeds = response;
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
- (IBAction)menuBarItemClicked:(id)sender
{
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
}

- (IBAction)didCameraBarButtonItemClicked:(id)sender
{
    UINavigationController *camViewController = (UINavigationController *)[[UIStoryboard storyboardWithName:@"Cam" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:NavAVCamViewControllerIdentifier];
    [self presentViewController:camViewController animated:YES completion:nil];
}

- (IBAction)didHeaderActionButtonClicked:(id)sender
{
    [self.headerActionButton setSelected:!self.headerActionButton.selected];
    if (self.headerActionButton.selected) {
        [self.headerActionButton setBackgroundColor:[UIColor grayColor]];
    } else {
        [self.headerActionButton setBackgroundColor:[UIColor clearColor]];
    }
    
    if (self.headerActionButton.selected) {
        if (self.popController) {
            [self.popController dismissPopoverAnimated:NO];
        }
        
        FeedPopoverContentViewController *contentViewController = [[UIStoryboard storyboardWithName:@"Popover" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:FeedPopoverContentViewControllerIdentifier];
        contentViewController.delegate = self;
        [contentViewController view];
        [contentViewController.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:(self.flowCollectionViewController.parentViewController ? 0 : 1) inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
        self.popController = [[WEPopoverController alloc] initWithContentViewController:contentViewController];
        self.popController.delegate = self;
        self.popController.popoverContentSize = CGSizeMake(144, 88);
        [self.popController presentPopoverFromRect:self.headerActionButton.frame inView:self.navigationController.navigationBar permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    } else {
        if (self.popController) {
            [self.popController dismissPopoverAnimated:YES];
            self.popController = nil;
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [super prepareForSegue:segue sender:sender];
    if ([segue.identifier isEqualToString:FeedViewFeedFlowLayoutSegueIdentifier]) {
        self.flowCollectionViewController = (FeedFlowCollectionViewController *)segue.destinationViewController;
        [self setupFlowCollectionViewPullAndInfinite];
    }
}

#pragma mark FeedPopoverContentViewControllerDelegate
- (void)feedPopoverContentViewController:(FeedPopoverContentViewController *)controller didSelectIndexPath:(NSIndexPath *)indexPath
{
    BOOL isGridLayout = [controller.tableView indexPathForSelectedRow].row == 1;
    if (isGridLayout) {
        [self showGridCollectionViewController];
    } else {
        [self showFlowCollectionViewController];
    }
    [self didHeaderActionButtonClicked:self.headerActionButton];
}

#pragma mark WEPopoverControllerDelegate
- (void)popoverControllerDidDismissPopover:(WEPopoverController *)popoverController
{
    [self didHeaderActionButtonClicked:self.headerActionButton];
}

#pragma mark UINavigationControllerDelegate
- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC
{
    return nil;
}
@end
