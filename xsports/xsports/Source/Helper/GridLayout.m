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
    CGSize size = [super collectionViewContentSize];
    return size;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray *attributes = [super layoutAttributesForElementsInRect:rect];
    NSMutableArray *nAttribute = [NSMutableArray new];
    for (UICollectionViewLayoutAttributes *attribute in attributes) {
        [nAttribute addObject:[self layoutAttributesForItemAtIndexPath:attribute.indexPath]];
    }
    return nAttribute;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attribute = [super layoutAttributesForItemAtIndexPath:indexPath];
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
