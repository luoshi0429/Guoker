//
//  DSXPlaceholderTextView.h
//  善信
//
//  Created by 刘敏 on 16/7/7.
//  Copyright © 2016年 LM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LMYPlaceholderTextView : UITextView
/** 
 *占位文字 
 */
@property (nonatomic, copy) NSString *placeholder;
/** 
 *占位文字颜色 
 */
@property (nonatomic, strong) UIColor *placeholderColor;
@end
