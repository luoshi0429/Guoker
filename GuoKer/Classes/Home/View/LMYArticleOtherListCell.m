//
//  LMYArticleOtherListCell.m
//  GuoKer
//
//  Created by Lumo on 16/8/13.
//  Copyright © 2016年 LM. All rights reserved.
//

#import "LMYArticleOtherListCell.h"
#import <Masonry.h>
#import "LMYArticleModel.h"
#import "LMYArticleSource.h"
#import "LMYArticleContent.h"
#import <UIImageView+WebCache.h>
#import "LMYArticleContent.h"
#import "UIImage+Extension.h"
#import <SDWebImageManager.h>
#import "LMYArticleCellTopView.h"
#import "LMYArticleCellBottomView.h"

@interface LMYArticleOtherListCell()

@property (nonatomic, weak) LMYArticleCellTopView *topView ;
@property (nonatomic, weak) LMYArticleCellBottomView *bottomView ;

@property (nonatomic, weak) UIView *centerView ;
@property (nonatomic, weak) UILabel *title_label ;
@property (nonatomic, weak) UILabel *summaryLabel ;
@property (nonatomic, weak) UIView *headlineContainerView ;

@end

@implementation LMYArticleOtherListCell
// 图片最大的列数：3
static int const totalCols = 3 ;

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
    summaryLabel.numberOfLines = 2 ;
    summaryLabel.font = [UIFont systemFontOfSize:13];
    [centerView addSubview:summaryLabel];
    self.summaryLabel = summaryLabel;
    
    UIView *headlineContainerView = [[UIView alloc] init];
    [centerView addSubview:headlineContainerView];
    self.headlineContainerView = headlineContainerView ;
    
    [centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom);
        make.trailing.leading.equalTo(@0);
        make.bottom.equalTo(summaryLabel.mas_bottom);
    }];
    
    [headlineContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(HomeArticelCenterViewTopMargin));
        make.leading.equalTo(@(HomeArticleProfileMarginLeft));
        make.trailing.equalTo(@(-HomeArticleProfileMarginLeft));
        make.height.equalTo(@(HomeOtherArticleOnePicHeight));
    }];
    
    [title_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(headlineContainerView.mas_leading);
        make.trailing.equalTo(headlineContainerView.mas_trailing);
        make.top.equalTo(headlineContainerView.mas_bottom).offset(HomeOtherArticleTitleTopMargin);
    }];
    
    [summaryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(title_label.mas_leading);
        make.trailing.equalTo(title_label.mas_trailing);
        make.top.equalTo(title_label.mas_bottom).offset(HomeOtherArticleTitleTopMargin);
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
        make.height.equalTo(@(HomeCalendarViewBottomHeight));
    }];
}

- (void)setArticleModel:(LMYArticleModel *)articleModel
{
    _articleModel = articleModel ;
    
    self.topView.articleModel = articleModel ;
    
    self.title_label.text = articleModel.title ;
    self.summaryLabel.text = articleModel.summary ;
    
    [self.headlineContainerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    LMYArticleContent *articleContent = articleModel.articleContent;
    if (articleContent.pics.count == 1)
    {
        UIImageView *headlineImageView = [[UIImageView alloc] init];
        headlineImageView.contentMode = UIViewContentModeScaleAspectFill;
        headlineImageView.clipsToBounds = YES ;
        LMYArticleContentPic *pic = articleContent.pics[0];
        [headlineImageView sd_setImageWithURL:[NSURL URLWithString: pic.url] placeholderImage:[UIImage imageNamed:@"logo_cover_100x50_"]];
        [self.headlineContainerView addSubview:headlineImageView];
        
        [self.headlineContainerView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@(HomeArticelCenterViewTopMargin));
            make.leading.equalTo(@(HomeArticleProfileMarginLeft));
            make.trailing.equalTo(@(-HomeArticleProfileMarginLeft));
            make.height.equalTo(@(HomeOtherArticleOnePicHeight));
        }];
        
        [headlineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(@0);
        }];
    }
    else
    {
        CGFloat imageWH = (SCREEN_WIDTH - 2 * HomeArticleProfileMarginLeft - 2 * HomeOtherArticlePicMargin) / totalCols ;
        
        for (int i = 0; i < articleContent.pics.count; i ++ )
        {
            if (i == 9)
            {
                break ;
            }
            LMYArticleContentPic *pic = articleContent.pics[i];
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.contentMode = UIViewContentModeScaleAspectFill ;
            imageView.clipsToBounds = YES ;
            [imageView sd_setImageWithURL:[NSURL URLWithString:pic.url] placeholderImage:[UIImage imageNamed:@"logo_cover_100x50_"]];
            [self.headlineContainerView addSubview:imageView ];
            
            int row = i / 3;
            int col = i % 3;
            CGFloat top = row * (imageWH + HomeOtherArticlePicMargin);
            CGFloat leading = col * (imageWH + HomeOtherArticlePicMargin) ;
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.height.equalTo(@(imageWH));
                make.top.equalTo(@(top));
                make.leading.equalTo(@(leading));
            }];
            
            if (i == 8)
            {
                [self.headlineContainerView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(@(HomeArticelCenterViewTopMargin));
                    make.leading.equalTo(@(HomeArticleProfileMarginLeft));
                    make.trailing.equalTo(@(-HomeArticleProfileMarginLeft));
                    make.bottom.equalTo(imageView.mas_bottom);
                }];
            }
        }
    }
}

- (CGFloat)cellHeight:(LMYArticleModel *)articleModel
{
    self.articleModel = articleModel ;
    [self layoutIfNeeded];
    return CGRectGetMaxY(self.bottomView.frame) + HomeCellMarginBottom ;
}


@end
