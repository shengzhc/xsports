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

#define KEYBOARD_OFFSET 28.0
#define LoginEmailTextFieldTag 100
#define LoginPasswordTextFieldTag 101

@interface LoginViewController () < UITextFieldDelegate >
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonContainerTopConstraint;
@property (strong, nonatomic) NSString *m_email;
@property (strong, nonatomic) NSString *m_password;
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma Setup
- (void)setupTableView
{
    self.tableView.rowHeight = 44.0;
    self.tableView.contentInset = UIEdgeInsetsMake([UIScreen height]/2.0 - self.tableView.rowHeight, 0, 0, 0);
}

- (void)setupButtons
{
    self.buttonContainerTopConstraint.constant = self.tableView.rowHeight * 2.0 + self.tableView.contentInset.top + 24.0;
    self.signInButton.backgroundColor = [UIColor lightWaveColor];
    self.signInButton.titleLabel.font = [UIFont mediumEngFontWithSize:18.0];

    self.signUpButton.backgroundColor = [UIColor lightJadeColor];
    self.signUpButton.titleLabel.font = [UIFont mediumEngFontWithSize:18.0];
}

#pragma mark Logic
- (void)signIn
{
    if ([NSPredicate validateEmail:self.m_email] && self.m_password.length >= 4) {
        [self showLoadingIndicator];
    } else {
        SIAlertView *alertView = [self cancelAlertViewWithTitle:nil message:@"Email or Password is incorrect..."];
        [alertView show];
    }
}

- (void)signUp
{
    SIAlertView *alertView = [self cancelAlertViewWithTitle:nil message:@"Please waiting for the new Feature..."];
    [alertView show];
}

#pragma mark Button Action
- (IBAction)didSignInButtonClicked:(id)sender
{
    [self signIn];
}

- (IBAction)didSignUpButtonClicked:(id)sender
{
    [self signUp];
}

#pragma mark Keyboard
- (void)keyboardWillShow:(NSNotification *)notification
{
    UIEdgeInsets insets = self.tableView.contentInset;
    insets.top -= KEYBOARD_OFFSET;
    [self.tableView setContentInset:insets];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    UIEdgeInsets insets = self.tableView.contentInset;
    insets.top += KEYBOARD_OFFSET;
    [self.tableView setContentInset:insets];
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
        cell.textField.text = self.m_email;
        return cell;
    } else if (indexPath.row == 1) {
        LoginPasswordCell *cell = [tableView dequeueReusableCellWithIdentifier:LoginPasswordCellIdentifier forIndexPath:indexPath];
        cell.textField.text = self.m_password;
        return cell;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    for (UITableViewCell *item in tableView.visibleCells) {
        if ([tableView indexPathForCell:cell].row == indexPath.row) {
            cell = item;
            break;
        }
    }
    
    if (cell != nil) {
        if ([cell isKindOfClass:[LoginEmailCell class]]) {
            [((LoginEmailCell *)cell).textField becomeFirstResponder];
        } else if ([cell isKindOfClass:[LoginPasswordCell class]]) {
            [((LoginPasswordCell *)cell).textField becomeFirstResponder];
        }
    }
}

#pragma mark UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.tag == LoginEmailTextFieldTag) {
        NSString *email = [textField.text stringByReplacingCharactersInRange:range withString:string];
        LoginEmailCell *cell = (LoginEmailCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        if ((email && email.length > 0 && [NSPredicate validateEmail:email]) || (email.length == 0)) {
            if (cell.warningImageView.alpha != 0) {
                [UIView animateWithDuration:0.2 animations:^{
                    cell.warningImageView.alpha = 0;
                }];
            }
        } else {
            if (cell.warningImageView.alpha != 1.0) {
                [UIView animateWithDuration:0.2 animations:^{
                    cell.warningImageView.alpha = 1.0;
                }];
            }
        }
        self.m_email = email;
        return YES;
    } else if (textField.tag == LoginPasswordTextFieldTag) {
        NSString *password = [textField.text stringByReplacingCharactersInRange:range withString:string];
        LoginPasswordCell *cell = (LoginPasswordCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        if ((password && password.length >= 4) || (password.length == 0)) {
            if (cell.warningImageView.alpha != 0) {
                [UIView animateWithDuration:0.2 animations:^{
                    cell.warningImageView.alpha = 0;
                }];
            }
        } else {
            if (cell.warningImageView.alpha != 1.0) {
                [UIView animateWithDuration:0.2 animations:^{
                    cell.warningImageView.alpha = 1.0;
                }];
            }
        }
        if (password.length >= 12) {
            return NO;
        }
        self.m_password = password;
        return YES;
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.tag == LoginEmailTextFieldTag) {
        LoginPasswordCell *cell = (LoginPasswordCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        [cell.textField becomeFirstResponder];
    } else if (textField.tag == LoginPasswordTextFieldTag) {
        [textField resignFirstResponder];
    }
    return YES;
}


- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationPortrait | UIInterfaceOrientationPortraitUpsideDown;
}

@end
