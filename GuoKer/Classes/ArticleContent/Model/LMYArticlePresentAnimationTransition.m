//
//  LMYArticlePresentAnimationTransition.m
//  GuoKer
//
//  Created by Lumo on 16/8/30.
//  Copyright © 2016年 LM. All rights reserved.
//

#import "LMYArticlePresentAnimationTransition.h"

@interface LMYArticlePresentAnimationTransition ()

@property (nonatomic, assign) LMYArticlePresentAnimationTransitionType type ;

@end

@implementation LMYArticlePresentAnimationTransition

+ (instancetype)transitionType:(LMYArticlePresentAnimationTransitionType)type
{
    return [[self alloc] initWithTransitionType:type];
}

- (instancetype)initWithTransitionType:(LMYArticlePresentAnimationTransitionType)type
{
    if (self = [super init]) {
        self.type = type ;
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.3;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *toVc = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromVc = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    if (toVc.presentingViewController == fromVc) {
        LMYLog(@"弹出---------");
        [self presentAnimation:transitionContext];
    }else {
        LMYLog(@"退出---------");
        [self dismissAnimation:transitionContext];
    }
//    switch (self.type) {
//        case LMYArticlePresentAnimationTransitionTypePresent:
//            [self presentAnimation:transitionContext];
//            break;
//        case LMYArticlePresentAnimationTransitionTypeDismiss:
//            [self dismissAnimation:transitionContext];
//            break;
//        default:
//            break;
//    }
}

- (void)presentAnimation:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *toVc = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromVc = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    
    UIView *tempBgView = [fromVc.view snapshotViewAfterScreenUpdates:NO];
    tempBgView.frame = fromVc.view.frame ;
    [containerView addSubview:tempBgView];
    fromVc.view.hidden = YES ;
    
    UIView *cover = [[UIView alloc] initWithFrame:containerView.bounds];
    cover.backgroundColor = LMYColor(50, 50, 50, 0.4);
    [containerView addSubview:cover];
    
    UIView *whiteView = [[UIView alloc] init];
    whiteView.backgroundColor = [UIColor whiteColor];
    whiteView.frame = self.fromRect ;
    [containerView addSubview:whiteView];
    
    [containerView addSubview:toVc.view];
    toVc.view.hidden = YES ;
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    [UIView animateWithDuration:duration delay:0.2 options:UIViewAnimationOptionCurveLinear animations:^{
        whiteView.frame = CGRectMake(0, 0, containerView.width,containerView.height);
        tempBgView.transform = CGAffineTransformMakeScale(0.85, 0.85);
        cover.alpha = 0.8;
    } completion:^(BOOL finished) {
        BOOL wasCancelled = [transitionContext transitionWasCancelled];
        [transitionContext completeTransition:!wasCancelled];
        toVc.view.hidden = NO ;
        [whiteView removeFromSuperview];
        [tempBgView removeFromSuperview];
        [cover removeFromSuperview];
        if (wasCancelled) {
            fromVc.view.hidden = NO ;
        }
    }];
//    
//    [UIView animateWithDuration:duration  animations:^{
//        whiteView.frame = CGRectMake(0, 0, containerView.width,containerView.height);
//        tempBgView.transform = CGAffineTransformMakeScale(0.85, 0.85);
//        cover.alpha = 0.8;
//    } completion:^(BOOL finished) {
//        BOOL wasCancelled = [transitionContext transitionWasCancelled];
//        [transitionContext completeTransition:!wasCancelled];
//        toVc.view.hidden = NO ;
//        [whiteView removeFromSuperview];
//        [tempBgView removeFromSuperview];
//        [cover removeFromSuperview];
//        if (wasCancelled) {
//            fromVc.view.hidden = NO ;
//        }
//    }];
}

- (void)dismissAnimation:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *toVc = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromVc = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    UIView *containerView = [transitionContext containerView];
    CGRect endFrame = CGRectMake(0, containerView.height, containerView.width, containerView.height);
    [containerView addSubview:toVc.view];
    [containerView sendSubviewToBack:toVc.view];
    toVc.view.hidden = NO;

    NSTimeInterval duration = [self transitionDuration:transitionContext];
    [UIView animateWithDuration:duration animations:^{
        fromVc.view.frame = endFrame;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}
@end
