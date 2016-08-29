//
//  LMYKeywordCell.m
//  GuoKer
//
//  Created by Lumo on 16/8/29.
//  Copyright © 2016年 LM. All rights reserved.
//

#import "LMYSearchCell.h"
#import "LMYSearchResult.h"
#import <UIImageView+WebCache.h>
#import <Masonry.h>

@interface LMYSearchCell()
@property (nonatomic, weak) UILabel *title_label ;
@property (nonatomic, weak) UILabel *summaryLabel ;
@property (nonatomic, weak) UIImageView *headlineImageView ;
@end

@implementation LMYSearchCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self p_setupUI];
    }
    return self;
}

- (void)p_setupUI
{
    self.backgroundColor =  LMYColor(249, 249, 249, 1);
    
    UILabel *title_label = [[UILabel alloc] init];
    title_label.numberOfLines = 2 ;
    [self.contentView addSubview:title_label];
    self.title_label = title_label ;
    
    UILabel *summaryLabel = [[UILabel alloc] init];
    summaryLabel.numberOfLines = 2 ;
    summaryLabel.font = [UIFont systemFontOfSize:13];
    summaryLabel.textColor = LMYColor(150, 150, 150, 1);
    [self.contentView addSubview:summaryLabel];
    self.summaryLabel = summaryLabel;
    
    UIImageView *headlineImageView = [[UIImageView alloc] init];
    headlineImageView.clipsToBounds = YES ;
    headlineImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:headlineImageView];
    self.headlineImageView = headlineImageView ;
    
    UIView *separatorView = [[UIView alloc] init];
    separatorView.backgroundColor = LMYSeparatorLineColor ;
    [self.contentView addSubview:separatorView];
    
    [title_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(SearchCellPadding));
        make.leading.equalTo(@(SearchCellPadding));
        make.trailing.equalTo(headlineImageView.mas_leading).offset(-SearchCellPadding);
    }];
    
    [summaryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@(-SearchCellPadding));
        make.leading.equalTo(title_label.mas_leading);
        make.trailing.equalTo(headlineImageView.mas_leading).offset(-SearchCellPadding);
    }];
    
    [headlineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(title_label.mas_top);
        make.trailing.equalTo(@(-SearchCellPadding));
        make.width.equalTo(@(SearchCellHeadlineImgWidth));
        make.height.equalTo(@(SearchCellHeadlineImgHeight));
    }];
    
    [separatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@0);
        make.leading.equalTo(title_label.mas_leading);
        make.trailing.equalTo(headlineImageView.mas_trailing);
        make.height.equalTo(@(SeperatorLineHeight));
    }];
}

- (void)setSearchResult:(LMYSearchResult *)searchResult
{
    _searchResult = searchResult ;

    self.title_label.attributedText = [self p_dealWithStringWithStrong:searchResult.title] ;
    self.summaryLabel.attributedText = [self p_dealWithStringWithStrong:searchResult.summary] ;
    [self.headlineImageView sd_setImageWithURL:[NSURL URLWithString:searchResult.headline_img] placeholderImage:[UIImage imageNamed:@"logo_cover_100x50_"]];
}

- (NSMutableAttributedString *)p_dealWithStringWithStrong:(NSString *)string
{
    NSString *cutTitle = [string stringByReplacingOccurrencesOfString:@"<strong>" withString:@""];
    cutTitle = [cutTitle stringByReplacingOccurrencesOfString:@"</strong>" withString:@""];
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:cutTitle];
    NSString *pattern = @"<strong>[^<]{1,}</strong>";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:NULL];
    NSArray *matchRes = [regex matchesInString:string options:NSMatchingReportCompletion range:NSMakeRange(0, string.length)];
    for(int i = 0 ; i < matchRes.count ; i ++){
        NSTextCheckingResult *checkingRes = matchRes[i];
        NSString *tempStr = [string substringWithRange:checkingRes.range];
        tempStr = [tempStr stringByReplacingOccurrencesOfString:@"<strong>" withString:@""];
        tempStr = [tempStr stringByReplacingOccurrencesOfString:@"</strong>" withString:@""];
        NSRange titleRange = NSMakeRange(checkingRes.range.location - i * 17, checkingRes.range.length - 17);
        [attrStr addAttribute:NSForegroundColorAttributeName value:LMYColor(24, 163, 75, 1) range:titleRange];
    }
    
    return attrStr ;

}
@end
