//
//  LMYHomeDateCell.m
//  GuoKer
//
//  Created by Lumo on 16/8/12.
//  Copyright © 2016年 LM. All rights reserved.
//

#import "LMYHomeDateCell.h"
#import <Masonry.h>

@interface LMYHomeDateCell()

@property (nonatomic, weak) UILabel *dateLabel ;

@end

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
        self.selectionStyle = UITableViewCellSelectionStyleNone ;
        
        UILabel *dateLabel = [[UILabel alloc] init];
        dateLabel.font = [UIFont systemFontOfSize:12];
        dateLabel.textColor = LMYColor(171, 173, 174, 1);
        self.dateLabel = dateLabel ;
       [self.contentView addSubview:dateLabel];
        
        [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(@(-HomeCellMarginBottom));
            make.leading.equalTo(@(HomeDateLabelMargin));
        }];
    }
    return self;
}

- (void)setPickedDateStr:(NSString *)pickedDateStr
{
    _pickedDateStr = [pickedDateStr copy];
    
    NSDate *pickedDate = [NSDate dateWithTimeIntervalSince1970:pickedDateStr.doubleValue];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    calendar.locale = [NSLocale localeWithLocaleIdentifier:@"zh-Hans"];
    NSDateComponents *cmpts = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:pickedDate];
    NSString *dateStr = [NSString stringWithFormat:@"%zd年%zd月%zd日",cmpts.year,cmpts.month,cmpts.day];
    self.dateLabel.text = dateStr ;    
}

@end
