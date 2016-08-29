//
//  LMYCalendarView.m
//  GuoKer
//
//  Created by Lumo on 16/8/12.
//  Copyright © 2016年 LM. All rights reserved.
//

#import "LMYCalendarView.h"
#import <Masonry.h>
#import "LMYArticleModel.h"
#import <UIImageView+WebCache.h>

@interface LMYCalendarView()
@property (nonatomic, weak) UIView *topView ;
@property (nonatomic, weak) UIImageView *iconImageView ;
@property (nonatomic, weak) UILabel *titleLabel ;
@property (nonatomic, weak) UILabel *descLabel ;
@property (nonatomic, weak) UIView *contentContainerView ;
@end

@implementation LMYCalendarView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self p_setupUI];
    }
    return self;
}

- (void)p_setupUI
{
    self.backgroundColor = LMYColor(249, 249, 249, 1);
    
    [self p_setupTopView];
    
    [self p_setupContent];
   
}

- (void)p_setupTopView
{
    UIView *topView = [[UIView alloc] init];
    [self addSubview:topView];
    self.topView = topView ;
    
    UIImageView *leftCircleView = [[UIImageView alloc] init];
    leftCircleView.image = [UIImage imageNamed:@"round_icon"];
    [topView addSubview:leftCircleView];
    
    UILabel *topLabel = [[UILabel alloc] init];
    topLabel.text = @"果壳日历";
    topLabel.font = [UIFont systemFontOfSize:14];
    topLabel.textColor = LMYColor(170, 170, 170, 1);
    [topView addSubview:topLabel];
    [topView sizeToFit];
    
    UIImageView *rightCircelView = [[UIImageView alloc] init];
    rightCircelView.image = [UIImage imageNamed:@"round_icon"];
    [topView addSubview:rightCircelView];
    
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(@0);
        make.height.equalTo(@(HomeCalendarTopViewHeight));
    }];
    
    [topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(topView.mas_centerY);
        make.centerX.equalTo(topView.mas_centerX);
    }];
    
    CGFloat margin = (SCREEN_WIDTH - topLabel.width - 2 * HomeCalendarCircleWH) / 4 ;
    
    [leftCircleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(topView.mas_centerY);
        make.trailing.equalTo(topLabel.mas_leading).offset(-margin);
        make.width.height.equalTo(@(HomeCalendarCircleWH));
    }];
    
    [rightCircelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(topView.mas_centerY);
        make.leading.equalTo(topLabel.mas_trailing).offset(margin);
        make.width.height.equalTo(@(HomeCalendarCircleWH));
    }];

}

