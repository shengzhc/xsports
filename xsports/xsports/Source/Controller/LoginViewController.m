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

@interface LoginViewController ()
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
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

- (IBAction)didValueChanged:(id)sender
{
    if ([sender isKindOfClass:[UITextField class]]) {
        UITextField *textField = (UITextField *)sender;
        if (textField.tag == LoginEmailTextFieldTag) {
            self.m_email = textField.text;
        } else if (textField.tag == LoginPasswordTextFieldTag) {
            self.m_password = textField.text;
        }
    }
}

#pragma mark Keyboard
- (void)keyboardWillShow:(NSNotification *)notification
{
    UIEdgeInsets insets = self.tableView.contentInset;
    insets.top -= KEYBOARD_OFFSET;
    [self.tableView setContentInset:insets];
}

- (void)keyboardDidHide:(NSNotification *)notification
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

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationPortrait | UIInterfaceOrientationPortraitUpsideDown;
}

@end
