//
//  FeedFlowCollectionViewController.h
//  xsports
//
//  Created by Shengzhe Chen on 12/17/14.
//  Copyright (c) 2014 Shengzhe Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedFlowCollectionViewController : UICollectionViewController
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;
@property (strong, nonatomic) NSArray *feeds;
@end