- (void)p_setupContent
{
    UIView *contentContainerView = [[UIView alloc] init];
    contentContainerView.backgroundColor =  LMYColor(200, 200, 200, 1);
    [self addSubview:contentContainerView];
    self.contentContainerView = contentContainerView ;
    
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor whiteColor];
    [contentContainerView addSubview:contentView];
    
    UIView *contentHeadlineView = [[UIView alloc] init];
    [contentView addSubview:contentHeadlineView];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    calendar.locale = [NSLocale localeWithLocaleIdentifier:@"zh-Hans"];
    calendar.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    
    NSDateComponents *cmpts = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay| NSCalendarUnitWeekday | NSCalendarUnitWeekdayOrdinal fromDate:[NSDate date]];
    NSArray *weekArr = @[@"SUN",@"MON",@"TUES",@"WED",@"THUR",@"FRI",@"SAT"];
    NSArray *monthArr = @[@"JAN",@"FEB",@"MAR",@"APR",@"MAY",@"JUN",@"JUL",@"AUG",@"SEP",@"OCT",@"NOV",@"DEC"];
    NSInteger currentWeekday = cmpts.weekday - 1;
    
    UIView *dayView = [[UIView alloc] init];
    [contentHeadlineView addSubview:dayView];
    
    UILabel *dayHeadLingLabel = [[UILabel alloc] init];
    dayHeadLingLabel.backgroundColor = [[LMYThemeManager sharedManager] homeTopTitleSelectedColor];
    dayHeadLingLabel.textColor = [UIColor whiteColor];
    dayHeadLingLabel.font = [UIFont systemFontOfSize:10];
    dayHeadLingLabel.textAlignment = NSTextAlignmentCenter;
    dayHeadLingLabel.text = @"DAY";
    [dayView addSubview:dayHeadLingLabel];
    
    UILabel *dayLabel = [[UILabel alloc] init];
    dayLabel.font = [UIFont fontWithName:@"Liquid Crystal" size:24];
    dayLabel.text = weekArr[currentWeekday];
    [dayLabel sizeToFit];
    [dayView addSubview:dayLabel];

    UIView *dateView = [[UIView alloc] init];
    [contentHeadlineView addSubview:dateView];
    
    UILabel *dateHeadLingLabel = [[UILabel alloc] init];
    dateHeadLingLabel.backgroundColor = [[LMYThemeManager sharedManager] homeTopTitleSelectedColor];
    dateHeadLingLabel.textColor = [UIColor whiteColor];
    dateHeadLingLabel.font = [UIFont systemFontOfSize:10];
    dateHeadLingLabel.textAlignment = NSTextAlignmentCenter;
    dateHeadLingLabel.text = @"DATE";
    [dateView addSubview:dateHeadLingLabel];
    
    UILabel *dateLabel = [[UILabel alloc] init];
    dateLabel.font = [UIFont fontWithName:@"Liquid Crystal" size:24];
    dateLabel.text = [NSString stringWithFormat:@"%zd %@",cmpts.day,monthArr[cmpts.month - 1]];
    [dateLabel sizeToFit];
    [dateView addSubview:dateLabel];
    
    UIView *yearView = [[UIView alloc] init];
    [contentHeadlineView addSubview:yearView];
    
    UILabel *yearHeadLingLabel = [[UILabel alloc] init];
    yearHeadLingLabel.backgroundColor = [[LMYThemeManager sharedManager] homeTopTitleSelectedColor];
    yearHeadLingLabel.textColor = [UIColor whiteColor];
    yearHeadLingLabel.font = [UIFont systemFontOfSize:10];
    yearHeadLingLabel.textAlignment = NSTextAlignmentCenter;
    yearHeadLingLabel.text = @"YEAR";
    [yearView addSubview:yearHeadLingLabel];
    
    UILabel *yearLabel = [[UILabel alloc] init];
    yearLabel.font = [UIFont fontWithName:@"Liquid Crystal" size:24];
    yearLabel.text = [NSString stringWithFormat:@"%zd",cmpts.year];
    [yearLabel sizeToFit];
    [yearView addSubview:yearLabel];
    
    UIImageView *iconImageView = [[UIImageView alloc] init];
    iconImageView.backgroundColor = [UIColor purpleColor];
    [contentView addSubview:iconImageView];
    self.iconImageView = iconImageView ;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.text = @"我是标题";
    [contentView addSubview:titleLabel];
    self.titleLabel = titleLabel ;
    
    UILabel *descLabel = [[UILabel alloc] init];
    descLabel.font = [UIFont systemFontOfSize:12];
    descLabel.numberOfLines = 0 ;
    descLabel.text = @"1887年的今天，物理学家埃尔温·薛定谔出生，不过，在他还是个受精卵的时候，他的量子云就坍缩到存在状态了。后来，薛定谔养了猫。";
    [contentView addSubview:descLabel];
    self.descLabel = descLabel ;
    
    [contentContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom);
        make.leading.equalTo(@(HomeCalendarContentMargin));
        make.trailing.equalTo(@(-HomeCalendarContentMargin));
        make.bottom.equalTo(self.descLabel.mas_bottom).offset(HomeCalendarContentMargin);
    }];
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.equalTo(@(SeperatorLineHeight));
        make.bottom.trailing.equalTo(@(-SeperatorLineHeight));
    }];
    
    [contentHeadlineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(@0);
        make.height.equalTo(@(HomeCalendarDateContentHeight));
    }];
    
    [dateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(contentHeadlineView.mas_centerX);
        make.centerY.equalTo(contentHeadlineView.mas_centerY);
        make.top.equalTo(dateHeadLingLabel.mas_top);
        make.bottom.equalTo(dateLabel.mas_bottom);
        make.leading.equalTo(dateLabel.mas_leading);
        make.trailing.equalTo(dateLabel.mas_trailing);
    }];
    
    [dateHeadLingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.trailing.leading.equalTo(dateLabel);
    }];
    
    [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(dateHeadLingLabel.mas_bottom).offset(HomeCalendarDateMargin);
        make.bottom.equalTo(@0);
    }];
    
    CGFloat margin = (SCREEN_WIDTH - dateLabel.width - dayLabel.width - yearLabel.width) / 4 ;

    [dayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(contentHeadlineView.mas_centerY);
        make.trailing.equalTo(dateView.mas_leading).offset(-margin);
        make.top.equalTo(dayHeadLingLabel.mas_top);
        make.bottom.equalTo(dayLabel.mas_bottom);
        make.leading.equalTo(dayLabel.mas_leading);
        make.trailing.equalTo(dayLabel.mas_trailing);
    }];
    
    [dayHeadLingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.trailing.leading.equalTo(dayLabel);
    }];
    
    [dayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(dayHeadLingLabel.mas_bottom).offset(HomeCalendarDateMargin);
        make.bottom.equalTo(@0);
    }];

    [yearView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(contentHeadlineView.mas_centerY);
        make.leading.equalTo(dateView.mas_trailing).offset(margin);
        make.top.equalTo(yearHeadLingLabel.mas_top);
        make.bottom.equalTo(yearLabel.mas_bottom);
        make.leading.equalTo(yearLabel.mas_leading);
        make.trailing.equalTo(yearLabel.mas_trailing);
    }];
    
    [yearHeadLingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.trailing.leading.equalTo(yearLabel);
    }];
    
    [yearLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(yearHeadLingLabel.mas_bottom).offset(HomeCalendarDateMargin);
        make.bottom.equalTo(@0);
    }];

    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentHeadlineView.mas_bottom);
        make.trailing.leading.equalTo(@0);
        make.height.equalTo(@(HomeCalendarIconHeight));
