//
//  ELCAssetsCollectionCell.m
//  xsports
//
//  Created by Shengzhe Chen on 1/1/15.
//  Copyright (c) 2015 Shengzhe Chen. All rights reserved.
//

#import "ELCAssetsCollectionCell.h"

@implementation ELCAssetsCollectionCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.assetOverlayView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    self.assetOverlayView.layer.borderColor = [UIColor lightWaveColor].CGColor;
    self.assetOverlayView.layer.borderWidth = 4.0;
    self.timeLabel.font = [UIFont chnRegularFontWithSize:8.0];
}

- (void)setAsset:(ELCAsset *)asset
{
    self.assetImageView.image = [UIImage imageWithCGImage:asset.asset.thumbnail];
    self.assetOverlayView.alpha = asset.selected ? 1.0 : 0.0;
    long duration = [[asset.asset valueForProperty:ALAssetPropertyDuration] longValue];

    if (duration > 0) {
        self.timeLabel.text = [NSDate shortshortFormatFromSeconds:duration];
    } else {
        self.timeLabel.text = nil;
    }
}

- (void)setOverlayEnabled:(BOOL)isOverlayEnabled
{
    CGFloat alpha = isOverlayEnabled ? 1.0 : 0.0;
    [UIView animateWithDuration:0.5 animations:^{
        self.assetOverlayView.alpha = alpha;
    } completion:^(BOOL finished) {
        self.assetOverlayView.alpha = alpha;
    }];
}

@end
