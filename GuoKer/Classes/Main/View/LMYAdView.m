//
//  LMYAdView.m
//  GuoKer
//
//  Created by Lumo on 16/8/11.
//  Copyright © 2016年 LM. All rights reserved.
//

#import "LMYAdView.h"

@interface LMYAdView()
@property (nonatomic, weak) UIImageView *imageView ;
@property (nonatomic, weak) UIImageView *logoImageView ;

@end

@implementation LMYAdView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"advert_4_320x480_"];
        [self addSubview:imageView];
        self.imageView = imageView ;
        
        UIImageView *logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo_cover_100x50_"]];
        [self addSubview:logoImageView];
        self.logoImageView = logoImageView;

    }
    return self; 
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.frame = self.bounds ;
    self.logoImageView.centerX = self.width * 0.5 ;
    self.logoImageView.y = self.height - self.logoImageView.height - AdView_logoBottonMargin ;
}

@end
