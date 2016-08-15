//
//  LMYSidexDeckBottonCell.m
//  GuoKer
//
//  Created by Lumo on 16/8/8.
//  Copyright © 2016年 LM. All rights reserved.
//

#import "LMYSideDeckBottomCell.h"
#import <Masonry.h>

@interface LMYSideDeckBottomCell()

@property (nonatomic, weak) UIImageView *iconImageView ;
@property (nonatomic, weak) UILabel *label ;
@property (nonatomic, weak) UIView *seperatorView ;

@end

@implementation LMYSideDeckBottomCell

+ (instancetype)sideDeckBottomCell:(UITableView *)tb
{
    static NSString *cellID = @"sideDeckCell";
    LMYSideDeckBottomCell *cell = [tb dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell)
    {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    return cell ;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self p_setup];
    }
    return self ;
}

- (void)p_setup
{
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone ;
    
    UIView *containerView = [[UIView alloc] init];
    containerView.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:containerView];
    
    UIImageView *iconImageView = [[UIImageView alloc] init];
    [containerView addSubview:iconImageView];
    self.iconImageView = iconImageView ;
    
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [[LMYThemeManager sharedManager] sideDeckTitleColor];
    [containerView addSubview:label];
    self.label = label ;
    
    UIView *seperatorView = [[UIView alloc] init];
    seperatorView.backgroundColor = [[LMYThemeManager sharedManager] sideDeckSeparetorColor];
    [self.contentView addSubview:seperatorView];
    self.seperatorView = seperatorView ;
    
    
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.equalTo(@(29));
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(iconImageView.mas_trailing).offset(SideDeck_cellIconMargin);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
    [containerView mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.trailing.equalTo(label.mas_trailing);
        make.leading.equalTo(iconImageView.mas_trailing);
    }];
    
    [seperatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.height.equalTo(@(SeperatorLineHeight));
        make.leading.equalTo(@20);
        make.trailing.equalTo(@-20);
    }];
}

- (void)setTitle:(NSString *)title
{
    _title = [title copy];
    
    self.label.text = title ;
}

- (void)setImageName:(NSString *)imageName
{
    _imageName = [imageName copy];
    self.iconImageView.image = [UIImage imageNamed:imageName];
}

@end
