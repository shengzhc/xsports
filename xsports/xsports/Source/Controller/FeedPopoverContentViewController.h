//
//  FeedPopoverContentViewController.h
//  xsports
//
//  Created by Shengzhe Chen on 12/29/14.
//  Copyright (c) 2014 Shengzhe Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FeedPopoverContentViewController;

@protocol FeedPopoverContentViewControllerDelegate <NSObject>
@optional
- (void)feedPopoverContentViewController:(FeedPopoverContentViewController *)controller didSelectIndexPath:(NSIndexPath *)indexPath;
@end

@interface FeedPopoverContentViewController : UITableViewController
@property (strong, nonatomic) NSIndexPath *selectedIndexPath;
@property (weak, nonatomic) id <FeedPopoverContentViewControllerDelegate> delegate;
@end
