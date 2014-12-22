//
//  CamScrollView.m
//  xsports
//
//  Created by Shengzhe Chen on 12/22/14.
//  Copyright (c) 2014 Shengzhe Chen. All rights reserved.
//

#import "CamScrollView.h"

@interface CamScrollView () < UIScrollViewDelegate, UIGestureRecognizerDelegate >
@property (strong, nonatomic) UIView *pageOneContainer;
@property (strong, nonatomic) UIView *pageTwoContainer;
@property (strong, nonatomic) UIPanGestureRecognizer *restrictionPanGestureRecognizer;
@property (assign, nonatomic) CGRect lastFrame;
@end

@implementation CamScrollView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self commonInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

- (id)init
{
    if (self = [super init]) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    self.delegate = self;
    
    self.restrictionPanGestureRecognizer = [[UIPanGestureRecognizer alloc] init];
    self.restrictionPanGestureRecognizer.delegate = self;
    [self addGestureRecognizer:self.restrictionPanGestureRecognizer];
    [self.panGestureRecognizer requireGestureRecognizerToFail:self.restrictionPanGestureRecognizer];
    
    self.pageOneContainer = [[UIView alloc] init];
    self.pageTwoContainer = [[UIView alloc] init];
    self.pageOneContainer.backgroundColor = [UIColor clearColor];
    self.pageTwoContainer.backgroundColor = [UIColor clearColor];
    [self addSubview:self.pageOneContainer];
    [self addSubview:self.pageTwoContainer];
    
    self.picGalleryButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.picGalleryButton.layer.cornerRadius = 5.0;
    self.picGalleryButton.layer.masksToBounds = YES;
    [self.picGalleryButton setImage:[UIImage imageNamed:@"ico_cam_grid_white"] forState:UIControlStateNormal];
    [self.picGalleryButton setImage:[UIImage imageNamed:@"ico_cam_grid_green"] forState:UIControlStateSelected|UIControlStateHighlighted];
    [self.picGalleryButton addTarget:self action:@selector(didPicGalleryButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.pageOneContainer addSubview:self.picGalleryButton];
    
    self.stillCaptureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.stillCaptureButton setImage:[UIImage imageNamed:@"ico_snap"] forState:UIControlStateNormal];
    [self.stillCaptureButton addTarget:self action:@selector(didStillCaptureButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.pageOneContainer addSubview:self.stillCaptureButton];

    self.mediaSwitchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.mediaSwitchButton setImage:[UIImage imageNamed:@"ico_media_video"] forState:UIControlStateNormal];
    [self.mediaSwitchButton addTarget:self action:@selector(didMediaSwitchButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.mediaSwitchButton];

    self.recordCaptureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.recordCaptureButton setImage:[UIImage imageNamed:@"ico_record"] forState:UIControlStateNormal];
    [self.recordCaptureButton addTarget:self action:@selector(didRecordCaptureButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.pageTwoContainer addSubview:self.recordCaptureButton];
    
    self.videoGalleryButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.videoGalleryButton.layer.cornerRadius = 5.0;
    self.videoGalleryButton.layer.masksToBounds = YES;
    [self.videoGalleryButton setImage:[UIImage imageNamed:@"ico_cam_grid_white"] forState:UIControlStateNormal];
    [self.videoGalleryButton setImage:[UIImage imageNamed:@"ico_cam_grid_green"] forState:UIControlStateSelected|UIControlStateHighlighted];
    [self.videoGalleryButton addTarget:self action:@selector(didVideoGalleryButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.pageTwoContainer addSubview:self.videoGalleryButton];
}

- (void)resetScrollView
{
    self.scrollEnabled = YES;
    self.pagingEnabled = YES;
    self.directionalLockEnabled = YES;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.minimumZoomScale = self.maximumZoomScale = 1.0;
    self.zoomScale = 1.0;
    
    CGSize smallButtonSize = CGSizeMake(64, 64);
    CGSize largeButtonSize = CGSizeMake(80, 80);
    CGFloat padding = (self.bounds.size.width - smallButtonSize.width*2 - largeButtonSize.width)/4.0;
    CGFloat centerY = self.bounds.size.height/2.0;
    
    self.contentSize = CGSizeMake(smallButtonSize.width*3+largeButtonSize.width*2+6*padding, self.bounds.size.height);
    self.pageOneContainer.frame = CGRectMake(0, 0, self.contentSize.width - self.bounds.size.width/2.0, self.bounds.size.height);
    self.pageTwoContainer.frame = CGRectMake(self.contentSize.width - self.pageOneContainer.frame.size.width, 0, self.contentSize.width - self.bounds.size.width/2.0, self.bounds.size.height);
    
    self.stillCaptureButton.frame = CGRectMake(self.bounds.size.width/2.0 - largeButtonSize.width/2.0, self.pageOneContainer.bounds.size.height/2.0 - largeButtonSize.height/2.0, largeButtonSize.width, largeButtonSize.height);
    self.mediaSwitchButton.frame = CGRectMake(self.contentSize.width/2.0 - smallButtonSize.width/2.0, self.contentSize.height/2.0 - smallButtonSize.height/2.0, smallButtonSize.width, smallButtonSize.height);
    self.recordCaptureButton.frame = CGRectMake(self.pageTwoContainer.bounds.size.width - self.bounds.size.width/2.0 - largeButtonSize.width/2.0, self.pageTwoContainer.bounds.size.height/2.0 - largeButtonSize.height/2.0, largeButtonSize.width, largeButtonSize.height);
    self.picGalleryButton.frame = CGRectMake(padding, centerY-smallButtonSize.height/2.0, smallButtonSize.width, smallButtonSize.height);
    self.videoGalleryButton.frame = CGRectMake(self.recordCaptureButton.frame.origin.x+self.recordCaptureButton.frame.size.width+padding, centerY-smallButtonSize.height/2.0, smallButtonSize.width, smallButtonSize.height);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (!CGRectEqualToRect(self.frame, self.lastFrame)) {
        [self resetScrollView];
    }
}

- (CGRect)rectAtPage:(NSInteger)pageIndex
{
    if (pageIndex <= 0) {
        return CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    } else {
        return CGRectMake(self.contentSize.width-self.bounds.size.width, 0, self.bounds.size.width, self.bounds.size.height);
    }
}

- (NSInteger)pageOfContentOffset:(CGPoint)contentOffset
{
    if (self.mediaSwitchButton.center.x - contentOffset.x > self.bounds.size.width/2.0) {
        return 0;
    }
    return 1;
}

- (void)didScrollEndAtPageIndex:(NSInteger)pageIndex
{
    if (pageIndex == 0) {
        [self.mediaSwitchButton setImage:[UIImage imageNamed:@"ico_media_video"] forState:UIControlStateNormal];
    } else {
        [self.mediaSwitchButton setImage:[UIImage imageNamed:@"ico_media_photo"] forState:UIControlStateNormal];
    }
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        NSInteger pageIndex = [self pageOfContentOffset:scrollView.contentOffset];
        [self didScrollEndAtPageIndex:pageIndex];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger pageIndex = [self pageOfContentOffset:scrollView.contentOffset];
    [self didScrollEndAtPageIndex:pageIndex];
}

#pragma mark UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer == self.restrictionPanGestureRecognizer) {
        CGPoint touchLocation = [self.restrictionPanGestureRecognizer locationInView:self];
        if (CGRectContainsPoint(self.pageOneContainer.frame, touchLocation) && CGRectContainsPoint(self.pageTwoContainer.frame, touchLocation)) {
            return NO;
        }
        return YES;
    }
    
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return NO;
}

#pragma mark Action
- (void)didPicGalleryButtonClicked:(id)sender
{
}

- (void)didStillCaptureButtonClicked:(id)sender
{
}

- (void)didMediaSwitchButtonClicked:(id)sender
{
    
}

- (void)didRecordCaptureButtonClicked:(id)sender
{
    
}

- (void)didVideoGalleryButtonClicked:(id)sender
{
    
}

@end
