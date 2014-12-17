//
//  GridLayout.m
//  xsports
//
//  Created by Shengzhe Chen on 12/16/14.
//  Copyright (c) 2014 Shengzhe Chen. All rights reserved.
//

#import "GridLayout.h"

@implementation GridLayout

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
    CGFloat width = self.collectionView.bounds.size.width;
    int row = (int)indexPath.item/3;
    int col = (int)indexPath.item%3;
    if (row % 2 ==0 ) {
        CGRect frame = CGRectMake(0, 0, width/3.0, width/3.0);
        CGFloat x = col*width/3.0;
        CGFloat y = (row/2) * width;
        frame.origin = CGPointMake(x, y);
        attribute.frame = frame;
    } else {
        if (col == 0) {
            CGRect frame = CGRectMake(0, 0, width*2.0/3.0, width*2.0/3.0);
            CGFloat x = 0;
            CGFloat y = (row-1)/2*width + width/3.0;
            frame.origin = CGPointMake(x, y);
            attribute.frame = frame;
        } else {
            CGRect frame = CGRectMake(0, 0, width/3.0, width/3.0);
            CGFloat x = width*2.0/3.0;
            CGFloat y = (row-1)/2*width + width/3.0+(col-1)*width/3.0;
            frame.origin = CGPointMake(x, y);
            attribute.frame = frame;
        }
    }
    
    return attribute;
}

@end
