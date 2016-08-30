//
//  LMYArticleViewController.m
//  GuoKer
//
//  Created by Lumo on 16/8/17.
//  Copyright © 2016年 LM. All rights reserved.
//

#import "LMYArticleViewController.h"
#import "LMYArticleModel.h"
#import <objc/runtime.h>
#import <WebKit/WebKit.h>

@interface LMYArticleViewController ()<WKNavigationDelegate,UIScrollViewDelegate>
@property (nonatomic, weak) WKWebView *webView ;
@property (nonatomic, weak) UIButton *likeBtn ;
@property (nonatomic, weak) UIProgressView *progressView ;

@end

@implementation LMYArticleViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self p_setupNav];
    [self p_setupUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)p_setupNav
{
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"bar_dismiss_icon"] style:UIBarButtonItemStyleDone target:self action:@selector(p_dismiss)];
    
    UIButton *likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [likeBtn setImage:[UIImage imageNamed:@"bar_heart_empty_icon"] forState:UIControlStateNormal];
    [likeBtn setImage:[UIImage imageNamed:@"bar_heart_like_icon"] forState:UIControlStateSelected];
    [likeBtn sizeToFit];
    [likeBtn addTarget:self action:@selector(p_collectThisArticle) forControlEvents:UIControlEventTouchUpInside];
    self.likeBtn = likeBtn ;
    UIBarButtonItem *likeItem = [[UIBarButtonItem alloc] initWithCustomView:likeBtn];
    
    UIBarButtonItem *shareItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"bar_share_icon"] style:UIBarButtonItemStyleDone target:self action:@selector(p_share)];
    self.navigationItem.rightBarButtonItems = @[shareItem,likeItem];
    CGFloat barHeight = 44 ;
    UIView *bottomSeparatorView = [[UIView alloc] init];
    bottomSeparatorView.backgroundColor = LMYSeparatorLineColor;
    bottomSeparatorView.frame = CGRectMake(0, barHeight - SeperatorLineHeight, self.view.width, SeperatorLineHeight);
    [self.navigationController.navigationBar addSubview:bottomSeparatorView];
    
    UIProgressView *progressView = [[UIProgressView alloc] initWithFrame:bottomSeparatorView.frame];
    progressView.progress = 0.0 ;
    progressView.tintColor = LMYColor(24, 163, 75, 1);
    progressView.trackTintColor = [UIColor clearColor];//[UIColor whiteColor];
    [self.navigationController.navigationBar addSubview:progressView];
    self.progressView = progressView ;

}

- (void)p_setupUI
{
    self.view.backgroundColor = [UIColor redColor];
    
    WKWebView *webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
    webView.navigationDelegate = self ;
    [self.view addSubview:webView];
    self.webView = webView ;
//    webView.scrollView.delegate = self ;
    [webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
    [webView addObserver:self forKeyPath:@"scrollView.contentOffset" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld | NSKeyValueObservingOptionInitial context:NULL];
    
    
    [self setArticleModel:self.articleModel];
}

- (void)setArticleModel:(LMYArticleModel *)articleModel
{
    _articleModel = articleModel ;
    
    NSURL *url = [NSURL URLWithString:articleModel.link_v2_sync_img];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    
}

- (void)dealloc
{
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.webView removeObserver:self forKeyPath:@"scrollView.contentOffset"];
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        if ([change[@"new"] doubleValue] >= 0.99) {
            self.progressView.progress = 0.0 ;
            return ;
        }
        self.progressView.progress = [change[@"new"] doubleValue];
        return ;
    }
    
//    CGFloat oldOffsetY = [change[@"old"] CGPointValue].y;
//    CGFloat newOffsetY = [change[@"new"] CGPointValue].y;
//    CGFloat offset = newOffsetY - oldOffsetY ;

}

#pragma mark - action
- (void)p_collectThisArticle
{
    if (self.likeBtn.isSelected) { // 已点赞
        self.likeBtn.selected = NO ;
        UIImageView *leftHeart = [[UIImageView alloc] init];
        leftHeart.image = [UIImage imageNamed:@"bar_heart_left_icon"];
        UIImageView *rightHeart = [[UIImageView alloc] init];
        rightHeart.image = [UIImage imageNamed:@"bar_heart_right_icon"];
        [self.navigationController.navigationBar addSubview:leftHeart];
        [self.navigationController.navigationBar addSubview:rightHeart];
        leftHeart.frame = CGRectMake(self.likeBtn.x - self.likeBtn.width * 0.25, self.likeBtn.y, self.likeBtn.width, self.likeBtn.height);
        rightHeart.frame = CGRectMake(self.likeBtn.x + self.likeBtn.width * 0.25, self.likeBtn.y, self.likeBtn.width, self.likeBtn.height);
        self.likeBtn.transform = CGAffineTransformMakeScale(0.0001, 0.0001);
        
        [UIView animateWithDuration:0.25 animations:^{
            self.likeBtn.transform = CGAffineTransformMakeScale(1.0, 1.0);
            leftHeart.transform = CGAffineTransformMakeRotation(-M_PI_4);
            rightHeart.transform = CGAffineTransformMakeRotation(M_PI_4);
        } completion:^(BOOL finished) {
            [leftHeart removeFromSuperview];
            [rightHeart removeFromSuperview];
        }];
    }else {
        self.likeBtn.selected = YES ;
        [UIView animateWithDuration:0.15 delay:0 usingSpringWithDamping:0.1 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.likeBtn.transform = CGAffineTransformMakeScale(1.2, 1.2);
        } completion:^(BOOL finished) {
            self.likeBtn.transform = CGAffineTransformIdentity;
        }];
    }
}

- (void)p_share
{
    LMYLog(@"分享");
}

- (void)p_dismiss
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    LMYLog(@"didStartProvisionalNavigation");
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation
{
    LMYLog(@"didCommitNavigation");
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    LMYLog(@"didFinishNavigation");
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    LMYLog(@"didFailProvisionalNavigation");
}

#pragma mark - UIScrollViewDelegate
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    
//}

@end
