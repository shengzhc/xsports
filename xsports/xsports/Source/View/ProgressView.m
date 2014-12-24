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
    self.cursorWidth = 8.0;
    self.seperatorWidth = 2.0;
    _progress = 0.6;
    _seperator = 0.4;
    
    self.seperatorView = [[UIView alloc] init];
    self.seperatorView.translatesAutoresizingMaskIntoConstraints = NO;
    self.seperatorView.backgroundColor = [UIColor lightCoralColor];
    [self addSubview:self.seperatorView];
    
    self.cursorView = [[UIView alloc] init];
    self.cursorView.translatesAutoresizingMaskIntoConstraints = NO;
    self.cursorView.backgroundColor = [UIColor textFieldCursorColor];
    [self addSubview:self.cursorView];
    
    self.progressView = [[UIView alloc] init];
    self.progressView.translatesAutoresizingMaskIntoConstraints = NO;
    self.progressView.backgroundColor = [[UIColor lightWaveColor] colorWithAlphaComponent:0.5];
    [self addSubview:self.progressView];
}

- (void)setProgress:(CGFloat)progress
{
    _progress = MAX(0, MIN(progress, 1.0));
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

- (void)setSeperator:(CGFloat)seperator
{
    _seperator = MAX(0, MIN(seperator, 1.0));
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

- (void)updateConstraints
{
    [super updateConstraints];
    [self.seperatorView removeConstraints:self.seperatorView.constraints];
    [self.cursorView removeConstraints:self.cursorView.constraints];
    NSDictionary *views = @{@"cursor": self.cursorView, @"seperator": self.seperatorView, @"progressView": self.progressView};
    
    CGFloat cursorLeft = self.bounds.size.width*self.progress - self.cursorWidth/2.0;
    CGFloat seperatorLeft = self.bounds.size.width*self.seperator - self.seperatorWidth/2.0;
    NSDictionary *metrics = @{@"cursorLeft": @(cursorLeft), @"cursorWidth": @(self.cursorWidth), @"seperatorLeft": @(seperatorLeft), @"seperatorWidth": @(self.seperatorWidth)};

    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[cursor]|" options:0 metrics:metrics views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(cursorLeft)-[cursor(cursorWidth)]" options:0 metrics:metrics views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[seperator]|" options:0 metrics:metrics views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(seperatorLeft)-[seperator(seperatorWidth)]" options:0 metrics:metrics views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[progressView]|" options:0 metrics:metrics views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[progressView]-(0)-[cursor]" options:0 metrics:metrics views:views]];
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
