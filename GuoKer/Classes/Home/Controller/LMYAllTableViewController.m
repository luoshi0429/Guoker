//
//  LMYAllTableViewController.m
//  GuoKer
//
//  Created by Lumo on 16/8/11.
//  Copyright © 2016年 LM. All rights reserved.
//

#import "LMYAllTableViewController.h"
#import "LMYInfiniteScrollView.h"
#import "LMYHomeHandpick.h"
#import <MJExtension.h>
#import <MJRefresh.h>
#import "LMYHomeCalendarCell.h"
#import "LMYHomeDateCell.h"
#import "LMYArticleListCell.h"
#import "LMYArticleModel.h"
#import "LMYArticleSource.h"

@interface LMYAllTableViewController ()
@property (nonatomic, weak) LMYInfiniteScrollView *handpickScrollView ;
@property (nonatomic,strong) NSMutableArray *articles ;
@property (nonatomic, assign) int offset ;
@property (nonatomic,strong ) NSMutableArray *pickids ;

@end

@implementation LMYAllTableViewController

#pragma mark - lazy
- (NSMutableArray *)articles
{
    if (_articles == nil)
    {
        _articles = [[NSMutableArray alloc] init] ;
    }
    return _articles ;
}

- (NSMutableArray *)pickids
{
    if (_pickids == nil)
    {
        _pickids = [[NSMutableArray alloc] init] ;
    }
    return _pickids ;
}

#pragma mark - 初始化操作
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self p_setupUI];
}

- (void)p_setupUI
{
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone ;
    
    LMYInfiniteScrollView *handpickScrollView = [[LMYInfiniteScrollView alloc] init];
    handpickScrollView.frame = CGRectMake(0, 0, self.tableView.width, HomeInfiniteScrollViewHeight);
    self.tableView.tableHeaderView = handpickScrollView;
    self.handpickScrollView = handpickScrollView ;
    
    __weak typeof(self) weakSelf = self ;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.offset = 0 ;
        [weakSelf p_loadArticleData];
        [weakSelf p_loadAdPickid];
    }];
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(p_loadArticleData)];
    
    [self.tableView registerClass:[LMYHomeCalendarCell class] forCellReuseIdentifier:@"calenderCell"];
}

#pragma mark - 数据相关
- (void)p_loadArticleData
{
    NSString *urlStr = [NSString stringWithFormat:
                        @"%@%@?limit=20&retrieve_type=by_offset&ad=1&offset=%d",
                        baseURL,Home_allArticle,self.offset];
    
    __weak typeof(self) weakSelf = self ;
    [LMYNetworkTool lmy_get:urlStr params:nil success:^(id response) {
        if (weakSelf.tableView.mj_header.isRefreshing)
        {
            [weakSelf.tableView.mj_header endRefreshing];
        }
        [weakSelf.tableView.mj_footer endRefreshing];
        if ([response[@"ok"] isEqual:@1])
        {
            if (weakSelf.offset == 0)
            {
                weakSelf.articles = [LMYArticleModel mj_objectArrayWithKeyValuesArray:response[@"result"]];
            }
            else
            {
                [weakSelf.articles addObjectsFromArray:[LMYArticleModel mj_objectArrayWithKeyValuesArray:response[@"result"]]];
            }
            weakSelf.offset = (int)weakSelf.articles.count ;
            [weakSelf.tableView reloadData];
        }
    } failure:^(NSError *error) {
        if (weakSelf.tableView.mj_header.isRefreshing) {
            [weakSelf.tableView.mj_header endRefreshing];
        }
        [weakSelf.tableView.mj_footer endRefreshing];
        LMYLog(@"全部主页：%@",error);
    }];
}

/**
 *  精选图片
 */
- (void)p_loadAdPickid
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",baseURL,Home_adPickid];
    __weak typeof(self) weakSelf = self ;
    [LMYNetworkTool lmy_get:urlStr params:nil success:^(id response) {
        
        if (weakSelf.tableView.mj_header.isRefreshing)
        {
            [weakSelf.tableView.mj_header endRefreshing];
        }
        if ([response[@"ok"] isEqual:@1]) {
            NSArray *handpicks = [LMYHomeHandpick mj_objectArrayWithKeyValuesArray:response[@"result"]];
            NSMutableArray *imageUrls = [NSMutableArray array];
            NSMutableArray *descTitles = [NSMutableArray array];
            for (LMYHomeHandpick *handpick in handpicks)
            {
                if(![handpick.picture isEqualToString:@""] && ![handpick.custom_title isEqualToString:@""])
                {
                    [imageUrls addObject:handpick.picture];
                    [descTitles addObject:handpick.custom_title];
                    [weakSelf.pickids addObject:handpick.article_id];
                }
            }
            weakSelf.handpickScrollView.imageUrls = imageUrls ;
            weakSelf.handpickScrollView.describeArray = descTitles ;
            [weakSelf p_fetchDetailData];
        }
    } failure:^(NSError *error) {
        if (weakSelf.tableView.mj_header.isRefreshing)
        {
            [weakSelf.tableView.mj_header endRefreshing];
        }
        LMYLog(@"轮播图ID:%@",error);
    }];
}

- (void)p_fetchDetailData
{
    NSString *baseUrl = [NSString stringWithFormat:@"%@%@",baseURL,Home_handpickDetail];
    NSMutableString *tempStr = [NSMutableString stringWithString:@"?"];
    for (int i = 0; i < self.pickids.count; i ++) {
        if (i != self.pickids.count - 1) {
            [tempStr appendFormat:@"pick_id=%@&",self.pickids[i]];
        } else {
            [tempStr appendFormat:@"pick_id=%@",self.pickids[i]];
        }
    }
    NSString *urlStr = [baseUrl stringByAppendingString:tempStr];
    [LMYNetworkTool lmy_get:urlStr params:nil success:^(id response) {
        LMYLog(@"%@",response);
    } failure:^(NSError *error) {
        LMYLog(@"精选详细：%@",error);
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
