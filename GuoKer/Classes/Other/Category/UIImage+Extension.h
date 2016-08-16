//
//  UIImage+Extension.h
//  GuoKer
//
//  Created by Lumo on 16/8/16.
//  Copyright © 2016年 LM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)

/**
 *  生成带圆角的图片
 *
 *  @param rect   图片的大小
 *  @param radius 圆角大小
 *
 */
- (UIImage *)circleImage;//WithRect:(CGRect)rect radius:(CGFloat)radius;


@end
