//
//  ViewController.m
//  侧边栏Demo
//
//  Created by 刘敏 on 16/8/5.
//  Copyright © 2016年 LM. All rights reserved.
//

#import "LMYSideDeckViewController.h"
#import "LMYHomeViewController.h"
#import "LMYCollectTableViewController.h"
#import "LMYSettingTableViewController.h"
#import "LMYFeedbackViewController.h"
#import "LMYNavigationController.h"

#import "LMYSideDeckBottomView.h"

@interface LMYSideDeckViewController ()<UIGestureRecognizerDelegate,LMYSideDeckBottomViewDelegate>

@property (nonatomic, strong) UIView *topView ;
@property (nonatomic,strong ) UIScreenEdgePanGestureRecognizer *edgePan ;
@property (nonatomic,strong ) UIPanGestureRecognizer *pan ;
@property (nonatomic,strong ) LMYHomeViewController *topVc ;

@end

@implementation LMYSideDeckViewController

#define MAXOffsetX [UIScreen mainScreen].bounds.size.width * 3 / 4
#define TouchableX [UIScreen mainScreen].bounds.size.width * 1 / 4
static NSTimeInterval const DURATION = 0.3;

#pragma mark - lazy
- (UIView *)topView
{
    if (_topView == nil)
    {
        _topView = [[UIView alloc] init] ;
        _topView.backgroundColor = [UIColor greenColor];
        _topView.frame = self.view.bounds;
        [self.view addSubview:_topView];
    }
    return _topView ;
}

#pragma mark - init
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self p_addAllChildVc];
    [self p_setupUI];
    [self p_setupUIStyle];
}

- (void)p_addAllChildVc
{
    LMYHomeViewController *homeVc = [[LMYHomeViewController alloc] init];
    LMYNavigationController *homeNav = [[LMYNavigationController alloc] initWithRootViewController:homeVc];;
    [self addChildViewController:homeNav];
    
    LMYCollectTableViewController *collectVc = [[LMYCollectTableViewController alloc] init];
    LMYNavigationController *collectNav = [[LMYNavigationController alloc] initWithRootViewController:collectVc];;
    [self addChildViewController:collectNav];
    
    LMYSettingTableViewController *settingVc = [[LMYSettingTableViewController alloc] init];
    LMYNavigationController *settingNav = [[LMYNavigationController alloc] initWithRootViewController:settingVc];
    [self addChildViewController:settingNav];
    
    LMYFeedbackViewController *feedbackVc = [[LMYFeedbackViewController alloc] init];
    LMYNavigationController *feedbackNav = [[LMYNavigationController alloc] initWithRootViewController:feedbackVc];
    [self addChildViewController:feedbackNav];

}

- (void)p_setupUI
{
    UIImageView *logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"menu_guokr_logo"]];
    logoImageView.centerX = MAXOffsetX * 0.5 ;
    logoImageView.y = self.view.height - logoImageView.height - SideDeck_logoBottomMargin  ;
    [self.view addSubview:logoImageView];
    
    LMYSideDeckBottomView *bottomView = [[LMYSideDeckBottomView alloc] init];
    bottomView.titles = @[@"首页",@"收藏",@"设置",@"反馈"];
    bottomView.frame = CGRectMake(0, 0, MAXOffsetX, SideDeck_cellHeight * bottomView.titles.count);
    bottomView.centerY = self.view.height * 0.5 ;
    bottomView.delegate = self ;
    [self.view addSubview:bottomView];
    
    [self sideDeckBottomViewDidClickeAtIndex:0];
}

- (void)p_setupUIStyle
{
    self.view.backgroundColor = [[LMYThemeManager sharedManager] sideDeckBgColor];
}

//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
//{
//    if(self.pan == gestureRecognizer){
//        
//        CGPoint point = [gestureRecognizer locationInView:self.topView];
//        if (point.x < TouchableX ) {
//            return YES ;
//        }
//    }
//    return NO ;
//}

#pragma mark - 外部方法
- (void)showSideDeck
{
    [self p_topViewMoveTo:MAXOffsetX];
}

#pragma mark - LMYSideDeckBottomViewDelegate
- (void)sideDeckBottomViewDidClickeAtIndex:(NSInteger)index
{
    [self.topView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.topView addSubview:self.childViewControllers[index].view];

    UIScreenEdgePanGestureRecognizer *edgePan = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(showBottomView:)];
    edgePan.edges = UIRectEdgeLeft;
    [self.topView addGestureRecognizer:edgePan];
    self.edgePan = edgePan ;
    
    [self p_topViewMoveTo:0];
}

#pragma mark - 侧栏相关

- (void)showBottomView:(UIScreenEdgePanGestureRecognizer *)edgePan
{
    CGPoint point = [edgePan locationInView:self.view];
    float offsetX = point.x ;
    switch (edgePan.state) {
        case UIGestureRecognizerStateChanged:
            if (point.x >= MAXOffsetX)
            {
                offsetX = MAXOffsetX ;
            }
            CGRect tempRect = self.topView.frame;
            tempRect.origin.x = offsetX ;
            self.topView.frame = tempRect ;
            break;
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:
            [self p_topViewMoveTo:offsetX];
            break;
        default:
            break;
    }
}

- (void)p_topViewMoveTo:(CGFloat)offsetX
{
    if (offsetX <= MAXOffsetX * 0.5)
    {
        offsetX = 0;
        CGRect tempRect = self.topView.frame;
        tempRect.origin.x = offsetX ;
        [UIView animateWithDuration:DURATION animations:^{
            self.topView.frame = tempRect ;
        }];
        
        [self.topView removeGestureRecognizer:self.pan];
        self.pan = nil ;
    }
    else
    {
        offsetX = MAXOffsetX;
        CGRect tempRect = self.topView.frame;
        tempRect.origin.x = offsetX ;
        [UIView animateWithDuration:DURATION animations:^{
            self.topView.frame = tempRect ;
        }];
        
        if (self.pan) {
            return;
        }
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(backTopView:)];
        [self.topView addGestureRecognizer:pan];
        self.pan = pan ;
    }

}

- (void)backTopView:(UIPanGestureRecognizer *)pan
{
    CGPoint point = [pan locationInView:self.view];
    float offsetX = point.x ;
    switch (pan.state) {
        case UIGestureRecognizerStateChanged:
            if (point.x == 0)
            {
                offsetX = 0 ;
            }
            
            if (point.x >= MAXOffsetX)
            {
                offsetX = MAXOffsetX ;
            }
            
            CGRect tempRect = self.topView.frame;
            tempRect.origin.x = offsetX ;
            self.topView.frame = tempRect ;
            break;
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:
            [self p_topViewMoveTo:offsetX];
            break;
        default:
            break;
    }
}

@end
