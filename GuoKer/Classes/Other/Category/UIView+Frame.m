//
//  UIView+Frame.m
//  LM彩票(storyboard)
//
//  Created by Lumo on 14/5/21.
//  Copyright (c) 2015年 LM. All rights reserved.
//

#import "UIView+Frame.h"

@implementation UIView (Frame)

- (void)setX:(CGFloat)x
{
    CGRect temp = self.frame ;
    
    temp.origin.x = x ;
    
    self.frame = temp ;
}

- (CGFloat)x
{
    return  self.frame.origin.x ;
}

- (void)setY:(CGFloat)y
{
    CGRect temp = self.frame ;
    
    temp.origin.y = y  ;
    
    self.frame = temp ;
}

- (CGFloat)y
{
    return  self.frame.origin.y ;
}

- (void)setWidth:(CGFloat)width
{
    CGRect temp = self.frame ;
    
    temp.size.width = width  ;
    
    self.frame = temp ;
}

- (CGFloat)width
{
    return  self.frame.size.width;
}

- (void)setHeight:(CGFloat)height
{
    CGRect temp = self.frame ;
    
    temp.size.height = height  ;
    
    self.frame = temp ;
}

- (CGFloat)height
{
    return  self.frame.size.height;
}

- (void)setCenterX:(CGFloat)centerX
{
    CGPoint center = self.center ;
    
    center.x = centerX ;
    
    self.center = center ;
}

- (CGFloat)centerX
{
    return self.center.x ;
}

- (void)setCenterY:(CGFloat)centerY
{
    CGPoint center = self.center ;
    
    center.y = centerY ;
    
    self.center = center ;
}

- (CGFloat)centerY
{
    return self.center.y ;
}

@end
