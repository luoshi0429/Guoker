//
//  LMYKeywordView.m
//  GuoKer
//
//  Created by Lumo on 16/8/29.
//  Copyright © 2016年 LM. All rights reserved.
//

#import "LMYKeywordView.h"
@implementation LMYKeywordView

- (void)setKeywords:(NSArray *)keywords
{
    _keywords = keywords ;
    
    for (int i = 0; i < keywords.count; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i ;
        [btn setBackgroundImage:[UIImage imageNamed:@"img_search_bg"] forState:UIControlStateNormal];
        [btn setTitle:keywords[i] forState:UIControlStateNormal];
        [btn setTitleColor:LMYColor(24, 163, 75, 1) forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:17];
        [btn addTarget:self action:@selector(keywordBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
}

- (void)keywordBtnClicked:(UIButton *)btn
{
    !self.keywordButtonClicked ?:self.keywordButtonClicked(self.keywords[btn.tag]);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat leftTopMargin = 20 ;
    CGFloat btnMargin = 10 ;
    CGFloat hMargin = 12 ;
    CGFloat vMargin = 8 ;
    CGFloat keywordH = 25;

    
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSString *text = self.keywords[idx];
        CGSize maxSize = CGSizeMake(self.width - 100, keywordH);
        NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
        attrs[NSFontAttributeName] = [UIFont systemFontOfSize:17];
        CGRect textRect = [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:NULL];
        CGSize btnSize = CGSizeMake(textRect.size.width + 2 * hMargin, keywordH + vMargin * 2);
        
        UIView *subview = self.subviews[idx];
        if (idx == 0) {
            subview.frame = CGRectMake(leftTopMargin, leftTopMargin, btnSize.width, btnSize.height);
        }else {
            UIView *lastSubview = self.subviews[idx - 1];
            
            CGFloat maxX = CGRectGetMaxX(lastSubview.frame)+ btnSize.width + 2 * btnMargin + leftTopMargin;
        
            if (maxX  > self.width) {
                subview.frame = CGRectMake(leftTopMargin, CGRectGetMaxY(lastSubview.frame) + btnMargin, btnSize.width, btnSize.height);
            }else {
                subview.frame = CGRectMake(CGRectGetMaxX(lastSubview.frame) + btnMargin, lastSubview.y, btnSize.width, btnSize.height);
            }
        }
        
    }];
}
@end
