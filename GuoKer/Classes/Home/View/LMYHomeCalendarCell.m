//
//  LMYHomeCalendarCell.m
//  GuoKer
//
//  Created by Lumo on 16/8/12.
//  Copyright © 2016年 LM. All rights reserved.
//

#import "LMYHomeCalendarCell.h"
#import "LMYCalendarView.h"
#import <Masonry.h>
#import "LMYArticleModel.h"
#import <UIImageView+WebCache.h>

@interface LMYHomeCalendarCell()
@property (nonatomic, weak) UIView *calendarView ;
@property (nonatomic, weak)  UIView *bottomView ;
@property (nonatomic, weak) UIView *topView ;
@property (nonatomic, weak) UIImageView *iconImageView ;
@property (nonatomic, weak) UILabel *titleLabel ;
@property (nonatomic, weak) UILabel *descLabel ;
@property (nonatomic, weak) UIView *contentContainerView ;
@property (nonatomic, weak) UILabel *yearLabel ;
@property (nonatomic, weak) UILabel *dayLabel ;
@property (nonatomic, weak) UILabel *dateLabel ;
@end

@implementation LMYHomeCalendarCell
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
    
    [self p_setupCalendarView];
    
    [self p_setupBottomView];

}

- (void)p_setupCalendarView
{
    
    UIView *calendarView = [[UIView alloc] init];
    calendarView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:calendarView];
    self.calendarView = calendarView ;
    
    [self p_setupTopView];
    [self p_setupContent];

}
- (void)p_setupTopView
{
    UIView *topView = [[UIView alloc] init];
    [self.calendarView addSubview:topView];
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
    [self.calendarView addSubview:contentContainerView];
    self.contentContainerView = contentContainerView ;
    
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor whiteColor];
    [contentContainerView addSubview:contentView];
    
    UIView *contentHeadlineView = [[UIView alloc] init];
    [contentView addSubview:contentHeadlineView];
    
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
    dayLabel.text = @"MON";
    [dayLabel sizeToFit];
    [dayView addSubview:dayLabel];
    self.dayLabel = dayLabel ;
    
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
    dateLabel.text = @"15 AUG";
    [dateLabel sizeToFit];
    [dateView addSubview:dateLabel];
    self.dateLabel = dateLabel;
    
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
    yearLabel.text = @"2016";
    [yearLabel sizeToFit];
    [yearView addSubview:yearLabel];
    self.yearLabel = yearLabel ;
    
    UIImageView *iconImageView = [[UIImageView alloc] init];
//    iconImageView.backgroundColor = [UIColor purpleColor];
    [contentView addSubview:iconImageView];
    self.iconImageView = iconImageView ;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont systemFontOfSize:15];
    [contentView addSubview:titleLabel];
    self.titleLabel = titleLabel ;
    
    UILabel *descLabel = [[UILabel alloc] init];
    descLabel.font = [UIFont systemFontOfSize:12];
    descLabel.numberOfLines = 0 ;
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
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(iconImageView.mas_bottom).offset(HomeCalendarContentMargin);
        make.leading.equalTo(@(HomeCalendarContentMargin));
        make.trailing.equalTo(@(-HomeCalendarContentMargin));
    }];
    
    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(HomeCalendarContentMargin);
        make.leading.equalTo(titleLabel.mas_leading);
        make.trailing.equalTo(titleLabel.mas_trailing);
    }];
    
    [self.calendarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.trailing.leading.equalTo(@0);
        make.bottom.equalTo(self.contentContainerView.mas_bottom);
    }];
}


- (void)p_setupBottomView
{
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = [UIColor whiteColor] ;//LMYColor(249, 249, 249, 1);
    [self.contentView addSubview:bottomView];
    self.bottomView = bottomView ;
    
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareBtn setImage:[UIImage imageNamed:@"bar_share_icon"] forState:UIControlStateNormal];
    [bottomView addSubview:shareBtn];
    
    UIView *bottomSeparatorView = [[UIView alloc] init];
    bottomSeparatorView.backgroundColor = LMYColor(220, 220, 220, 1);
    [bottomView addSubview:bottomSeparatorView];
    
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(HomeCalendarViewBottomHeight));
        make.leading.trailing.equalTo(@0);
        make.top.equalTo(self.calendarView.mas_bottom);
    }];
    
    [shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bottomView.mas_centerY);
        make.width.height.equalTo(@(HomeCellShareBtnWH));
        make.trailing.equalTo(@(-HomeCellShareBtnMarginRight));
    }];
    
    [bottomSeparatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.leading.trailing.equalTo(@0);
        make.height.equalTo(@(SeperatorLineHeight));
    }];
}

- (void)setArticleModel:(LMYArticleModel *)articleModel
{
    _articleModel = articleModel ;
    
    NSDate *pickedDate = [NSDate dateWithTimeIntervalSince1970:[articleModel.date_picked doubleValue]];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    calendar.locale = [NSLocale localeWithLocaleIdentifier:@"zh-Hans"];
    calendar.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    
    NSDateComponents *cmpts = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay| NSCalendarUnitWeekday | NSCalendarUnitWeekdayOrdinal fromDate:pickedDate];
    NSArray *weekArr = @[@"SUN",@"MON",@"TUES",@"WED",@"THUR",@"FRI",@"SAT"];
    NSArray *monthArr = @[@"JAN",@"FEB",@"MAR",@"APR",@"MAY",@"JUN",@"JUL",@"AUG",@"SEP",@"OCT",@"NOV",@"DEC"];
    NSInteger currentWeekday = cmpts.weekday - 1;
    self.yearLabel.text = [NSString stringWithFormat:@"%zd",cmpts.year];
    self.dayLabel.text = weekArr[currentWeekday];
    self.dateLabel.text = [NSString stringWithFormat:@"%zd %@",cmpts.day,monthArr[cmpts.month - 1]];

    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:articleModel.images.firstObject]];
    self.titleLabel.text = articleModel.title ;
    self.descLabel.text = articleModel.content ;
}

- (CGFloat)cellHeight:(LMYArticleModel *)articleModel
{
    self.articleModel = articleModel ;
    [self layoutIfNeeded];
    return CGRectGetMaxY(self.bottomView.frame) ;
}
@end
