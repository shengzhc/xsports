//
//  UserProfileToolSectionHeader.m
//  xsports
//
//  Created by Shengzhe Chen on 1/3/15.
//  Copyright (c) 2015 Shengzhe Chen. All rights reserved.
//

#import "UserProfileToolSectionHeader.h"

@interface UserProfileToolSectionHeader ()
@property (weak, nonatomic) IBOutlet UIButton *gridButton;
@property (weak, nonatomic) IBOutlet UIButton *listButton;
@property (weak, nonatomic) IBOutlet UIView *seperator;
@end

@implementation UserProfileToolSectionHeader

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setupViews];
    [self setupButtons];
}

- (void)setupButtons
{
    [self.gridButton setTitleColor:[UIColor cGrayColor] forState:UIControlStateSelected | UIControlStateHighlighted];
    [self.gridButton setTitleColor:[UIColor cDarkYellowColor] forState:UIControlStateNormal];
    [self.gridButton setTitle:GET_STRING(@"grid") forState:UIControlStateNormal];
    
    [self.listButton setTitleColor:[UIColor cGrayColor] forState:UIControlStateSelected | UIControlStateHighlighted];
    [self.listButton setTitle:GET_STRING(@"list") forState:UIControlStateNormal];
    [self.listButton setTitleColor:[UIColor cDarkYellowColor] forState:UIControlStateNormal];
}

- (void)setupViews
{
    self.backgroundColor = [UIColor cYellowColor];
    self.seperator.backgroundColor = [UIColor cLightGrayColor];
}

#pragma mark Action
- (IBAction)didGridButtonClicked:(id)sender
{
    self.gridButton.selected = !self.gridButton.selected;
}

- (IBAction)didListButtonClicked:(id)sender
{
    self.listButton.selected = !self.listButton.selected;
}

@end
