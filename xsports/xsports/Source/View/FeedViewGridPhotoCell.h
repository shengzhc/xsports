//
//  FeedViewGridPhotoCell.h
//  xsports
//
//  Created by Shengzhe Chen on 12/16/14.
//  Copyright (c) 2014 Shengzhe Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedViewGridPhotoCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (strong, nonatomic) Media *media;
@end
