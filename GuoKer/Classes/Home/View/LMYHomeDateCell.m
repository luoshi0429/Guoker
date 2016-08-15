//
//  LMYHomeDateCell.m
//  GuoKer
//
//  Created by Lumo on 16/8/12.
//  Copyright © 2016年 LM. All rights reserved.
//

#import "LMYHomeDateCell.h"
#import <Masonry.h>

@implementation LMYHomeDateCell

+ (instancetype)homeDateCell:(UITableView *)tableView
{
    static NSString *cellID = @"dateCell";
    LMYHomeDateCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.backgroundColor = LMYColor(226, 232, 236, 1);
        
        UILabel *dateLabel = [[UILabel alloc] init];
        dateLabel.font = [UIFont systemFontOfSize:12];
        dateLabel.textColor = LMYColor(171, 173, 174, 1);
       
        NSCalendar *calendar = [NSCalendar currentCalendar];
        calendar.locale = [NSLocale localeWithLocaleIdentifier:@"zh-Hans"];
        NSDateComponents *cmpts = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:[NSDate date]];
        NSString *dateStr = [NSString stringWithFormat:@"%zd年%zd月%zd日",cmpts.year,cmpts.month,cmpts.day];
        dateLabel.text = dateStr ;
        [dateLabel sizeToFit];
        [self.contentView addSubview:dateLabel];
        
        UIView *seperatorView = [[UIView alloc] init];
        seperatorView.backgroundColor =  LMYColor(220, 220, 220, 1);
        [self.contentView addSubview:seperatorView];
        
        [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.leading.equalTo(@(HomeDateLabelMargin));
        }];
        
        [seperatorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.equalTo(@0);
            make.height.equalTo(@(SeperatorLineHeight));
            make.bottom.equalTo(@0);
        }];
    }
    return self;
}

@end
