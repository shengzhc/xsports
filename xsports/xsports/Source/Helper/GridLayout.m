//
//  GridLayout.m
//  xsports
//
//  Created by Shengzhe Chen on 12/16/14.
//  Copyright (c) 2014 Shengzhe Chen. All rights reserved.
//

#import "GridLayout.h"

@implementation GridLayout

- (instancetype)init
{
    if (self = [super init]) {
        self.padding = 4.0;
    }
    return self;
}

- (CGFloat)oneColumnWidth
{
    return (self.collectionView.bounds.size.width - self.padding * 4)/3.0;
}

- (CGFloat)twoColumnWidth
{
    return self.collectionView.bounds.size.width - [self oneColumnWidth] - self.padding * 3;
}

- (CGSize)collectionViewContentSize
{
    NSUInteger count = [self.collectionView numberOfItemsInSection:0];
    if (count == 0) {
        return CGSizeMake(self.collectionView.bounds.size.width, 0);
    }
    NSUInteger rows = count/3;
    NSUInteger cols = count%3;
    CGFloat height = 0;
    CGFloat initialHeight = [self oneColumnWidth];
    CGFloat switchHeight = [self twoColumnWidth];
    for (int i=0; i<rows; i++) {
        height += (initialHeight + self.padding);
        CGFloat f = initialHeight;
        initialHeight = switchHeight;
        switchHeight = f;
    }
    if (cols > 0) {
        height += (self.padding + initialHeight);
    }
    height += self.padding;
    return CGSizeMake(self.collectionView.bounds.size.width, height);
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSInteger section = rect.origin.y/(self.padding*2+[self oneColumnWidth]+[self twoColumnWidth]);
    NSInteger i = (section+1)*6;
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    NSMutableArray *attributes = [NSMutableArray new];
    
    for (NSInteger j=MIN(i, count-1); j>=0; j--) {
        UICollectionViewLayoutAttributes *attribute = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:j inSection:0]];
        if (CGRectIntersectsRect(rect, attribute.frame)) {
            [attributes addObject:attribute];
        } else {
            break;
        }
    }
    for (NSInteger j=i; j<count; j++) {
        UICollectionViewLayoutAttributes *attribute = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:j inSection:0]];
        if (CGRectIntersectsRect(rect, attribute.frame)) {
            [attributes addObject:attribute];
        } else {
            break;
        }
    }
    
    return attributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attribute.frame = [self itemFrameAtIndexPath:indexPath];
    return attribute;
}

- (CGRect)itemFrameAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = (NSUInteger)indexPath.item/3;
    NSUInteger col = (NSUInteger)indexPath.item%3;
    CGRect frame = CGRectZero;
    CGFloat oneColumnWidth = [self oneColumnWidth];
    CGFloat twoColumnWidth = [self twoColumnWidth];

    if (row%2==0) {
        frame.size = CGSizeMake(oneColumnWidth, oneColumnWidth);
        frame.origin = CGPointMake(self.padding+col*([self oneColumnWidth]+self.padding), self.padding+(row/2)*(oneColumnWidth+twoColumnWidth+self.padding*2));
    } else {
        CGFloat top = self.padding+(row/2)*(oneColumnWidth+twoColumnWidth+self.padding*2) + oneColumnWidth + self.padding;
        if ((row/2+1)%2 == 0) {
            if (col == 2) {
                frame.size = CGSizeMake(twoColumnWidth, twoColumnWidth);
                frame.origin = CGPointMake(self.padding + oneColumnWidth + self.padding, top);
            } else {
                frame.size = CGSizeMake(oneColumnWidth, oneColumnWidth);
                frame.origin = CGPointMake(self.padding, top+col*(oneColumnWidth+self.padding));
            }
        } else {
            if (col == 0) {
                frame.size = CGSizeMake(twoColumnWidth, twoColumnWidth);
                frame.origin = CGPointMake(self.padding, top);
            } else {
                frame.size = CGSizeMake(oneColumnWidth, oneColumnWidth);
                frame.origin = CGPointMake(self.padding+twoColumnWidth+self.padding, top+(col-1)*(oneColumnWidth+self.padding));
            }
        }
    }
    return frame;
}

@end
