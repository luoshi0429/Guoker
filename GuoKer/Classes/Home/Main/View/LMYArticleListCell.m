//
//  LMYArticleListCell.m
//  GuoKer
//
//  Created by Lumo on 16/8/12.
//  Copyright © 2016年 LM. All rights reserved.
//

#import "LMYArticleListCell.h"
#import <Masonry.h>
#import "LMYArticleModel.h"
#import "LMYArticleSource.h"
#import <UIImageView+WebCache.h>
#import "LMYArticleContent.h"
#import "UIImage+Extension.h"
#import <SDWebImageManager.h>
#import "LMYArticleCellTopView.h"
#import "LMYArticleCellBottomView.h"

@interface LMYArticleListCell()

@property (nonatomic, weak) LMYArticleCellTopView *topView ;
@property (nonatomic, weak) LMYArticleCellBottomView *bottomView ;

@property (nonatomic, weak) UIView *centerView ;
@property (nonatomic, weak) UILabel *title_label ;
@property (nonatomic, weak) UILabel *summaryLabel ;
@property (nonatomic, weak) UIImageView *headline_imageView ;

@end

@implementation LMYArticleListCell

+ (instancetype)articleListCell:(UITableView *)tableView
{
    static NSString * cellID = @"articleListCell";
    LMYArticleListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    return cell ;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self p_setupUI];
    }
    return self ;
}

- (void)p_setupUI
{
    self.backgroundColor = LMYColor(226, 232, 236, 1) ;
    
    [self p_setupTopUI];
    [self p_setupCenterUI];
    [self p_setupBottomUI];
}

- (void)p_setupTopUI
{
    LMYArticleCellTopView *topView = [[LMYArticleCellTopView alloc] init];
    topView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:topView];
    self.topView = topView ;
    
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(@0);
        make.height.equalTo(@(HomeArticleTopViewHeight));
    }];
}

- (void)p_setupCenterUI
{
    UIView *centerView = [[UIView alloc] init];
    centerView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:centerView];
    self.centerView = centerView ;
    
    UILabel *title_label = [[UILabel alloc] init];
    title_label.numberOfLines = 2 ;
    title_label.textColor = [UIColor blackColor];
    title_label.font = [UIFont systemFontOfSize:16];
    [centerView addSubview:title_label];
    self.title_label = title_label ;
    
    UILabel *summaryLabel = [[UILabel alloc] init];
    summaryLabel.textColor = LMYColor(151, 151, 151, 1);
    summaryLabel.font = [UIFont systemFontOfSize:13];
    summaryLabel.numberOfLines = 2 ;
    [centerView addSubview:summaryLabel];
    self.summaryLabel = summaryLabel;
    
    UIImageView *headline_imageView = [[UIImageView alloc] init];
    headline_imageView.contentMode = UIViewContentModeScaleAspectFill;
    headline_imageView.clipsToBounds = YES ;
    [centerView addSubview:headline_imageView];
    self.headline_imageView = headline_imageView ;
    
    [centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(HomeArticleCenterViewHeight));
        make.top.equalTo(self.topView.mas_bottom);
        make.trailing.leading.equalTo(@0);
    }];
    
    [title_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(HomeArticelCenterViewTopMargin));
        make.leading.equalTo(@(HomeArticleProfileMarginLeft));
        make.trailing.equalTo(headline_imageView.mas_leading).offset(-HomeArticleProfileMarginRight);
    }];
    
    [summaryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(headline_imageView.mas_bottom);
        make.leading.equalTo(title_label.mas_leading);
        make.trailing.equalTo(title_label.mas_trailing);
    }];
    
    [headline_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(title_label.mas_top);
        make.trailing.equalTo(@(-HomeCellShareBtnMarginRight));
        make.bottom.equalTo(@0);
        make.width.equalTo(@(HomeArticelImageWidth));
    }];
}

- (void)p_setupBottomUI
{
    LMYArticleCellBottomView *bottomView = [[LMYArticleCellBottomView alloc] init];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:bottomView];
    self.bottomView = bottomView ;
    
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.centerView.mas_bottom);
        make.leading.trailing.equalTo(@0);
        make.bottom.equalTo(@(-HomeCellMarginBottom));
    }];
}

- (void)setArticleModel:(LMYArticleModel *)articleModel
{
    _articleModel = articleModel ;
    
    self.topView.articleModel = articleModel ;
    
    self.title_label.text = articleModel.title ;
    self.summaryLabel.text = articleModel.summary ;
    
    if (articleModel.articleContent) {
        //        LMYLog(@"%@----%@-----",articleModel.articleContent.content,articleModel.articleContent.pics);
    }
    
    [self.headline_imageView sd_setImageWithURL:[NSURL URLWithString:articleModel.headline_img] placeholderImage: [UIImage imageNamed:@"logo_cover_100x50_"]];
}

- (void)setHideCategortBtn:(BOOL)hideCategortBtn
{
    _hideCategortBtn = hideCategortBtn ;
    
    self.topView.hideCategortBtn = hideCategortBtn ;
}

@end
