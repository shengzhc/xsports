//
//  ELCAssetsCollectionHeaderCell.m
//  xsports
//
//  Created by Shengzhe Chen on 1/1/15.
//  Copyright (c) 2015 Shengzhe Chen. All rights reserved.
//

#import "ELCAssetsCollectionHeaderCell.h"

@interface ELCAssetsCollectionHeaderCell ()
@end

@implementation ELCAssetsCollectionHeaderCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.titleLabel.font = [UIFont chnRegularFont];
    self.titleLabel.textColor = [UIColor whiteColor];
}

- (IBAction)didBackButtonClicked:(id)sender
{
    if (self.backBlock) {
        self.backBlock();
    }
}

@end
