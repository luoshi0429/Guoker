//
//  LMYAllTableViewController.m
//  GuoKer
//
//  Created by Lumo on 16/8/11.
//  Copyright © 2016年 LM. All rights reserved.
//

#import "LMYAllTableViewController.h"
//#import "LMYInfiniteScrollView.h"
//#import "LMYHomeHandpick.h"
#import <MJExtension.h>
#import <MJRefresh.h>
#import "LMYHomeHandpickView.h"
#import "LMYHomeCalendarCell.h"
#import "LMYHomeDateCell.h"
#import "LMYArticleListCell.h"
#import "LMYArticleModel.h"
#import "LMYArticleSource.h"

@interface LMYAllTableViewController ()
@property (nonatomic, weak) LMYHomeHandpickView *handpickView ;
@property (nonatomic,strong) NSMutableArray *articles ;

@end

@implementation LMYAllTableViewController

- (NSMutableArray *)articles
{
    if (_articles == nil)
    {
        _articles = [[NSMutableArray alloc] init] ;
    }
    return _articles ;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self p_setupUI];
    
    [self p_loadData]; 
}

- (void)p_setupUI
{
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone ;
    
    LMYHomeHandpickView *handpickView = [[LMYHomeHandpickView alloc] init];
    handpickView.frame = CGRectMake(0, 0, self.tableView.width, HomeInfiniteScrollViewHeight);
    self.tableView.tableHeaderView = handpickView;
    self.handpickView = handpickView ;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:nil];
    
    [self.tableView registerClass:[LMYHomeCalendarCell class] forCellReuseIdentifier:@"calenderCell"];
}

#pragma mark - 数据相关
- (void)p_loadData
{
    // ?limit=20&retrieve_type=by_offset&ad=1&offset=0
    NSString *urlStr = [NSString stringWithFormat:@"%@%@?limit=20&retrieve_type=by_offset&ad=1&offset=0",baseURL,Home_allArticle];
    
    __weak typeof(self) weakSelf = self ;
    [LMYNetworkTool lmy_get:urlStr params:nil success:^(id response) {
//        LMYLog(@"%@",response);
        if ([response[@"ok"] isEqual:@1]) {
           weakSelf.articles = [LMYArticleModel mj_objectArrayWithKeyValuesArray:response[@"result"]];
            [weakSelf.tableView reloadData];
        }
    } failure:^(NSError *error) {
        LMYLog(@"全部主页：%@",error);
    }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1 + self.articles.count ;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        LMYHomeDateCell *cell = [LMYHomeDateCell homeDateCell:tableView];
        return cell ;
    }
    
    LMYArticleModel *article = self.articles[indexPath.row - 1];
    if ([article.source isEqualToString:@"calendar"]) {
        LMYHomeCalendarCell *calendarCell = [tableView dequeueReusableCellWithIdentifier:@"calenderCell"];
        calendarCell.articleModel = article ;
        return calendarCell;
    }

    LMYArticleListCell *cell = [LMYArticleListCell articleListCell:tableView];
    cell.articleModel = article;
    return cell ;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return HomeDateCellHeight;
    }

    LMYArticleModel *article = self.articles[indexPath.row - 1];
    if ([article.source isEqualToString:@"calendar"]) {
        LMYHomeCalendarCell *cell = [tableView dequeueReusableCellWithIdentifier:@"calenderCell"];
        return [cell cellHeight:article];
    }
    return HomeArticleListCellHeight;
}


@end
