//
//  LMYScrollView.m
//  侧边栏Demo
//
//  Created by Lumo on 16/8/6.
//  Copyright © 2016年 LM. All rights reserved.
//

#import "LMYScrollView.h"
@interface LMYScrollView()<UIGestureRecognizerDelegate>

@end


@implementation LMYScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.panGestureRecognizer.delegate = self;
    }
    return self;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    
    if ([otherGestureRecognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]] ) {
        [gestureRecognizer requireGestureRecognizerToFail:otherGestureRecognizer];
        return YES ;
    }
    
    if ([NSStringFromClass(otherGestureRecognizer.class) isEqualToString:@"UIPanGestureRecognizer"]) {
        [gestureRecognizer requireGestureRecognizerToFail:otherGestureRecognizer];
        return YES ;
    }
    return NO ;
}


@end
