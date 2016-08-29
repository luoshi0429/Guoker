//
//  LMYHomeViewController.m
//  GuoKer
//
//  Created by Lumo on 16/8/8.
//  Copyright © 2016年 LM. All rights reserved.
//

#import "LMYHomeViewController.h"
#import "LMYScrollView.h"
#import "LMYSearchViewController.h"
#import "LMYAllTableViewController.h"
#import "LMYScienceViewController.h"
#import "LMYLifeViewController.h"
#import "LMYHealthViewController.h"
#import "LMYLearnViewController.h"
#import "LMYNatureViewController.h"
#import "LMYHumanityViewController.h"
#import "LMYEntertainmentViewController.h"
@interface LMYHomeViewController ()<UIScrollViewDelegate>

@property (nonatomic, weak) UIScrollView *topTitleScrollView ;
@property (nonatomic, weak) LMYScrollView *scrollView ;
@property (nonatomic, weak) UIView *bottomLine ;

@property (nonatomic,strong ) NSArray *titles ;
@property (nonatomic,strong ) NSMutableArray *titleWidths ;
@property (nonatomic,strong ) NSMutableArray *titleViews ;
@property (nonatomic, assign) BOOL isTapped ;
@property (nonatomic,assign ) NSInteger selectedIndex ;


@end

@implementation LMYHomeViewController

#pragma mark - lazy
- (NSArray *)titles
{
    if (_titles == nil)
    {
        _titles = @[@"全部",@"科技",@"生活",@"健康",@"学习",@"人文",@"自然",@"娱乐"] ;
    }
    return _titles ;
}

- (NSMutableArray *)titleWidths
{
    if (_titleWidths == nil)
    {
        _titleWidths = [[NSMutableArray alloc] init] ;
    }
    return _titleWidths ;
}

- (UIScrollView *)topTitleScrollView
{
    if (_topTitleScrollView == nil)
    {
        UIScrollView *topTitleScrollView = [[UIScrollView alloc] init];
        topTitleScrollView.backgroundColor = [[LMYThemeManager sharedManager] homeTopTitleViewBgColor];
        topTitleScrollView.showsVerticalScrollIndicator = NO ;
        topTitleScrollView.showsHorizontalScrollIndicator = NO ;
        topTitleScrollView.bounces = NO ;
        topTitleScrollView.scrollsToTop = NO ;
        [self.view addSubview:topTitleScrollView];
        _topTitleScrollView = topTitleScrollView ;
    }
    return _topTitleScrollView ;
}

- (LMYScrollView *)scrollView
{
    if (!_scrollView)
    {
        LMYScrollView *scrollView = [[LMYScrollView alloc] init];
        scrollView.contentSize = CGSizeMake(self.titles.count * scrollView.width, scrollView.height);
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.showsHorizontalScrollIndicator = NO ;
        scrollView.pagingEnabled = YES ;
        scrollView.delegate = self ;
        scrollView.bounces = NO ;
        scrollView.scrollsToTop = NO ;
        [self.view addSubview:scrollView];
        _scrollView = scrollView ;
    }
    return _scrollView ;
}

- (UIView *)bottomLine
{
    if (_bottomLine == nil)
    {
        UIView *bottomLine = [[UIView alloc] init] ;
        bottomLine.backgroundColor = [[LMYThemeManager sharedManager] homeTopTitleSelectedColor];
        [self.topTitleScrollView addSubview:bottomLine];
        _bottomLine = bottomLine;
    }
    return _bottomLine ;
}

- (NSMutableArray *)titleViews
{
    if (_titleViews == nil)
    {
        _titleViews = [[NSMutableArray alloc] init] ;
    }
    return _titleViews ;
}

#pragma mark - init
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self p_addChildVcs];
    [self p_setupUI];
}

