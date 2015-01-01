//
//  ProgressView.m
//  xsports
//
//  Created by Shengzhe Chen on 12/23/14.
//  Copyright (c) 2014 Shengzhe Chen. All rights reserved.
//

#import "ProgressView.h"

@interface ProgressView ()
@property (assign, nonatomic) CGFloat cursorWidth;
@property (assign, nonatomic) CGFloat seperatorWidth;
@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) NSLayoutConstraint *progressWidthConstraint;
@end

@implementation ProgressView

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
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.cursorWidth = 6.0;
    self.seperatorWidth = 1.0;
    _progress = 0.6;
    _seperator = 0.4;
    
    self.seperatorView = [[UIView alloc] init];
    self.seperatorView.translatesAutoresizingMaskIntoConstraints = NO;
    self.seperatorView.backgroundColor = [UIColor cLightGrayColor];
    [self addSubview:self.seperatorView];
    
    self.cursorView = [[UIView alloc] init];
    self.cursorView.translatesAutoresizingMaskIntoConstraints = NO;
    self.cursorView.backgroundColor = [UIColor cYellowColor];
    [self addSubview:self.cursorView];
    
    self.progressView = [[UIView alloc] init];
    self.progressView.translatesAutoresizingMaskIntoConstraints = NO;
    self.progressView.backgroundColor = [UIColor lightWaveColor];
    [self addSubview:self.progressView];
    
    [self setupConstraints];
}

- (void)setupConstraints
{
    NSDictionary *views = @{@"cursor": self.cursorView, @"seperator": self.seperatorView, @"progressView": self.progressView};
    CGFloat cursorLeft = MAX(self.bounds.size.width*self.progress - self.cursorWidth/2.0, 0);
    CGFloat seperatorLeft = MAX(self.bounds.size.width*self.seperator - self.seperatorWidth/2.0, 0);
    NSDictionary *metrics = @{@"cursorLeft": @(cursorLeft), @"cursorWidth": @(self.cursorWidth), @"seperatorLeft": @(seperatorLeft), @"seperatorWidth": @(self.seperatorWidth)};
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[cursor]|" options:0 metrics:metrics views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[seperator]|" options:0 metrics:metrics views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[progressView]|" options:0 metrics:metrics views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(seperatorLeft)-[seperator(seperatorWidth)]" options:0 metrics:metrics views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[progressView]-(0)-[cursor(cursorWidth)]" options:0 metrics:metrics views:views]];
    self.progressWidthConstraint = [NSLayoutConstraint constraintWithItem:self.progressView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:0];
    [self addConstraint:self.progressWidthConstraint];
}

- (void)setProgress:(CGFloat)progress
{
    _progress = MAX(0, MIN(progress, 1.0));
    self.progressWidthConstraint.constant = MIN(MAX(0, self.bounds.size.width*_progress), self.bounds.size.width-self.cursorWidth);
}

- (void)setSeperator:(CGFloat)seperator
{
    _seperator = MAX(0, MIN(seperator, 1.0));
}

- (void)startAnimation
{
    [self stopAnimation];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.75 target:self selector:@selector(flash) userInfo:nil repeats:YES];
}

- (void)stopAnimation
{
    [self.timer invalidate];
    self.timer = nil;
}

- (void)flash
{
    self.cursorView.hidden = !self.cursorView.hidden;
}

@end
