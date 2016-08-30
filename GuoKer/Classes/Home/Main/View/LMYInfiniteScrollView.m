//
//  LMInfiniteScrollView.m
//  无限循环的图片轮播器
//
//  Created by 刘敏 on 15/10/4.
//  Copyright (c) 2015年 刘敏. All rights reserved.
//

#import "LMYInfiniteScrollView.h"
#import <UIImageView+WebCache.h>

@interface LMYInfiniteScrollView()<UIScrollViewDelegate>

@property(nonatomic,weak) UIScrollView *scrollView ;
@property(nonatomic,weak) UIPageControl *pageControl ;

@property(nonatomic,weak) UILabel *describeLabel ;

@property(nonatomic,weak) UIImageView *bgView ;

@property (nonatomic,strong) NSTimer *timer ;

@property(nonatomic,assign)NSInteger currentIndex ;

@property (nonatomic,strong ) NSOperationQueue *operationQueue ;
@property (nonatomic,strong ) NSMutableDictionary *downloadOperation;
@property (nonatomic,strong ) NSCache *imageCache ;

@end

@implementation LMYInfiniteScrollView

static int const totalImageViewCount = 3 ;

#pragma mark - lazy
- (NSOperationQueue *)operationQueue
{
    if (_operationQueue == nil)
    {
        _operationQueue = [[NSOperationQueue alloc] init] ;
    }
    return _operationQueue ;
}

- (NSMutableDictionary *)downloadOperation
{
    if (_downloadOperation == nil)
    {
        _downloadOperation = [[NSMutableDictionary alloc] init] ;
    }
    return _downloadOperation ;
}

- (NSCache *)imageCache
{
    if (_imageCache == nil)
    {
        _imageCache = [[NSCache alloc] init] ;
        
        _imageCache.countLimit = 8;
    }
    return _imageCache ;
}

#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self p_setup];
        // 默认portrait为no
        self.portrait = NO ;
        // 滚动间隔默认为3S
        self.timeInterval = 3.0 ;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(p_memoryWarning) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
        
    }
    return self ;
}

- (void)p_setup
{
    //添加scrollView
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.scrollsToTop = NO;
    //将scrollView的竖直和水平方向说的指示条隐藏后，scrollView中就没有别的子控件了
    scrollView.showsHorizontalScrollIndicator = NO ;
    scrollView.showsVerticalScrollIndicator = NO ;
    scrollView.pagingEnabled = YES ;
    scrollView.bounces = NO;
    scrollView.delegate = self ;
    [self addSubview:scrollView];
    self.scrollView = scrollView ;
    
    //添加三个UIImageView
    for (int i = 0 ; i < totalImageViewCount ; i ++)
    {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFill ;
        imageView.userInteractionEnabled = YES ;
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)];
        [imageView addGestureRecognizer:tapGes];
        
        [self.scrollView addSubview:imageView];
    }
    
    //添加蒙板
    UIImageView *bgView = [[UIImageView alloc] init];
    [self addSubview:bgView];
    self.bgView = bgView ;
    
    //添加pageControl
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    pageControl.pageIndicatorTintColor = [UIColor grayColor];
    pageControl.currentPageIndicatorTintColor = [UIColor greenColor];
    pageControl.userInteractionEnabled = NO ;
    [bgView addSubview:pageControl];
    self.pageControl = pageControl ;
    
    // 添加描述标题
    UILabel *describeLabel = [[UILabel alloc] init];
    describeLabel.numberOfLines = 2 ;
    describeLabel.font = [UIFont boldSystemFontOfSize:18];
    describeLabel.textColor = [UIColor whiteColor];
    [bgView addSubview:describeLabel];
    self.describeLabel = describeLabel ;
}


