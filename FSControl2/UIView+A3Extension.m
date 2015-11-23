//
//  UIView+A3Extension.m
//  FSControl2
//
//  Created by mac on 15/11/23.
//  Copyright © 2015年 mac. All rights reserved.
//

#import "UIView+A3Extension.h"

@implementation UIView (A3Extension)

/** frame.origin.x */
- (void)setX:(CGFloat)x
{
    CGRect frame   = self.frame;
    frame.origin.x = x;
    self.frame     = frame;
}
/** frame.origin.x */
- (CGFloat)x
{
    return  self.frame.origin.x;
}

/** frame.origin.y */
- (void)setY:(CGFloat)y
{
    CGRect frame   = self.frame;
    frame.origin.y = y;
    self.frame     = frame;
}

- (CGFloat)y
{
    return  self.frame.origin.y;
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame     = self.frame;
    frame.size.width = width;
    self.frame       = frame;
}
/** frame.size.width */
- (CGFloat)width
{
    return  self.frame.size.width;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame      = self.frame;
    frame.size.height = height;
    self.frame        = frame;
    
}
/** frame.size.height */
- (CGFloat)height
{
    return  self.frame.size.height;
}

- (void)setCenterX:(CGFloat)centerX
{
    CGPoint center = self.center;
    center.x       = centerX;
    self.center    = center;
}
/** center.x */
- (CGFloat)centerX
{
    return self.center.x;
}

- (void)setCenterY:(CGFloat)centerY
{
    CGPoint center = self.center;
    center.y       = centerY;
    self.center    = center;
}
/** center.y */
- (CGFloat)centerY
{
    return self.center.y;
}


@end
