//
//  UIImage+Theme.h
//  GuoKer
//
//  Created by Lumo on 16/8/8.
//  Copyright © 2016年 LM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Theme)
/**
 *  通过主题判断是什么图片
 */
+ (UIImage *)themeImageWithName:(NSString *)name;
@end
