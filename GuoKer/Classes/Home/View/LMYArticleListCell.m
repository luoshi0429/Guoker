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

@interface LMYArticleListCell()

@property (nonatomic, weak) UIView *topView ;
@property (nonatomic, weak) UIView *topSeparatorView  ;
@property (nonatomic, weak) UIImageView *profileImageView ;
@property (nonatomic, weak) UILabel *source_nameLabel ;
@property (nonatomic, weak) UIButton *categoryBtn  ;

@property (nonatomic, weak) UIView *centerView ;
@property (nonatomic, weak) UILabel *title_label ;
@property (nonatomic, weak) UILabel *summaryLabel ;
@property (nonatomic, weak) UIImageView *headline_imageView ;

@property (nonatomic, weak) UIView *bottomView ;
@property (nonatomic, weak) UIButton *shareBtn ;
@property (nonatomic, weak) UIView *bottom_bottomSeparatorView ;
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
    UIView *topView = [[UIView alloc] init];
    topView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:topView];
    self.topView = topView ;
    
    UIView *topSeparatorView = [[UIView alloc] init];
    topSeparatorView.backgroundColor = LMYColor(234, 234, 234, 1);
    [self.contentView addSubview:topSeparatorView];
    self.topSeparatorView = topSeparatorView;
    
    UIImageView *profileImageView = [[UIImageView alloc] init];
    profileImageView.image = [UIImage imageNamed:@"bar_share_icon"];
    [topView addSubview:profileImageView];
    self.profileImageView = profileImageView ;
    
    UILabel *source_nameLabel = [[UILabel alloc] init];
    source_nameLabel.text = @"坐骨神经病";
    source_nameLabel.font = [UIFont systemFontOfSize:13];
    source_nameLabel.textColor = LMYColor(151, 151, 151, 1);
    [topView addSubview:source_nameLabel];
    self.source_nameLabel = source_nameLabel ;
    
    UIButton *categoryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    categoryBtn.hidden = NO ;
    [categoryBtn setTitleColor:[[LMYThemeManager sharedManager] homeTopTitleSelectedColor] forState:UIControlStateNormal];
    categoryBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [categoryBtn setTitle:@"科技" forState:UIControlStateNormal];
    [topView addSubview:categoryBtn];
    [categoryBtn addTarget:self action:@selector(p_clickedAtCategoryBtn) forControlEvents:UIControlEventTouchUpInside];
    self.categoryBtn = categoryBtn ;
    
    UIView *top_BottomSeparatorView = [[UIView alloc] init];
    top_BottomSeparatorView.backgroundColor = LMYColor(234, 234, 234, 1);
    [topView addSubview:top_BottomSeparatorView];
    
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(@0);
        make.height.equalTo(@(HomeArticleTopViewHeight));
    }];
    
    [topSeparatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(@0);
        make.height.equalTo(@(SeperatorLineHeight));
    }];
    
    [profileImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(topView.mas_centerY);
        make.leading.equalTo(@(HomeArticleProfileMarginLeft));
        make.width.height.equalTo(@(HomeArticleProfileWH));
    }];
    
    [source_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(topView.mas_centerY);
        make.leading.equalTo(profileImageView.mas_trailing).offset(HomeArticleProfileMarginRight);
    }];
    
    
    [categoryBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(topView.mas_centerY);
        make.trailing.equalTo(@(-HomeArticleProfileMarginLeft));
    }];
    
    [top_BottomSeparatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.leading.trailing.equalTo(@0);
        make.height.equalTo(@(SeperatorLineHeight));
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
//    headline_imageView.backgroundColor = [UIColor redColor];
    headline_imageView.image = [UIImage imageNamed:@"logo_cover_100x50_"];
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
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:bottomView];
    self.bottomView = bottomView ;
    
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareBtn setImage:[UIImage imageNamed:@"bar_share_icon"] forState:UIControlStateNormal];
    [bottomView addSubview:shareBtn];
    [shareBtn addTarget:self action:@selector(p_shareBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    self.shareBtn = shareBtn;
    
    UIView *bottom_bottomSeparatorView = [[UIView alloc] init];
    bottom_bottomSeparatorView.backgroundColor = LMYSeparatorLineColor;
    [bottomView addSubview:bottom_bottomSeparatorView];
    self.bottom_bottomSeparatorView = bottom_bottomSeparatorView;
    
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.centerView.mas_bottom);
        make.leading.trailing.equalTo(@0);
        make.bottom.equalTo(@(-HomeCellMarginBottom));
    }];
    
    [shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bottomView.mas_centerY);
        make.width.height.equalTo(@(HomeCellShareBtnWH));
        make.trailing.equalTo(@(-HomeCellShareBtnMarginRight));
    }];
    
    [bottom_bottomSeparatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.leading.trailing.equalTo(@0);
        make.height.equalTo(@(SeperatorLineHeight));
    }];

}

- (void)setArticleModel:(LMYArticleModel *)articleModel
{
    _articleModel = articleModel ;
    
//    if (articleModel.content && ![articleModel.content isEqualToString:@""]) {
//        
////        LMYLog(@"------%@",articleModel.content);
//        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[articleModel.content dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:NULL];
//        NSLog(@"%@",dict);
//    }
    
    if (articleModel.articleContent) {
        LMYLog(@"%@----%@-----",articleModel.articleContent.content,articleModel.articleContent.pics);
    }
    
//    [self.profileImageView sd_setImageWithURL:[NSURL URLWithString:articleModel.source_data.image]];
    [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:articleModel.source_data.image] options:SDWebImageRetryFailed progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        self.profileImageView.image = [image circleImage];
    }];
    self.source_nameLabel.text = articleModel.source_name ;
    
    [self.categoryBtn setTitle:articleModel.category_text forState:UIControlStateNormal];
    
    self.title_label.text = articleModel.title ;
    self.summaryLabel.text = articleModel.summary ;
    
    [self.headline_imageView sd_setImageWithURL:[NSURL URLWithString:articleModel.headline_img]];
}

- (void)setHideCategortBtn:(BOOL)hideCategortBtn
{
    _hideCategortBtn = hideCategortBtn ;
    
    self.categoryBtn.hidden = hideCategortBtn ;
}

#pragma mark -
- (void)p_clickedAtCategoryBtn
{
    LMYLog(@"点击了:%@",self.articleModel.category_text);
}

- (void)p_shareBtnClicked
{
    LMYLog(@"分享");
}

@end
