//
//  LMYHomeHandpickView.m
//  GuoKer
//
//  Created by Lumo on 16/8/12.
//  Copyright © 2016年 LM. All rights reserved.
//

#import "LMYHomeHandpickView.h"
#import "LMYInfiniteScrollView.h"
#import "LMYHomeHandpick.h"
#import <MJExtension.h>

@interface LMYHomeHandpickView()

@property (nonatomic, weak) LMYInfiniteScrollView *handpickScrollView ;
@property (nonatomic,strong ) NSMutableArray *pickids ;

@end


@implementation LMYHomeHandpickView

- (NSMutableArray *)pickids
{
    if (_pickids == nil)
    {
        _pickids = [[NSMutableArray alloc] init] ;
    }
    return _pickids ;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self p_setupUI];
        
        [self p_loadAdPickid];
    }
    return self ;
}

- (void)p_setupUI
{
    LMYInfiniteScrollView *handpickScrollView = [[LMYInfiniteScrollView alloc] init];
    [self addSubview:handpickScrollView];
    self.handpickScrollView = handpickScrollView ;
}

#pragma mark - 数据相关
- (void)p_loadAdPickid
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",baseURL,Home_adPickid];
    __weak typeof(self) weakSelf = self ;
    [LMYNetworkTool lmy_get:urlStr params:nil success:^(id response) {
//        NSLog(@"%@",response);
        if ([response[@"ok"] isEqual:@1]) {
            NSArray *handpicks = [LMYHomeHandpick mj_objectArrayWithKeyValuesArray:response[@"result"]];
            NSMutableArray *imageUrls = [NSMutableArray array];
            NSMutableArray *descTitles = [NSMutableArray array];
            for (LMYHomeHandpick *handpick in handpicks) {
                if(![handpick.picture isEqualToString:@""] && ![handpick.custom_title isEqualToString:@""]){
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
        NSLog(@"轮播图ID:%@",error);
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
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.handpickScrollView.frame = self.bounds ;
    
}

@end
