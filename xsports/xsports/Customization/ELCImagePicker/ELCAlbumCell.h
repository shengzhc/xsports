//
//  ELCAlbumCell.h
//  xsports
//
//  Created by Shengzhe Chen on 1/1/15.
//  Copyright (c) 2015 Shengzhe Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ELCAlbumCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *albumImageView;
@property (weak, nonatomic) IBOutlet UILabel *albumTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *assetsCountLabel;
@end