- (void)p_addChildVcs
{
    LMYAllTableViewController *allTVC = [[LMYAllTableViewController alloc] init];
    [self addChildViewController:allTVC];
    
    LMYScienceViewController *scienceVc = [[LMYScienceViewController alloc] init];
    [self addChildViewController:scienceVc];
    
    LMYLifeViewController *lifeVc = [[LMYLifeViewController alloc] init];
    [self addChildViewController:lifeVc];
    
    LMYHealthViewController *healthVc = [[LMYHealthViewController alloc] init];
    [self addChildViewController:healthVc];
        
    LMYLearnViewController *learnVc = [[LMYLearnViewController alloc] init];
    [self addChildViewController:learnVc];
    
    LMYHumanityViewController *humanityVc = [[LMYHumanityViewController alloc] init];
    [self addChildViewController:humanityVc];
    
    LMYNatureViewController *natureVc = [[LMYNatureViewController alloc] init];
    [self addChildViewController:natureVc];
    
    LMYEntertainmentViewController *entertainmentVc = [[LMYEntertainmentViewController alloc] init];
    [self addChildViewController:entertainmentVc];
}

- (UIColor *)randomColor
{
    int r = arc4random() % 255 ;
    int g = arc4random() % 255 ;
    int b = arc4random() % 255 ;
    
    return [UIColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:1];
}

- (void)p_setupUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"果壳精选";
    self.automaticallyAdjustsScrollViewInsets = NO ;
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"bar_menu_icon_36x36_"] style:UIBarButtonItemStyleDone target:self action:@selector(p_showSideDeck)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"search_ic_36x36_"] style:UIBarButtonItemStyleDone target:self action:@selector(p_search)];
    
    self.topTitleScrollView.frame = CGRectMake(0, 64, self.view.width, HomeTopTitleViewHeight);
    
    self.scrollView.frame = CGRectMake(0, CGRectGetMaxY(self.topTitleScrollView.frame), self.view.width, self.view.height - CGRectGetMaxY(self.topTitleScrollView.frame));
    self.scrollView.contentSize = CGSizeMake(self.scrollView.width * self.titles.count, 0);
    
    CGFloat containerX = 0 ;
    for (int i = 0 ; i < self.titles.count; i ++)
    {
        UIView *labelContainerView = [[UIView alloc] init];
        labelContainerView.tag = i ;
        [self.topTitleScrollView addSubview:labelContainerView];
        [self.titleViews addObject:labelContainerView];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(p_topTitleViewTapped:)];
        [labelContainerView addGestureRecognizer:tapGesture];
        
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:15];
        label.text = self.titles[i];
        label.textColor = [[LMYThemeManager sharedManager] homeTopTitleColor];
        [labelContainerView addSubview:label];
        [label sizeToFit];
        
        [self.titleWidths addObject:@(label.width)];
        CGFloat containerWidth = label.width + 2 * HomeTopTitleViewMargin  ;
        labelContainerView.frame = CGRectMake(containerX, 0, containerWidth, self.topTitleScrollView.height);
        label.centerX = labelContainerView.width * 0.5;
        label.centerY = labelContainerView.height * 0.5;
        
        containerX = CGRectGetMaxX(labelContainerView.frame);
        
        // 设置顶部标题的contentSize
        if (i == self.titles.count - 1)
        {
            self.topTitleScrollView.contentSize = CGSizeMake(CGRectGetMaxX(labelContainerView.frame), self.topTitleScrollView.height);
        }
    }
    
    //添加topTitleScrollView的底部分割线
    UIView *seperatorView = [[UIView alloc] init];
    seperatorView.backgroundColor = LMYColor(234, 234, 234, 1);
    seperatorView.frame = CGRectMake(0, self.topTitleScrollView.height - SeperatorLineHeight, self.topTitleScrollView.width, SeperatorLineHeight);
    [self.topTitleScrollView addSubview:seperatorView];
    
    self.bottomLine.frame = CGRectMake(HomeTopTitleViewMargin, self.topTitleScrollView.height - HomeTopTitleViewBottomLineHeight, [self.titleWidths[0] floatValue], HomeTopTitleViewBottomLineHeight);
    
    // 默认选中第一个
    [self p_selectedViewControllerAtIndex:0];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(p_changeCategory:) name:HomeArticleCellCategoryBtnNotification object:nil];
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - action
- (void)p_changeCategory:(NSNotification *)note
{
    NSString *category = (NSString *)note.object ;
    NSUInteger index = [self.titles indexOfObject:category];
    if (index == NSNotFound) {
        return ;
    }
    [self p_selectedTopViewAtIndex:index];
}