- (void)p_setupImageViews
{
    // 只有一张图
    if (self.images.count == 1 || self.imageUrls.count == 1 || self.describeArray.count == 1) {
        
        self.scrollView.scrollEnabled = NO ;
        [self p_stopTimer];
        UIImageView *iv = self.scrollView.subviews[0] ;
        if (self.images) {
            iv.image = self.images[0];
//            [self.scrollView.subviews makeObjectsPerformSelector:@selector(setImage:) withObject: [self downloadImageWithUrlString:self.images[0]]];
        } else {
//            [iv sd_setImageWithURL:[NSURL URLWithString:self.imageUrls[0]] placeholderImage:[UIImage imageNamed:@"img_banner_loading"]];
            iv.image = [self downloadImageWithUrlString:self.imageUrls[0]];
//            [self.scrollView.subviews makeObjectsPerformSelector:@selector(setImage:) withObject: [self downloadImageWithUrlString:self.imageUrls[0]]];
        }
        
        self.describeLabel.text = self.describeArray[0];

        return ;
    }
    
    self.scrollView.scrollEnabled = YES ;
    
    for (int i = 0; i < totalImageViewCount; i ++)
    {
        UIImageView *imageView = self.scrollView.subviews[i];
        
        NSInteger index = self.currentIndex ;//self.pageControl.currentPage ;
        
        if (self.describeArray.count > 0 && index < self.describeArray.count) {
            self.describeLabel.text = self.describeArray[index];
        }
        
        if (i == 0) {
            index -- ;
        }else if (i == 2)
        {
            index ++ ;
        }
        if (index < 0)
        {
            if (self.images) {
                index = self.images.count - 1;
            }else if (self.imageUrls) {
                index = self.imageUrls.count -1 ;
            }
        }else if (index >=  (self.images ? self.images.count : self.imageUrls.count))
        {
            index = 0 ;
        }
        imageView.tag = index ;
        if (self.images) {
            imageView.image = self.images[index];
        }else if (self.imageUrls) {
            imageView.image = [self downloadImageWithUrlString:self.imageUrls[index]];
//            [imageView sd_setImageWithURL:[NSURL URLWithString:self.imageUrls[index]] placeholderImage:[UIImage imageNamed:@"img_banner_loading"]];
        }
        
    }
    
    //设置scrollView的偏移量到中间
    if (self.isPortrait)
    {
        self.scrollView.contentOffset = CGPointMake(0, self.scrollView.frame.size.height);
    }else
    {
        self.scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width, 0 );
    }
    
    [self p_startTimer];
}

#pragma mark - setter和getter方法
- (void)setImages:(NSArray *)images
{
    _images = images ;
    
    self.pageControl.numberOfPages = images.count ;
    self.pageControl.currentPage = 0 ;
    
    [self p_setupImageViews];
}

- (void)setImageUrls:(NSArray *)imageUrls
{
    _imageUrls = imageUrls ;
    
    if (!imageUrls || imageUrls.count == 0) {
        return;
    }
    
    self.pageControl.numberOfPages = _imageUrls.count ;
    
    if (!self.currentIndex || self.currentIndex > imageUrls.count) {
        self.currentIndex = 0 ;
    }
    self.pageControl.currentPage = self.currentIndex;
    
    [self p_setupImageViews];
}

- (void)setIndicatorColor:(UIColor *)indicatorColor
{
    _indicatorColor = indicatorColor ;
    self.pageControl.pageIndicatorTintColor = indicatorColor ;
}

- (void)setCurrentIndicatorColor:(UIColor *)currentIndicatorColor
{
    _currentIndicatorColor = currentIndicatorColor ;
    self.pageControl.currentPageIndicatorTintColor = currentIndicatorColor ;
}

- (void)setDescribeBgImage:(UIImage *)describeBgImage
{
    _describeBgImage = describeBgImage ;
    
    self.bgView.image = describeBgImage ;
}

- (void)setDescribeArray:(NSArray *)describeArray
{
    _describeArray = describeArray ;
    
    [self layoutSubviews];
    [self p_setupImageViews];
}

#pragma mark - 下载图片相关
- (UIImage *)downloadImageWithUrlString:(NSString *)urlStr
{
    if ([urlStr isEqualToString:@""]) {
        return nil ;
    }
    // 1.判断内存中是否有图片
    UIImage *cacheImage = [self.imageCache objectForKey:urlStr];
    if (cacheImage) {
        return cacheImage;
    }
    
    // 2.判断沙盒中是否有图片
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *imagePath = [cachePath stringByAppendingPathComponent:[urlStr lastPathComponent]];
    UIImage *savedImage = [UIImage imageWithContentsOfFile:imagePath];
    
    if (savedImage) {
        // 2.1 沙盒中有图片，设置为内存图片
        [self.imageCache setObject:savedImage forKey:urlStr];
        return savedImage ;
    }
    
    // 3.从网络下载
    // 3.1 判断是否在下载中
    if (self.downloadOperation[urlStr] == nil){
        
        NSBlockOperation *blockOp = [NSBlockOperation blockOperationWithBlock:^{
            NSURL *url = [NSURL URLWithString:urlStr];
            NSData *data = [NSData dataWithContentsOfURL:url];
            UIImage *image  = [UIImage imageWithData:data];
            
            // 存入沙盒
            [data writeToFile:imagePath atomically:YES];
            
            // 清除已经完成的下载操作
            [self.downloadOperation removeObjectForKey:urlStr];
            
            // 设置为内存图片
            if (image) {
                [self.imageCache setObject:image forKey:urlStr];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self p_setupImageViews];
            });
        }];
        [self.downloadOperation setObject:blockOp forKey:urlStr];
        [self.operationQueue addOperation:blockOp];
    }
    
    return nil;
}

