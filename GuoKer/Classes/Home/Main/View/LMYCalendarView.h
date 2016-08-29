//
//  LMYCalendarView.h
//  GuoKer
//
//  Created by Lumo on 16/8/12.
//  Copyright © 2016年 LM. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LMYArticleModel ;
@interface LMYCalendarView : UIView
@property (nonatomic,strong) LMYArticleModel *articleModel ;
- (CGFloat)calendarViewHeight:(LMYArticleModel *)articleModel;
@end
