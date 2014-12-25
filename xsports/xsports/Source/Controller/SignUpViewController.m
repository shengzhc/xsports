//
//  SignUpViewController.m
//  xsports
//
//  Created by Shengzhe Chen on 12/24/14.
//  Copyright (c) 2014 Shengzhe Chen. All rights reserved.
//

#import "SignUpViewController.h"

#import "LoginEmailCell.h"
#import "LoginPasswordCell.h"
#import "SignupAccountCell.h"

#define KEYBOARD_OFFSET 28.0
#define LoginEmailTextFieldTag 100
#define LoginPasswordTextFieldTag 101
#define SignUpNameTextFieldTag 102

@interface SignUpViewController () < UITableViewDataSource, UITableViewDelegate >
@property (weak, nonatomic) IBOutlet UILabel *createLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *signUpTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *createLabelTopConstraint;
@property (strong, nonatomic) NSString *m_email;
@property (strong, nonatomic) NSString *m_password;
@property (strong, nonatomic) NSString *m_name;

@property (strong, nonatomic) FadingInOutTransitioningDelegate *fadingTransitionDelegate;
@end

@implementation SignUpViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupTableView];
    [self setupButtons];
    [self setupLabels];
    [self setupFadingTransitioningDelegate];
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
    self.tableView.contentInset = UIEdgeInsetsMake([UIScreen height]/2.0 - self.tableView.rowHeight*[self.tableView numberOfRowsInSection:0], 0, 0, 0);
}

- (void)setupButtons
{
    self.signUpTopConstraint.constant = self.tableView.rowHeight*[self.tableView numberOfRowsInSection:0] + self.tableView.contentInset.top + 100;
    self.signUpButton.backgroundColor = [UIColor cYellowColor];
    self.signUpButton.titleLabel.font = [UIFont regularFontWithSize:14.0];
    [self.signUpButton setTitle:GET_STRING(@"signup") forState:UIControlStateNormal];
    [self.signUpButton setTitleColor:[UIColor cGrayColor] forState:UIControlStateNormal];
}

- (void)setupLabels
{
    self.createLabel.text = GET_STRING(@"signup_create_account");
    self.createLabel.font = [UIFont chnRegularFontWithSize:28];
    self.createLabel.textColor = [UIColor cYellowColor];
    self.createLabelTopConstraint.constant = self.tableView.contentInset.top/2.0 - 16.0;
}

- (void)setupFadingTransitioningDelegate
{
    self.modalPresentationStyle = UIModalPresentationCustom;
    self.fadingTransitionDelegate = [[FadingInOutTransitioningDelegate alloc] init];
    self.transitioningDelegate = self.fadingTransitionDelegate;
}

#pragma mark Logic
- (void)signUp
{
    if (self.m_name.length > 0 && [NSPredicate validateEmail:self.m_email] && self.m_password.length > 3) {
        LoadingViewController *loadingViewController = [self showLoadingIndicator];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [loadingViewController dismissViewControllerAnimated:YES completion:self.completionHandler];
        });
    } else {
        SIAlertView *alertView = [self cancelAlertViewWithTitle:GET_STRING(@"error")message:GET_STRING(@"signup_error_msg")];
        [alertView show];
    }
}

#pragma mark Button Action
- (IBAction)didSignUpButtonClicked:(id)sender
{
    [self signUp];
}

- (IBAction)didCloseButtonClicked:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1) {
        LoginEmailCell *cell = [tableView dequeueReusableCellWithIdentifier:LoginEmailCellIdentifier forIndexPath:indexPath];
        cell.textField.text = self.m_email;
        return cell;
    } else if (indexPath.row == 2) {
        LoginPasswordCell *cell = [tableView dequeueReusableCellWithIdentifier:LoginPasswordCellIdentifier forIndexPath:indexPath];
        cell.textField.text = self.m_password;
        return cell;
    } else if (indexPath.row == 0) {
        SignupAccountCell *cell = [tableView dequeueReusableCellWithIdentifier:SignupAccountCellIdentifier forIndexPath:indexPath];
        cell.textField.text = self.m_name;
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
        } else if ([cell isKindOfClass:[SignupAccountCell class]]) {
            [((SignupAccountCell *)cell).textField becomeFirstResponder];
        }
    }
}

#pragma mark UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.tag == LoginEmailTextFieldTag) {
        NSString *email = [textField.text stringByReplacingCharactersInRange:range withString:string];
        LoginEmailCell *cell = (LoginEmailCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
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
        LoginPasswordCell *cell = (LoginPasswordCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
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
    } else if (textField.tag == SignUpNameTextFieldTag) {
        NSString *name = [textField.text stringByReplacingCharactersInRange:range withString:string];
        self.m_name = name;
        return YES;
    }

    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.tag == SignUpNameTextFieldTag) {
        LoginEmailCell *cell = (LoginEmailCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        [cell.textField becomeFirstResponder];
    } else if (textField.tag == LoginEmailTextFieldTag) {
        LoginPasswordCell *cell = (LoginPasswordCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
        [cell.textField becomeFirstResponder];
    } else if (textField.tag == LoginPasswordTextFieldTag) {
        [textField resignFirstResponder];
    }
    return YES;
}

@end