#pragma mark -  <UIScrollViewDelegate>

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger page = 0;
    CGFloat minDistance = MAXFLOAT ;
    //取得中间的imageView
    for (int i = 0; i < totalImageViewCount; i ++)
    {
        UIImageView *imageView = self.scrollView.subviews[i];
        CGFloat distance = 0;
        if (self.isPortrait) {
            distance = ABS(self.scrollView.contentOffset.y - imageView.frame.origin.y);
        }else
        {
            distance = ABS(self.scrollView.contentOffset.x - imageView.frame.origin.x) ;
        }
        if (distance < minDistance) {
            minDistance = distance ;
            page = imageView.tag ;
        }
    }
    self.pageControl.currentPage = page ;
    
    self.currentIndex = page ;
}

/**
 *  手动拖拽后减速停止调用
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self p_setupImageViews];
}

/**
 *  代码设置的时候调用
 */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self p_setupImageViews];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self p_stopTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self p_startTimer];
}

#pragma mark - NSTimer 定时器处理
- (void)p_startTimer
{
    if (self.timer) {
        [self p_stopTimer];
    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.timeInterval target:self selector:@selector(p_nextImage) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)p_stopTimer
{
    [self.timer invalidate];
    self.timer = nil ;
}

- (void)p_nextImage
{
    if (self.isPortrait)
    {
        [self.scrollView setContentOffset:CGPointMake(0, self.scrollView.frame.size.height * 2 ) animated:YES];
    }
    else
    {
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width * 2 , 0 ) animated:YES];
    }
}
#pragma mark -  外部控制方法

- (void)tapImage:(UITapGestureRecognizer *)tap
{
    self.tapImageBlock ? self.tapImageBlock(tap.view.tag) : nil ;
}

#pragma mark -  布局子控件
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat selfWidth = self.bounds.size.width ;
    CGFloat selfHeight = self.bounds.size.height ;
    self.scrollView.frame = self.bounds;
    
    if (self.isPortrait) {
        self.scrollView.contentSize = CGSizeMake(0, selfHeight * totalImageViewCount);
    }else
    {
        self.scrollView.contentSize = CGSizeMake(selfWidth * totalImageViewCount, 0);
    }
    
    NSInteger imageCount = self.images ? self.images.count : self.imageUrls.count ;
    CGFloat pageW = imageCount * 15 ;
    if (!self.describeArray || self.describeArray.count == 0) {
        CGFloat pageH = 30 ;
        CGFloat pageX = (selfWidth - pageW)* 0.5 ;
        CGFloat pageY = selfHeight - pageH ;
        
        self.bgView.frame = CGRectMake(0, pageY, selfWidth, pageH);
        self.pageControl.frame = CGRectMake(pageX, 0, pageW, pageH);
        
    } else {
        CGFloat labelHeight = self.describeLabel.font.lineHeight ;
        CGFloat margin_twelve = 12 ;
        CGFloat margin_ten = 10 ;
        CGFloat margin_fifteen = 15 ;
        
        self.bgView.frame = CGRectMake(0, selfHeight - labelHeight*2- 2 * margin_ten, selfWidth, labelHeight * 2 + 2 * margin_ten);
        
        self.describeLabel.frame = CGRectMake(margin_twelve , margin_ten ,selfWidth - pageW - margin_twelve - margin_fifteen , labelHeight * 2);
        self.pageControl.frame = CGRectMake(CGRectGetMaxX(self.describeLabel.frame),(self.bgView.frame.size.height - labelHeight ) * 0.5, pageW, labelHeight);
    }
    
    for (int i = 0 ; i < totalImageViewCount; i ++)
    {
        UIImageView *imageView = self.scrollView.subviews[i];
        
        if (self.isPortrait) {
            //竖直方向滚动的scrollView
            imageView.frame = CGRectMake(0, self.scrollView.frame.size.height * i, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
        }else
        {
            //水平方向上滚动的scrollView
            imageView.frame = CGRectMake(self.scrollView.frame.size.width * i, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
        }
    }
    
//    [self p_setupImageViews];
}

#pragma mark - 通知
- (void)p_memoryWarning
{
    [self.downloadOperation removeAllObjects];
    [self.imageCache removeAllObjects];
    [self.operationQueue cancelAllOperations];
}

@end
