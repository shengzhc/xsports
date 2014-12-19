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


@interface FeedViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *layoutBarButtonItem;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (strong, nonatomic) FeedFlowCollectionViewController *flowCollectionViewController;
@property (strong, nonatomic) FeedGridCollectionViewController *gridCollectionViewController;

@property (strong, nonatomic) NSArray *feeds;
@end

@implementation FeedViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self load];
    [self showFlowCollectionViewController];
}

- (FeedGridCollectionViewController *)gridCollectionViewController
{
    if (_gridCollectionViewController == nil) {
        _gridCollectionViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:FeedGridCollectionViewControllerIdentifier];
        
        __weak FeedViewController *weakSelf = (FeedViewController *)self;
        [_gridCollectionViewController.collectionView addPullToRefreshWithActionHandler:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf load];
                [weakSelf.gridCollectionViewController.collectionView.pullToRefreshView stopAnimating];
            });
        }];
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
        self.gridCollectionViewController.feeds = _feeds;
    }
}

- (void)load
{
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
        [self.layoutBarButtonItem setImage:[UIImage imageNamed:@"ico_layout_grid"]];
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
        [self.layoutBarButtonItem setImage:[UIImage imageNamed:@"ico_layout_list"]];
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

- (IBAction)didLayoutBarButtonItemClicked:(id)sender
{
    if (self.flowCollectionViewController.parentViewController) {
        [self showGridCollectionViewController];
    } else {
        [self showFlowCollectionViewController];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [super prepareForSegue:segue sender:sender];
    if ([segue.identifier isEqualToString:FeedViewFeedFlowLayoutSegueIdentifier]) {
        self.flowCollectionViewController = (FeedFlowCollectionViewController *)segue.destinationViewController;
        __weak FeedViewController *weakSelf = (FeedViewController *)self;
        [self.flowCollectionViewController.collectionView addPullToRefreshWithActionHandler:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf load];
                [weakSelf.flowCollectionViewController.collectionView.pullToRefreshView stopAnimating];
            });
        }];
    }
}

@end
