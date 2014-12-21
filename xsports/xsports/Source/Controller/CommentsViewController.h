//
//  CommentsViewController.h
//  xsports
//
//  Created by Shengzhe Chen on 12/20/14.
//  Copyright (c) 2014 Shengzhe Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentsTextViewController.h"

@interface CommentsViewController : UIViewController
@property (strong, nonatomic) CommentsTextViewController *textViewController;
@property (strong, nonatomic) NSString *mediaId;
@end
