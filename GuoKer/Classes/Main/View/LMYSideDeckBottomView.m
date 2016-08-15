//
//  LMYSideDeckBottomView.m
//  GuoKer
//
//  Created by Lumo on 16/8/8.
//  Copyright © 2016年 LM. All rights reserved.
//

#import "LMYSideDeckBottomView.h"
#import "LMYSideDeckBottomCell.h"

@interface LMYSideDeckBottomView()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) UITableView *tableView ;
@property (nonatomic,strong ) NSArray *imageNames ;
@property (nonatomic, assign) NSInteger selectedIndex ;

@end

@implementation LMYSideDeckBottomView

- (NSArray *)imageNames
{
    if (!_imageNames)
    {
        _imageNames = @[@"menu_mainpage_icon",@"menu_favourite_icon",@"menu_setting_icon",@"menu_feedback_icon"];
    }
    return _imageNames ;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self p_setup];
    }
    return self ;
}

- (void)p_setup
{    
    UITableView *tb = [[UITableView alloc] init];
    tb.scrollEnabled = NO ;
    tb.backgroundColor = [[LMYThemeManager sharedManager] sideDeckBgColor];//[UIColor clearColor];
    tb.delegate = self ;
    tb.dataSource = self ;
    tb.rowHeight = SideDeck_cellHeight ;
    tb.separatorStyle = UITableViewCellSeparatorStyleNone ;
    [self addSubview:tb];
    self.tableView = tb ;
}

- (void)setTitles:(NSArray *)titles
{
    _titles = titles ;
    [self.tableView reloadData];
    
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.tableView.frame = self.bounds ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titles.count ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LMYSideDeckBottomCell *cell = [LMYSideDeckBottomCell sideDeckBottomCell:tableView];
    if (indexPath.row == 0) {
        cell.backgroundColor = [[LMYThemeManager sharedManager] sideDeckCellBgColor] ;
    }
    cell.imageName = self.imageNames[indexPath.row];
    cell.title = self.titles[indexPath.row];
    return cell ;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     UITableViewCell *lastSelectedCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.selectedIndex inSection:indexPath.section]];
    lastSelectedCell.backgroundColor = [UIColor clearColor];
    self.selectedIndex = indexPath.row ;
    
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    selectedCell.backgroundColor = [[LMYThemeManager sharedManager] sideDeckCellBgColor];

    if ([self.delegate respondsToSelector:@selector(sideDeckBottomViewDidClickeAtIndex:)])
    {
        [self.delegate sideDeckBottomViewDidClickeAtIndex:indexPath.row];
    }
}
@end
