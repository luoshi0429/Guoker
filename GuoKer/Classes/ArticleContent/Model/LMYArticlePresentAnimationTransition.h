//
//  LMYArticlePresentAnimationTransition.h
//  GuoKer
//
//  Created by Lumo on 16/8/30.
//  Copyright © 2016年 LM. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger,LMYArticlePresentAnimationTransitionType) {
    LMYArticlePresentAnimationTransitionTypePresent = 0 ,
    LMYArticlePresentAnimationTransitionTypeDismiss 
};
@interface LMYArticlePresentAnimationTransition : NSObject<UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) CGRect fromRect ;

//+ (instancetype)transitionType:(LMYArticlePresentAnimationTransitionType)type;
//- (instancetype)initWithTransitionType:(LMYArticlePresentAnimationTransitionType)type;
@end
