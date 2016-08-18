//
//  LMYOtherBaseTVC.m
//  GuoKer
//
//  Created by Lumo on 16/8/16.
//  Copyright © 2016年 LM. All rights reserved.
//

#import "LMYOtherBaseTVC.h"
#import "LMYArticleListCell.h"
#import "LMYArticleModel.h"
#import <MJExtension.h>
#import <MJRefresh.h>

@interface LMYOtherBaseTVC ()
@property (nonatomic,strong) NSMutableArray *articles ;
@property (nonatomic,strong) NSArray *typeStrs ;
@property (nonatomic, assign) int offset ;

@end

@implementation LMYOtherBaseTVC

- (LMYTopicType)type
{
    return 0 ;
}

- (NSMutableArray *)articles
{
    if (_articles == nil)
    {
        _articles = [[NSMutableArray alloc] init] ;
    }
    return _articles ;
}

- (NSArray *)typeStrs
{
    if (_typeStrs == nil)
    {
        _typeStrs = @[@"science",@"life",@"health",@"learning",@"humanities",@"nature",@"entertainment"] ;
    }
    return _typeStrs ;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self p_setupUI];
    [self p_setupRefresh];
}

- (void)p_setupUI
{
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone ;
}

- (void)p_setupRefresh
{
    __weak typeof(self) weakSelf = self ;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.offset = 0 ;
        [weakSelf p_loadData];
    }];

    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(p_loadData)];
    self.tableView.mj_footer.hidden = YES ;
    
    [self.tableView.mj_header beginRefreshing];
}
- (void)p_loadData
{
    NSString *urlStr = [NSString stringWithFormat:
                        @"%@%@?limit=20&retrieve_type=by_offset&ad=1&offset=%d&category=%@"
                        ,baseURL,Home_allArticle,self.offset,self.typeStrs[self.type]];
    
    __weak typeof(self) weakSelf = self ;
    [LMYNetworkTool lmy_get:urlStr params:nil success:^(id response) {
        
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        //        LMYLog(@"%@",response);
        if ([response[@"ok"] isEqual:@1]) {
            if (weakSelf.offset == 0)
            {
                weakSelf.articles = [LMYArticleModel mj_objectArrayWithKeyValuesArray:response[@"result"]];
                weakSelf.tableView.mj_footer.hidden = NO ;
            }
            else
            {
                [weakSelf.articles addObjectsFromArray:[LMYArticleModel mj_objectArrayWithKeyValuesArray:response[@"result"]]];
            }
            weakSelf.offset = (int)weakSelf.articles.count ;
            [weakSelf.tableView reloadData];
        }
    } failure:^(NSError *error) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        LMYLog(@"全部主页：%@",error);
    }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.articles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LMYArticleListCell *cell = [LMYArticleListCell articleListCell:tableView];
    cell.hideCategortBtn = YES ;
    cell.articleModel = self.articles[indexPath.row];
    return cell ;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return HomeArticleListCellHeight;
}

@end
