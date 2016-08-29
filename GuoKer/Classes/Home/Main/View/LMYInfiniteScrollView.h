//
//  LMInfiniteScrollView.h
//  无限循环的图片轮播器
//
//  Created by 刘敏 on 15/10/4.
//  Copyright (c) 2015年 刘敏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LMYInfiniteScrollView : UIView

/**
 *  图片的url
 */
@property(nonatomic,strong)NSArray *imageUrls ;

/**
 *  描述数组
 */
@property (nonatomic,strong) NSArray *describeArray ;


/**
 *  传入的图片
 */
@property (nonatomic,strong) NSArray *images ;


/**
 *  占位图片
 */
@property (nonatomic,strong) UIImage *placeholderImage ;

/**
 *  描述文字的背景图片
 */
@property (nonatomic,strong) UIImage *describeBgImage ;

/** 
 * 水平或者竖直方向
 */
@property(nonatomic,assign,getter=isPortrait) BOOL portrait ; //竖直方向

/**
 * 指示颜色
 */
@property(nonatomic,strong)UIColor *indicatorColor;

/**
 *  当前的指示颜色
 */
@property(nonatomic,strong)UIColor *currentIndicatorColor ;

/**
 *  滚动间隔
 */
@property (nonatomic, assign) NSTimeInterval timeInterval ;

/**
 *  点击了哪张图片的block回调
 */
@property(nonatomic,copy) void(^tapImageBlock)(NSInteger tapIndex) ;

@end