//        make.bottom.equalTo(titleLabel.mas_top).offset(-(HomeCalendarContentMargin));
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(iconImageView.mas_bottom).offset(HomeCalendarContentMargin);
        make.leading.equalTo(@(HomeCalendarContentMargin));
        make.trailing.equalTo(@(-HomeCalendarContentMargin));
//        make.bottom.equalTo(descLabel.mas_top).offset(-HomeCalendarTitleMargin);
    }];
    
    descLabel.backgroundColor = [UIColor purpleColor];
    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(HomeCalendarContentMargin);
        make.leading.equalTo(titleLabel.mas_leading);
        make.trailing.equalTo(titleLabel.mas_trailing);
//        make.bottom.equalTo(@(-HomeCalendarContentMargin));
    }];
}

- (void)setArticleModel:(LMYArticleModel *)articleModel
{
    _articleModel = articleModel ;
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:articleModel.images.firstObject]];
    self.titleLabel.text = articleModel.title ;
    self.descLabel.text = articleModel.content ;
    
}

- (CGFloat)calendarViewHeight:(LMYArticleModel *)articleModel
{
    self.articleModel = articleModel ;
    [self layoutIfNeeded];
    
    return CGRectGetMaxY(self.contentContainerView.frame) ;//CGRectGetMaxY(self.descLabel.frame) + 20 ;//CGRectGetMaxY(self.contentContainerView.frame) ;
}
@end
