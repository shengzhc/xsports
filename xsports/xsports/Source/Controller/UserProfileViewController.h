//
//  UserProfileViewController.h
//  xsports
//
//  Created by Shengzhe Chen on 1/3/15.
//  Copyright (c) 2015 Shengzhe Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface UserProfileViewController : UIViewController
@property (copy, nonatomic) NSString *userId;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backBarButtonItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editUserBarButtonItem;
@property (weak, nonatomic) IBOutlet UIView *topContainer;
@property (weak, nonatomic) IBOutlet UIView *contentContainer;
- (IBAction)didBackBarButtonItemClicked:(id)sender;
- (IBAction)didEditUserBarButtonClicked:(id)sender;
@end
