
//
//  DSXPlaceholderTextView.m
//  善信
//
//  Created by 刘敏 on 16/7/7.
//  Copyright © 2016年 LM. All rights reserved.
//

#import "LMYPlaceholderTextView.h"

@interface LMYPlaceholderTextView()

@property (nonatomic, weak) UILabel *placeholderLabel;

@end

@implementation LMYPlaceholderTextView

#pragma mark - lazy
- (UILabel *)placeholderLabel
{
    if (!_placeholderLabel) {
        UILabel *placeholderLabel = [[UILabel alloc] init];
        placeholderLabel.x = 6;
        placeholderLabel.y = 8;
        placeholderLabel.numberOfLines = 0;
        [self addSubview:placeholderLabel];
        _placeholderLabel = placeholderLabel;
    }
    return _placeholderLabel;
}

#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.font = [UIFont systemFontOfSize:15];
        [self p_setup];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self p_setup];
}

- (void)p_setup
{
    // 和textField的placeholderColor相近
    self.placeholderColor = [UIColor colorWithRed:198/255.0 green:198/255.0 blue:198/255.0 alpha:1.0];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(p_textDidChange) name:UITextViewTextDidChangeNotification object:self];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/**
 *  监听文字改变
 */
- (void)p_textDidChange
{
    self.placeholderLabel.hidden = self.hasText;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 设置宽度
    self.placeholderLabel.width = self.width - 2 * self.placeholderLabel.x;
    
    // 自动计算高度
    [self.placeholderLabel sizeToFit];
}

#pragma mark - setter
- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = [placeholder copy];
    
    self.placeholderLabel.text = placeholder;
    
    // 重新布局子控件
    [self setNeedsLayout];
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    _placeholderColor = placeholderColor;
    
    self.placeholderLabel.textColor = placeholderColor;
}

- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    
    self.placeholderLabel.font = font;
    
    // 重新布局子控件
    [self setNeedsLayout];
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    
    self.placeholderLabel.hidden = self.hasText;
}

- (void)setAttributedText:(NSAttributedString *)attributedText
{
    [super setAttributedText:attributedText];
    
    self.placeholderLabel.hidden = self.hasText;
}

@end
