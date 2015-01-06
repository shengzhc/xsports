//
//  MenuViewCell.h
//  xsports
//
//  Created by Shengzhe Chen on 12/12/14.
//  Copyright (c) 2014 Shengzhe Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *topSeperator;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *iconTextLabel;
@property (weak, nonatomic) IBOutlet UIView *seperator;
@end
