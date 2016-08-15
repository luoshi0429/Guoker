//
//  UIView+Frame.h
//  LM(storyboard)
//
//  Created by Lumo on 14/5/21.
//  Copyright (c) 2015年 LM. All rights reserved.
//给UIView提供一个分类 能够快速得到x，y，width，height，center的值

#import <UIKit/UIKit.h>

@interface UIView (Frame)

@property(nonatomic,assign) CGFloat x ;

@property(nonatomic,assign) CGFloat y ;

@property(nonatomic,assign) CGFloat width ;

@property(nonatomic,assign) CGFloat height ;

@property(nonatomic,assign) CGFloat centerX ;

@property(nonatomic,assign) CGFloat centerY ;

@end
