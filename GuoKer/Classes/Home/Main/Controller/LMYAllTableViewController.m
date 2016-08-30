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
#import "LMYArticleViewController.h"
#import "LMYArticleOtherListCell.h"
#import "LMYArticlePresentAnimationTransition.h"

@interface LMYAllTableViewController ()<UIViewControllerTransitioningDelegate>
@property (nonatomic, weak) LMYInfiniteScrollView *handpickScrollView ;
@property (nonatomic,strong) NSMutableArray *articles ;
@property (nonatomic, assign) int offset ;
@property (nonatomic,strong ) NSMutableArray *pickids ;
@property (nonatomic,strong) NSCache *cellHeightCache ;
//@property (nonatomic, assign) NSInteger dayCount ;
@property (nonatomic,strong) NSMutableArray *days ;
@property (nonatomic,strong) LMYArticlePresentAnimationTransition *animationTransition ;


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

- (NSCache *)cellHeightCache
{
    if (_cellHeightCache == nil)
    {
        _cellHeightCache = [[NSCache alloc] init] ;
        [_cellHeightCache setCountLimit:5];
    }
    return _cellHeightCache ;
}

- (LMYArticlePresentAnimationTransition *)animationTransition
{
    if (_animationTransition == nil)
    {
        _animationTransition = [[LMYArticlePresentAnimationTransition alloc] init] ;
    }
    return _animationTransition ;
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
    self.tableView.mj_footer.hidden = YES ;
    
    [self.tableView registerClass:[LMYHomeCalendarCell class] forCellReuseIdentifier:@"calenderCell"];
    [self.tableView registerClass:[LMYArticleOtherListCell class] forCellReuseIdentifier:@"articleOtherListCell"];
//    self.dayCount = 1;
}

#pragma mark - 数据相关
/**
 *  文章
 */
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
                weakSelf.articles = nil ;
                weakSelf.tableView.mj_footer.hidden = NO ;
            }
            
            [response[@"result"] enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
                LMYArticleModel *article = [LMYArticleModel mj_objectWithKeyValues:dict];
                LMYArticleModel *lastArticle = weakSelf.articles.lastObject ;
                if (!lastArticle)
                {
                    LMYArticleModel *dayArticle = [[LMYArticleModel alloc] init];
                    dayArticle.isOtherDay = YES;
                    dayArticle.date_picked = article.date_picked;
                    [weakSelf.articles addObject:dayArticle];
                    [weakSelf.articles addObject:article];
                }
                else
                {
                    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
                    NSDate *pickedDate = [NSDate dateWithTimeIntervalSince1970:[article.date_picked doubleValue]];
                    NSDate *lastPickedDate = [NSDate dateWithTimeIntervalSince1970:[lastArticle.date_picked doubleValue]];
               
                    if ([currentCalendar isDate:pickedDate inSameDayAsDate:lastPickedDate])
                    {
                        [weakSelf.articles addObject:article];
                    }
                    else
                    {
                        LMYArticleModel *dayArticle = [[LMYArticleModel alloc] init];
                        dayArticle.isOtherDay = YES;
                        dayArticle.date_picked = article.date_picked;
                        [weakSelf.articles addObject:dayArticle];
                        [weakSelf.articles addObject:article];
                    }
                }
            }];
           
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
 *  精选文章id
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

/**
 *  精选文章的详细数据
 */
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
//        LMYLog(@"%@",response);
    } failure:^(NSError *error) {
        LMYLog(@"精选详细：%@",error);
    }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  self.articles.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LMYArticleModel *article = self.articles[indexPath.row];
    if (article.isOtherDay == YES)
    {
        LMYHomeDateCell *cell = [LMYHomeDateCell homeDateCell:tableView];
        cell.pickedDateStr = article.date_picked ;
        return cell ;
    }
    
    if ([article.source isEqualToString:@"calendar"]) {
        LMYHomeCalendarCell *calendarCell = [tableView dequeueReusableCellWithIdentifier:@"calenderCell"];
        calendarCell.articleModel = article ;
        return calendarCell;
    }
    
    if (article.articleContent) {
        LMYArticleOtherListCell *otherCell = [tableView dequeueReusableCellWithIdentifier:@"articleOtherListCell"];
        otherCell.articleModel = article ;
        return otherCell ;
    }

    LMYArticleListCell *cell = [LMYArticleListCell articleListCell:tableView];
    cell.articleModel = article;
    return cell ;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LMYArticleModel *article = self.articles[indexPath.row];
    if (article.isOtherDay == YES)
    {
        if (indexPath.row == 0) {
            
            return HomeDateCellHeight;
        }
        return HomeDateCellHeight - HomeCellMarginBottom ;
    }
    
    if ([article.source isEqualToString:@"calendar"])
    {
        NSNumber *result = [self.cellHeightCache objectForKey:article.article_id];
        if (result) {
            return [result floatValue];
        }

        LMYHomeCalendarCell *cell = [tableView dequeueReusableCellWithIdentifier:@"calenderCell"];
        CGFloat calendarHeight = [cell cellHeight:article];
        [self.cellHeightCache setObject:@(calendarHeight) forKey:article.article_id];
        return calendarHeight;
    }
    
    
    if (article.articleContent) {
        NSNumber *result = [self.cellHeightCache objectForKey:article.article_id];
        if (result) {
            return [result floatValue];
        }
        
        LMYArticleOtherListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"articleOtherListCell"];
        CGFloat cellHeight = [cell cellHeight:article];
        [self.cellHeightCache setObject:@(cellHeight) forKey:article.article_id];
        return cellHeight;
    }
    return HomeArticleListCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LMYArticleModel *article = self.articles[indexPath.row];
    if (article.isOtherDay)
    {
        return ;
    }
    
    LMYArticleViewController *articleVc = [[LMYArticleViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:articleVc];
    articleVc.articleModel = self.articles[indexPath.row];
//    nav.modalPresentationStyle = UIModalPresentationCustom ;
    nav.transitioningDelegate = self ;
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIWindow *window = [UIApplication sharedApplication] .keyWindow;
    self.animationTransition.fromRect = [self.view convertRect:cell.frame toView:window];
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - UIViewControllerTransitioningDelegate
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return self.animationTransition;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return self.animationTransition;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    [self.cellHeightCache removeAllObjects];
}

@end
