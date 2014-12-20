//
//  FeedViewPhotoCell.h
//  xsports
//
//  Created by Shengzhe Chen on 12/14/14.
//  Copyright (c) 2014 Shengzhe Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FeedViewPhotoCell;
@protocol FeedViewPhotoCellDelegate <NSObject>
@optional
- (void)feedViewPhotoCell:(FeedViewPhotoCell *)cell didLikeAmountButtonClicked:(id)sender;
- (void)feedViewPhotoCell:(FeedViewPhotoCell *)cell didCommentButtonClicked:(id)sender;
@end

@interface FeedViewPhotoCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIView *topContainer;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIView *topSeperator;

@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;

@property (weak, nonatomic) IBOutlet UIView *bottomContainer;
@property (weak, nonatomic) IBOutlet UIButton *likeAmountButton;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;

@property (strong, nonatomic) Media *media;
@property (weak, nonatomic) id < FeedViewPhotoCellDelegate > delegate;
@end