//- (void)p_showSideDeck
//{
//    [[NSNotificationCenter defaultCenter] postNotificationName:LMYShowSideDeckNotification object:self];;
//}

- (void)p_search
{
    LMYSearchViewController *searchVc = [[LMYSearchViewController alloc] init];
    [self.navigationController pushViewController:searchVc animated:YES];
}

- (void)p_topTitleViewTapped:(UITapGestureRecognizer *)tapGesture
{
    UIView *view = tapGesture.view;
    NSInteger currentIndex  = view.tag ;
    [self p_selectedTopViewAtIndex:currentIndex];
}

- (void)p_selectedTopViewAtIndex:(NSInteger)currentIndex
{
    self.isTapped = YES ;
    
    [self p_selectedViewControllerAtIndex:currentIndex];
    
    UIView *view = self.titleViews[currentIndex] ;

    [UIView animateWithDuration:0.25 animations:^{
        self.bottomLine.x = view.x + HomeTopTitleViewMargin;
    }];
    //调整顶部条的contentOffset
    [self p_adjustTitleViewPositionAtIndex:currentIndex];
}

- (void)p_adjustTitleViewPositionAtIndex:(NSInteger)index
{
    UIView *titleView = self.titleViews[index];
    
    // 通过判断当前选中的view的center
    CGFloat currentCenterX = titleView.centerX ;
    CGFloat offsetX = currentCenterX - self.topTitleScrollView.width * 0.5 ;
    
    if (offsetX < 0) {
        offsetX = 0 ;
    }
    
    CGFloat maxOffsetX = self.topTitleScrollView.contentSize.width - self.topTitleScrollView.width * 0.5;
    if (currentCenterX > maxOffsetX) {
        offsetX = maxOffsetX - self.topTitleScrollView.width * 0.5 ;
    }
    [self.topTitleScrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    
}

- (void)p_selectedViewControllerAtIndex:(NSInteger)index
{
    // 设置文字的选中颜色
    UILabel *label = [[self.titleViews[self.selectedIndex] subviews] firstObject];
    label.textColor = [[LMYThemeManager sharedManager] homeTopTitleColor];
    self.selectedIndex = index ;
    
    UILabel *currentLabel = [[self.titleViews[index] subviews] firstObject];
    currentLabel.textColor = [[LMYThemeManager sharedManager] homeTopTitleSelectedColor];
    
    UITableViewController *vc = (UITableViewController *)self.childViewControllers[index];
    // 判断是否已经创建过vc
    if (![vc isViewLoaded]) {
        vc.view.frame = CGRectMake(self.scrollView.width * index, 0, self.scrollView.width, self.scrollView.height);
        [self.scrollView addSubview:vc.view];
    }
    
    for (UIView *sv in self.scrollView.subviews) {
        if ([sv isKindOfClass:[UIScrollView class]]) {
            if (sv != vc.tableView) {
                UITableView *tv = (UITableView *)sv;
                tv.scrollsToTop = NO ;
            }
        }
    }
    [self.scrollView setContentOffset:CGPointMake(index * self.scrollView.width, 0) animated:NO];
}

- (void)p_disableOtherScrollsToTop
{
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(scrollsToTop) withObject:@(NO)];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.isTapped)
    {
        self.isTapped = NO ;
        return ;
    }
     // 计算bottomLine的移动距离
    NSInteger currentIndex = scrollView.contentOffset.x / scrollView.frame.size.width ;
    CGFloat scrollViewOffsetX = scrollView.contentOffset.x ;
    CGFloat bottomLineDistance = [self.titleWidths[currentIndex] floatValue]+ HomeTopTitleViewMargin * 2;
    CGFloat bottomLineOffsetX = scrollViewOffsetX *  bottomLineDistance / scrollView.width ;
    self.bottomLine.x = HomeTopTitleViewMargin + bottomLineOffsetX ;
}

//// 代码设置contentOffset动画结束时调用
//- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
//{
//    
//}

// 手动拖拽结束的时候调用
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger currentIndex = scrollView.contentOffset.x / scrollView.frame.size.width ;
    
    [self p_selectedViewControllerAtIndex:currentIndex];
    [self p_adjustTitleViewPositionAtIndex:currentIndex];
}
@end
