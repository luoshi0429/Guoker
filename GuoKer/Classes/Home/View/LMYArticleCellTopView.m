//
//  LMYArticleCellself.m
//  GuoKer
//
//  Created by Lumo on 16/8/18.
//  Copyright © 2016年 LM. All rights reserved.
//

#import "LMYArticleCellTopView.h"
#import <Masonry.h>
#import "LMYArticleModel.h"
#import <UIImageView+WebCache.h>
#import "LMYArticleSource.h"
#import "UIImage+Extension.h"

@interface LMYArticleCellTopView()
@property (nonatomic, weak) UIImageView *profileImageView ;
@property (nonatomic, weak) UILabel *source_nameLabel ;
@property (nonatomic, weak) UIButton *categoryBtn;
@end

@implementation LMYArticleCellTopView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self p_setupUI];
    }
    return self ;
}

- (void)p_setupUI
{
    UIView *topSeparatorView = [[UIView alloc] init];
    topSeparatorView.backgroundColor = LMYColor(234, 234, 234, 1);
    [self addSubview:topSeparatorView];
    
    UIImageView *profileImageView = [[UIImageView alloc] init];
    profileImageView.image = [UIImage imageNamed:@"bar_share_icon"];
    [self addSubview:profileImageView];
    self.profileImageView = profileImageView ;
    
    UILabel *source_nameLabel = [[UILabel alloc] init];
    source_nameLabel.text = @"坐骨神经病";
    source_nameLabel.font = [UIFont systemFontOfSize:13];
    source_nameLabel.textColor = LMYColor(151, 151, 151, 1);
    [self addSubview:source_nameLabel];
    self.source_nameLabel = source_nameLabel ;
    
    UIButton *categoryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    categoryBtn.hidden = NO ;
    [categoryBtn setTitleColor:[[LMYThemeManager sharedManager] homeTopTitleSelectedColor] forState:UIControlStateNormal];
    categoryBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [categoryBtn setTitle:@"科技" forState:UIControlStateNormal];
    [self addSubview:categoryBtn];
    [categoryBtn addTarget:self action:@selector(p_clickedAtCategoryBtn) forControlEvents:UIControlEventTouchUpInside];
    self.categoryBtn = categoryBtn ;
    
    UIView *top_BottomSeparatorView = [[UIView alloc] init];
    top_BottomSeparatorView.backgroundColor = LMYColor(234, 234, 234, 1);
    [self addSubview:top_BottomSeparatorView];
    
    [topSeparatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(@0);
        make.height.equalTo(@(SeperatorLineHeight));
    }];
    
    [profileImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.leading.equalTo(@(HomeArticleProfileMarginLeft));
        make.width.height.equalTo(@(HomeArticleProfileWH));
    }];
    
    [source_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.leading.equalTo(profileImageView.mas_trailing).offset(HomeArticleProfileMarginRight);
    }];
    
    
    [categoryBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.trailing.equalTo(@(-HomeArticleProfileMarginLeft));
    }];
    
    [top_BottomSeparatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.leading.trailing.equalTo(@0);
        make.height.equalTo(@(SeperatorLineHeight));
    }];
}

- (void)setArticleModel:(LMYArticleModel *)articleModel
{
    _articleModel = articleModel ;
    
    [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:articleModel.source_data.image] options:SDWebImageRetryFailed progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        self.profileImageView.image = [image circleImage];
    }];
    self.source_nameLabel.text = articleModel.source_name ;
    
    [self.categoryBtn setTitle:articleModel.category_text forState:UIControlStateNormal];
}

- (void)setHideCategortBtn:(BOOL)hideCategortBtn
{
    _hideCategortBtn = hideCategortBtn ;
    
    self.categoryBtn.hidden = hideCategortBtn ;
}


- (void)p_clickedAtCategoryBtn
{
    [[NSNotificationCenter defaultCenter] postNotificationName:HomeArticleCellCategoryBtnNotification object:self.articleModel.category_text];
}

@end
