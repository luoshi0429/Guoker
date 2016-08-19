//
//  LMYArticleCellBottomView.m
//  GuoKer
//
//  Created by Lumo on 16/8/18.
//  Copyright © 2016年 LM. All rights reserved.
//

#import "LMYArticleCellBottomView.h"
#import <Masonry.h>

@interface LMYArticleCellBottomView()
@property (nonatomic, weak) UIButton *shareBtn ;
@end

@implementation LMYArticleCellBottomView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self p_setupUI];
    }
    return self;
}

- (void)p_setupUI
{
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareBtn setImage:[UIImage imageNamed:@"share_icon"] forState:UIControlStateNormal];
    [self addSubview:shareBtn];
    [shareBtn addTarget:self action:@selector(p_shareBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    self.shareBtn = shareBtn;
    
    UIView *bottom_bottomSeparatorView = [[UIView alloc] init];
    bottom_bottomSeparatorView.backgroundColor = LMYSeparatorLineColor;
    [self addSubview:bottom_bottomSeparatorView];
    
    [shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.width.height.equalTo(@(HomeCellShareBtnWH));
        make.trailing.equalTo(@(-HomeCellShareBtnMarginRight));
    }];
    
    [bottom_bottomSeparatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.leading.trailing.equalTo(@0);
        make.height.equalTo(@(SeperatorLineHeight));
    }];

}

- (void)p_shareBtnClicked
{
    LMYLog(@"分享");
}

@end
