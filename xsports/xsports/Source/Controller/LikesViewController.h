//
//  LikesViewController.h
//  xsports
//
//  Created by Shengzhe Chen on 12/19/14.
//  Copyright (c) 2014 Shengzhe Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LikesViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSString *mediaId;
@end
