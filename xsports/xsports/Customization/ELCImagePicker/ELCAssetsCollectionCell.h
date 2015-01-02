//
//  ELCAssetsCollectionCell.h
//  xsports
//
//  Created by Shengzhe Chen on 1/1/15.
//  Copyright (c) 2015 Shengzhe Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ELCAsset.h"

@interface ELCAssetsCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *assetImageView;
@property (weak, nonatomic) IBOutlet UIView *assetOverlayView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

- (void)setAsset:(ELCAsset *)asset;
- (void)setOverlayEnabled:(BOOL)isOverlayEnabled;

@end
