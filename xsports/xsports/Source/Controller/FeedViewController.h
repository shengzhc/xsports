//
//  FeedViewController.h
//  xsports
//
//  Created by Shengzhe Chen on 12/12/14.
//  Copyright (c) 2014 Shengzhe Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *headerActionButton;
- (IBAction)didHeaderActionButtonClicked:(id)sender;
@end
