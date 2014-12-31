//
//  CamCurtainViewController.h
//  xsports
//
//  Created by Shengzhe Chen on 12/30/14.
//  Copyright (c) 2014 Shengzhe Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CamCurtainViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *topCurtain;
@property (weak, nonatomic) IBOutlet UIView *bottomCurtain;

- (void)closeCurtainWithCompletionHandler:(void (^)(void))completionHandler;


- (void)openCurtainWithCompletionHandler:(void (^)(void))completionHandler;
- (void)openCurtainWithPercent:(CGFloat)percent;

@end
