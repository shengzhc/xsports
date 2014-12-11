//
//  LoginViewController.m
//  xsports
//
//  Created by Shengzhe Chen on 12/11/14.
//  Copyright (c) 2014 Shengzhe Chen. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginEmailCell.h"
#import "LoginPasswordCell.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonContainerTopConstraint;
@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupTableView];
    [self setupButtons];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)setupTableView
{
    self.tableView.rowHeight = 44.0;
    self.tableView.contentInset = UIEdgeInsetsMake([UIScreen height]/2.0 - self.tableView.rowHeight, 0, 0, 0);
}

- (void)setupButtons
{
    self.buttonContainerTopConstraint.constant = self.tableView.rowHeight * 2.0 + self.tableView.contentInset.top + 24.0;
    self.signInButton.backgroundColor = [UIColor lightWaveColor];
    self.signInButton.titleLabel.font = [UIFont fontWithName:@"Futura-Medium" size:18.0];

    self.signUpButton.backgroundColor = [UIColor lightJadeColor];
    self.signUpButton.titleLabel.font = [UIFont fontWithName:@"Futura-Medium" size:18.0];
}

#pragma mark Button Action
- (IBAction)didSignInButtonClicked:(id)sender
{
}

- (IBAction)didSignUpButtonClicked:(id)sender
{
}

#pragma mark UITableViewDelegate & UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        LoginEmailCell *cell = [tableView dequeueReusableCellWithIdentifier:LoginEmailCellIdentifier forIndexPath:indexPath];
        return cell;
    } else if (indexPath.row == 1) {
        LoginPasswordCell *cell = [tableView dequeueReusableCellWithIdentifier:LoginPasswordCellIdentifier forIndexPath:indexPath];
        return cell;
    }
    
    return nil;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationPortrait | UIInterfaceOrientationPortraitUpsideDown;
}

@end
