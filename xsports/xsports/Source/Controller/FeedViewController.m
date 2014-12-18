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

@property (strong, nonatomic) NSArray *feeds;
@end

@implementation FeedViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self load];
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
    if (self.flowCollectionViewController) {
        self.flowCollectionViewController.feeds = self.feeds;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:FeedViewFeedFlowLayoutSegueIdentifier]) {
        self.flowCollectionViewController = (FeedFlowCollectionViewController *)segue.destinationViewController;
        if (self.feeds) {
            self.flowCollectionViewController.feeds = self.feeds;
        }
    }
    
    [super prepareForSegue:segue sender:sender];
}

#pragma mark Action
- (IBAction)menuBarItemClicked:(id)sender
{
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
}

- (IBAction)didLayoutBarButtonItemClicked:(id)sender
{
}

@end
