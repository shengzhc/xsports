//
//  UserProfileToolSectionHeader.m
//  xsports
//
//  Created by Shengzhe Chen on 1/3/15.
//  Copyright (c) 2015 Shengzhe Chen. All rights reserved.
//

#import "UserProfileToolSectionHeader.h"

@interface UserProfileToolSectionHeader ()
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
    self.gridButton.titleLabel.font = [UIFont chnRegularFont];
    [self.gridButton setTitleColor:[UIColor cDarkYellowColor] forState:UIControlStateNormal];
    [self.gridButton setTitle:GET_STRING(@"grid") forState:UIControlStateNormal];
    
    [self.listButton setTitleColor:[UIColor cGrayColor] forState:UIControlStateSelected | UIControlStateHighlighted];
    self.listButton.titleLabel.font = [UIFont chnRegularFont];
    [self.listButton setTitle:GET_STRING(@"list") forState:UIControlStateNormal];
    [self.listButton setTitleColor:[UIColor cDarkYellowColor] forState:UIControlStateNormal];
}

- (void)setupViews
{
    self.backgroundColor = [UIColor cYellowColor];
    self.seperator.backgroundColor = [[UIColor cLightGrayColor] colorWithAlphaComponent:0.7];
}

#pragma mark Action
- (IBAction)didGridButtonClicked:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(userProfileToolSectionHeader:didGridButtonClicked:)]) {
        [self.delegate userProfileToolSectionHeader:self didGridButtonClicked:sender];
    }
}

- (IBAction)didListButtonClicked:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(userProfileToolSectionHeader:didListButtonClicked:)]) {
        [self.delegate userProfileToolSectionHeader:self didListButtonClicked:sender];
    }
}

@end
