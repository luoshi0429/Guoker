//
//  UIImage+Extension.m
//  GuoKer
//
//  Created by Lumo on 16/8/16.
//  Copyright © 2016年 LM. All rights reserved.
//

#import "UIImage+Extension.h"

@implementation UIImage (Extension)

- (UIImage *)circleImage //WithRect:(CGRect)rect radius:(CGFloat)radius
{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 1.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGRect rect = {CGPointZero,self.size};
    CGContextAddEllipseInRect(context, rect);
    CGContextClip(context);
    
    [self drawInRect:rect];

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image ;
}
@end
