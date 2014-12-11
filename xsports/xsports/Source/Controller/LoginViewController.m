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
@property (strong, nonatomic) id stillImageFilter;
@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupBackground];
    [self setupTableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)setupBackground
{
    UIImage *inputImage = [UIImage imageNamed:@"login_bg.png"];
    GPUImagePicture *stillImageSource = [[GPUImagePicture alloc] initWithImage:inputImage];
    [stillImageSource addTarget:self.stillImageFilter];
    [self.stillImageFilter useNextFrameForImageCapture];
    [stillImageSource processImage];
    UIImage *currentFilteredVideoFrame = [self.stillImageFilter imageFromCurrentFramebuffer];
    self.backgroundImageView.image = currentFilteredVideoFrame;
}

- (void)setupTableView
{
    self.tableView.rowHeight = 44.0;
}

- (id)stillImageFilter
{
    if (_stillImageFilter == nil) {
        _stillImageFilter = [[GPUImageiOSBlurFilter alloc] init];
    }
    return _stillImageFilter;
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

@end
